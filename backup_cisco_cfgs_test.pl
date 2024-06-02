#!/usr/bin/env perl 

=pod

=head1 Using the script for create backup of Cisco running configs
#===============================================================================
#
#         FILE: backup_cisco_cfgs_test.pl
#
#        USAGE: cpanm install Net::OpenSSH
#        		./backup_cisco_cfgs_test.pl  
#
#  DESCRIPTION: Create Cisco running configs backup
#
#      OPTIONS: ---
# REQUIREMENTS: Perl v5.14+
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Vladislav Sapunov 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 02.06.2024 16:43:52
#     REVISION: ---
#===============================================================================
=cut

use strict;
use warnings;
use v5.14;
use utf8;
use Net::OpenSSH;
use POSIX 'strftime';
my $timestamp=strftime('%Y-%m-%dT%H-%M-%S', localtime());
say "$timestamp";
my $backupLogin="snpa";
my $backupPassword="iwaicnecrm";
my @cisco=('127.0.0.1', '127.0.0.2', '10.210.10.112');
foreach my $ciscoHost (@cisco) {
	chomp($ciscoHost);
	eval {
		my $ssh=Net::OpenSSH->new("$backupLogin\@$ciscoHost", password=>$backupPassword, timeout=>30);
		$ssh->error and die "Unable to connect: ". $ssh->error;
		say "Connected to $ciscoHost";
		my $shRun=$ssh->capture("show running-config");
		
		say "$shRun";
		say "#"x30;
		
	undef $ssh;
};

if($@) {
	say "Date: $timestamp Host: $ciscoHost Error: $@";
}
}



Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbZJQUrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbZJQUrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 16:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZJQUrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 16:47:17 -0400
Received: from mail.perches.com ([173.55.12.10]:2237 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbZJQUrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 16:47:16 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, Greg KH <greg@kroah.com>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] scripts/get_maintainer.pl: Add --roles and --rolestats
Date: Sat, 17 Oct 2009 13:47:20 -0700
Message-Id: <6a3d8d2c4775189d3f854bdd25a87b0d2e37987e.1255811956.git.joe@perches.com>
X-Mailer: git-send-email 1.6.5.rc3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--roles shows the role of each email address, i.e. why it was selected.
--rolestats selects --roles and adds git log/blame signers #'s and %

Multiple roles are possible (supporter, maintainer, git-signer...)

--roles or --rolestats is meant to help identify appropriate maintainers
to notify and should not be used with "git send-email --cc-cmd"

Example output:

Existing:

$ ./scripts/get_maintainer.pl -f arch/x86/kernel/acpi/boot.c
Corentin Chary <corentincj@iksaif.net>
Karol Kozimor <sziwan@users.sourceforge.net>
Len Brown <len.brown@intel.com>
Pavel Machek <pavel@ucw.cz>
Rafael J. Wysocki <rjw@sisk.pl>
Thomas Gleixner <tglx@linutronix.de>
Ingo Molnar <mingo@redhat.com>
H. Peter Anvin <hpa@zytor.com>
x86@kernel.org
Yinghai Lu <yhlu.kernel@gmail.com>
Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
acpi4asus-user@lists.sourceforge.net
linux-pm@lists.linux-foundation.org
linux-kernel@vger.kernel.org

With --roles

$ ./scripts/get_maintainer.pl --roles -f arch/x86/kernel/acpi/boot.c
Corentin Chary <corentincj@iksaif.net> (maintainer:ASUS ACPI EXTRAS...)
Karol Kozimor <sziwan@users.sourceforge.net> (maintainer:ASUS ACPI EXTRAS...)
Len Brown <len.brown@intel.com> (supporter:SUSPEND TO RAM,git-signer)
Pavel Machek <pavel@ucw.cz> (supporter:SUSPEND TO RAM)
Rafael J. Wysocki <rjw@sisk.pl> (supporter:SUSPEND TO RAM)
Thomas Gleixner <tglx@linutronix.de> (maintainer:X86 ARCHITECTURE...)
Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE...,git-signer)
H. Peter Anvin <hpa@zytor.com> (maintainer:X86 ARCHITECTURE...)
x86@kernel.org (maintainer:X86 ARCHITECTURE...)
Yinghai Lu <yhlu.kernel@gmail.com> (git-signer)
Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com> (git-signer)
acpi4asus-user@lists.sourceforge.net (open list:ASUS ACPI EXTRAS...)
linux-pm@lists.linux-foundation.org (open list:SUSPEND TO RAM)
linux-kernel@vger.kernel.org (open list)

With --rolestats

$ ./scripts/get_maintainer.pl --rolestats -f arch/x86/kernel/acpi/boot.c
Corentin Chary <corentincj@iksaif.net> (maintainer:ASUS ACPI EXTRAS...)
Karol Kozimor <sziwan@users.sourceforge.net> (maintainer:ASUS ACPI EXTRAS...)
Len Brown <len.brown@intel.com> (supporter:SUSPEND TO RAM,git-signer:16/79=20%)
Pavel Machek <pavel@ucw.cz> (supporter:SUSPEND TO RAM)
Rafael J. Wysocki <rjw@sisk.pl> (supporter:SUSPEND TO RAM)
Thomas Gleixner <tglx@linutronix.de> (maintainer:X86 ARCHITECTURE...)
Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE...,git-signer:29/79=37%)
H. Peter Anvin <hpa@zytor.com> (maintainer:X86 ARCHITECTURE...)
x86@kernel.org (maintainer:X86 ARCHITECTURE...)
Yinghai Lu <yhlu.kernel@gmail.com> (git-signer:12/79=15%)
Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com> (git-signer:6/79=8%)
acpi4asus-user@lists.sourceforge.net (open list:ASUS ACPI EXTRAS...)
linux-pm@lists.linux-foundation.org (open list:SUSPEND TO RAM)
linux-kernel@vger.kernel.org (open list)

With --rolestats and --git-blame

$ ./scripts/get_maintainer.pl --rolestats --git-blame -f arch/x86/kernel/acpi/boot.c
Corentin Chary <corentincj@iksaif.net> (maintainer:ASUS ACPI EXTRAS...)
Karol Kozimor <sziwan@users.sourceforge.net> (maintainer:ASUS ACPI EXTRAS...)
Len Brown <len.brown@intel.com> (supporter:SUSPEND TO RAM,git-signer:16/79=20%,commits:22/154=14%)
Pavel Machek <pavel@ucw.cz> (supporter:SUSPEND TO RAM)
Rafael J. Wysocki <rjw@sisk.pl> (supporter:SUSPEND TO RAM)
Thomas Gleixner <tglx@linutronix.de> (maintainer:X86 ARCHITECTURE...)
Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE...,git-signer:29/79=37%,commits:36/154=23%)
H. Peter Anvin <hpa@zytor.com> (maintainer:X86 ARCHITECTURE...)
x86@kernel.org (maintainer:X86 ARCHITECTURE...)
Yinghai Lu <yhlu.kernel@gmail.com> (git-signer:12/79=15%,commits:9/154=6%)
Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com> (git-signer:6/79=8%)
Andi Kleen <ak@suse.de> (commits:11/154=7%)
Andrew Morton <akpm@osdl.org> (commits:10/154=6%)
acpi4asus-user@lists.sourceforge.net (open list:ASUS ACPI EXTRAS...)
linux-pm@lists.linux-foundation.org (open list:SUSPEND TO RAM)
linux-kernel@vger.kernel.org (open list)

Other changes:

Format git-signers email addresses a bit to reduce bad signatures
Command line bad arguments emitted a verbose usage(), just show --help
Version number bumped to .22

Ben Hutchings <ben@decadent.org.uk> had the idea and created a good deal
of this implementation.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |  194 ++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 176 insertions(+), 18 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 102b766..638c209 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.21';
+my $V = '0.22';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -33,6 +33,8 @@ my $email_git_blame = 0;
 my $email_remove_duplicates = 1;
 my $output_multiline = 1;
 my $output_separator = ", ";
+my $output_roles = 0;
+my $output_rolestats = 0;
 my $scm = 0;
 my $web = 0;
 my $subsystem = 0;
@@ -79,6 +81,8 @@ if (!GetOptions(
 		'l!' => \$email_list,
 		's!' => \$email_subscriber_list,
 		'multiline!' => \$output_multiline,
+		'roles!' => \$output_roles,
+		'rolestats!' => \$output_rolestats,
 		'separator=s' => \$output_separator,
 		'subsystem!' => \$subsystem,
 		'status!' => \$status,
@@ -90,8 +94,7 @@ if (!GetOptions(
 		'v|version' => \$version,
 		'h|help' => \$help,
 		)) {
-    usage();
-    die "$P: invalid argument\n";
+    die "$P: invalid argument - use --help if necessary\n";
 }
 
 if ($help != 0) {
@@ -113,6 +116,10 @@ if ($output_separator ne ", ") {
     $output_multiline = 0;
 }
 
+if ($output_rolestats) {
+    $output_roles = 1;
+}
+
 my $selections = $email + $scm + $status + $subsystem + $web;
 if ($selections == 0) {
     usage();
@@ -326,9 +333,9 @@ if ($email) {
 
 	    $email_address = format_email($1, $2);
 	    if ($email_git_penguin_chiefs) {
-		push(@email_to, $email_address);
+		push(@email_to, [$email_address, 'chief penguin']);
 	    } else {
-		@email_to = grep(!/${email_address}/, @email_to);
+		@email_to = grep($_->[0] !~ /${email_address}/, @email_to);
 	    }
 	}
     }
@@ -342,7 +349,7 @@ if ($email || $email_list) {
     if ($email_list) {
 	@to = (@to, @list_to);
     }
-    output(uniq(@to));
+    output(merge_email(@to));
 }
 
 if ($scm) {
@@ -405,6 +412,8 @@ MAINTAINER field selection options:
     --l => include list(s) if any
     --s => include subscriber only list(s) if any
     --remove-duplicates => minimize duplicate email names/addresses
+    --roles => show roles (status:subsystem, git-signer, list, etc...)
+    --rolestats => show roles and statistics (commits/total_commits, %)
   --scm => print SCM tree(s) if any
   --status => print status if any
   --subsystem => print subsystem name if any
@@ -435,6 +444,13 @@ Notes:
       Used with "--git-blame", does not iterate all files in directory
   Using "--git-blame" is slow and may add old committers and authors
       that are no longer active maintainers to the output.
+  Using "--roles" or "--rolestats" with git send-email --cc-cmd or any
+      other automated tools that expect only ["name"] <email address>
+      may not work because of additional output after <email address>.
+  Using "--rolestats" and "--git-blame" shows the #/total=% commits,
+      not the percentage of the entire file authored.  # of commits is
+      not a good measure of amount of code authored.  1 major commit may
+      contain a thousand lines, 5 trivial commits may modify a single line.
 EOT
 }
 
@@ -547,6 +563,71 @@ sub find_ending_index {
     return $index;
 }
 
+sub get_maintainer_role {
+    my ($index) = @_;
+
+    my $i;
+    my $start = find_starting_index($index);
+    my $end = find_ending_index($index);
+
+    my $role;
+    my $subsystem = $typevalue[$start];
+    if (length($subsystem) > 20) {
+	$subsystem = substr($subsystem, 0, 17);
+	$subsystem =~ s/\s*$//;
+	$subsystem = $subsystem . "...";
+    }
+
+    for ($i = $start + 1; $i < $end; $i++) {
+	my $tv = $typevalue[$i];
+	if ($tv =~ m/^(\C):\s*(.*)/) {
+	    my $ptype = $1;
+	    my $pvalue = $2;
+	    if ($ptype eq "S") {
+		$role = $pvalue;
+	    }
+	}
+    }
+
+    $role = lc($role);
+    if      ($role eq "supported") {
+	$role = "supporter";
+    } elsif ($role eq "maintained") {
+	$role = "maintainer";
+    } elsif ($role eq "odd fixes") {
+	$role = "odd fixer";
+    } elsif ($role eq "orphan") {
+	$role = "orphan minder";
+    } elsif ($role eq "obsolete") {
+	$role = "obsolete minder";
+    } elsif ($role eq "buried alive in reporters") {
+	$role = "chief penguin";
+    }
+
+    return $role . ":" . $subsystem;
+}
+
+sub get_list_role {
+    my ($index) = @_;
+
+    my $i;
+    my $start = find_starting_index($index);
+    my $end = find_ending_index($index);
+
+    my $subsystem = $typevalue[$start];
+    if (length($subsystem) > 20) {
+	$subsystem = substr($subsystem, 0, 17);
+	$subsystem =~ s/\s*$//;
+	$subsystem = $subsystem . "...";
+    }
+
+    if ($subsystem eq "THE REST") {
+	$subsystem = "";
+    }
+
+    return $subsystem;
+}
+
 sub add_categories {
     my ($index) = @_;
 
@@ -564,17 +645,22 @@ sub add_categories {
 	    if ($ptype eq "L") {
 		my $list_address = $pvalue;
 		my $list_additional = "";
+		my $list_role = get_list_role($i);
+
+		if ($list_role ne "") {
+		    $list_role = ":" . $list_role;
+		}
 		if ($list_address =~ m/([^\s]+)\s+(.*)$/) {
 		    $list_address = $1;
 		    $list_additional = $2;
 		}
 		if ($list_additional =~ m/subscribers-only/) {
 		    if ($email_subscriber_list) {
-			push(@list_to, $list_address);
+			push(@list_to, [$list_address, "subscriber list${list_role}"]);
 		    }
 		} else {
 		    if ($email_list) {
-			push(@list_to, $list_address);
+			push(@list_to, [$list_address, "open list${list_role}"]);
 		    }
 		}
 	    } elsif ($ptype eq "M") {
@@ -591,7 +677,8 @@ sub add_categories {
 		    }
 		}
 		if ($email_maintainer) {
-		    push_email_addresses($pvalue);
+		    my $role = get_maintainer_role($i);
+		    push_email_addresses($pvalue, $role);
 		}
 	    } elsif ($ptype eq "T") {
 		push(@scm, $pvalue);
@@ -618,7 +705,7 @@ sub email_inuse {
 }
 
 sub push_email_address {
-    my ($line) = @_;
+    my ($line, $role) = @_;
 
     my ($name, $address) = parse_email($line);
 
@@ -627,9 +714,9 @@ sub push_email_address {
     }
 
     if (!$email_remove_duplicates) {
-	push(@email_to, format_email($name, $address));
+	push(@email_to, [format_email($name, $address), $role]);
     } elsif (!email_inuse($name, $address)) {
-	push(@email_to, format_email($name, $address));
+	push(@email_to, [format_email($name, $address), $role]);
 	$email_hash_name{$name}++;
 	$email_hash_address{$address}++;
     }
@@ -638,24 +725,52 @@ sub push_email_address {
 }
 
 sub push_email_addresses {
-    my ($address) = @_;
+    my ($address, $role) = @_;
 
     my @address_list = ();
 
     if (rfc822_valid($address)) {
-	push_email_address($address);
+	push_email_address($address, $role);
     } elsif (@address_list = rfc822_validlist($address)) {
 	my $array_count = shift(@address_list);
 	while (my $entry = shift(@address_list)) {
-	    push_email_address($entry);
+	    push_email_address($entry, $role);
 	}
     } else {
-	if (!push_email_address($address)) {
+	if (!push_email_address($address, $role)) {
 	    warn("Invalid MAINTAINERS address: '" . $address . "'\n");
 	}
     }
 }
 
+sub add_role {
+    my ($line, $role) = @_;
+
+    my ($name, $address) = parse_email($line);
+    my $email = format_email($name, $address);
+
+    foreach my $entry (@email_to) {
+	if ($email_remove_duplicates) {
+	    my ($entry_name, $entry_address) = parse_email($entry->[0]);
+	    if ($name eq $entry_name || $address eq $entry_address) {
+		if ($entry->[1] eq "") {
+		    $entry->[1] = "$role";
+		} else {
+		    $entry->[1] = "$entry->[1],$role";
+		}
+	    }
+	} else {
+	    if ($email eq $entry->[0]) {
+		if ($entry->[1] eq "") {
+		    $entry->[1] = "$role";
+		} else {
+		    $entry->[1] = "$entry->[1],$role";
+		}
+	    }
+	}
+    }
+}
+
 sub which {
     my ($bin) = @_;
 
@@ -730,6 +845,10 @@ sub recent_git_signoffs {
     s/.*:\s*(.+)\s*/$1/ for (@lines);
 
     $total_sign_offs = @lines;
+    foreach my $line (@lines) {
+	my ($name, $address) = parse_email($line);
+	$line = format_email($name, $address);
+    }
 
     if ($email_remove_duplicates) {
 	@lines = mailmap(@lines);
@@ -743,11 +862,19 @@ sub recent_git_signoffs {
     # sort -rn
     foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
 	my $sign_offs = $hash{$line};
+	my $role;
+
 	$count++;
 	last if ($sign_offs < $email_git_min_signatures ||
 		 $count > $email_git_max_maintainers ||
 		 $sign_offs * 100 / $total_sign_offs < $email_git_min_percent);
-	push_email_address($line);
+	push_email_address($line, '');
+	$role = "git-signer";
+	if ($output_rolestats) {
+	    my $percent = sprintf("%.0f", $sign_offs * 100 / $total_sign_offs);
+	    $role = "$role:$sign_offs/$total_sign_offs=$percent%";
+	}
+	add_role($line, $role);
     }
 }
 
@@ -824,11 +951,23 @@ sub git_assign_blame {
     $count = 0;
     foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
 	my $sign_offs = $hash{$line};
+	my $role;
+
 	$count++;
 	last if ($sign_offs < $email_git_min_signatures ||
 		 $count > $email_git_max_maintainers ||
 		 $sign_offs * 100 / $total_sign_offs < $email_git_min_percent);
-	push_email_address($line);
+	push_email_address($line, '');
+	if ($from_filename) {
+	    $role = "commits";
+	} else {
+	    $role = "modified commits";
+	}
+	if ($output_rolestats) {
+	    my $percent = sprintf("%.0f", $sign_offs * 100 / $total_sign_offs);
+	    $role = "$role:$sign_offs/$total_sign_offs=$percent%";
+	}
+	add_role($line, $role);
     }
 }
 
@@ -849,6 +988,25 @@ sub sort_and_uniq {
     return @parms;
 }
 
+sub merge_email {
+    my @lines;
+    my %saw;
+
+    for (@_) {
+	my ($address, $role) = @$_;
+	if (!$saw{$address}) {
+	    if ($output_roles) {
+		push @lines, "$address ($role)";
+	    } else {
+		push @lines, $address;
+	    }
+	    $saw{$address} = 1;
+	}
+    }
+
+    return @lines;
+}
+
 sub output {
     my @parms = @_;
 
-- 
1.6.5.rc3.dirty


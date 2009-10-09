Return-Path: <linux-kernel-owner+w=401wt.eu-S1761159AbZJITCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761159AbZJITCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 15:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757549AbZJITCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 15:02:23 -0400
Received: from mail.perches.com ([173.55.12.10]:2023 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237AbZJITCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 15:02:22 -0400
Subject: Re: [RFC] scripts/get_maintainer: add emails based on keywords in
 the patch
From: Joe Perches <joe@perches.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       devicetree-discuss@ozlabs.org, Grant Likely <grant.likely@secretlab.ca>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
In-Reply-To: <1255087406.16347.108.camel@Joe-Laptop.home>
References: <1255084379-12954-1-git-send-email-w.sang@pengutronix.de>
	 <1255087406.16347.108.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Oct 2009 12:01:45 -0700
Message-Id: <1255114905.16347.137.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 04:23 -0700, Joe Perches wrote:
> If this facility is desired by many others, it might be
> better to have a separate file of 'regex generates email'
> read at initialization.

Perhaps it's better to use the existing MAINTAINERS file
and extend it with a new "K:" for keyword entry.

This patch is a bit longer than necessary because the
MAINTAINERS initial descriptions are moved around a bit.

Perhaps something like this:

 MAINTAINERS               |   71 +++++++++++++++++++++++++-------------------
 scripts/get_maintainer.pl |   24 +++++++++++----
 2 files changed, 57 insertions(+), 38 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e1da925..9e1263f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -65,43 +65,47 @@ trivial patch so apply some common sense.
 
 8.	Happy hacking.
 
-		-----------------------------------
-
-Maintainers List (try to look for most precise areas first)
+Descriptions of section entries:
+
+	P: Person (obsolete)
+	M: Mail patches to: FullName <address@domain>
+	L: Mailing list that is relevant to this area
+	W: Web-page with status/info
+	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
+	S: Status, one of the following:
+	   Supported:	Someone is actually paid to look after this.
+	   Maintained:	Someone actually looks after it.
+	   Odd Fixes:	It has a maintainer but they don't have time to do
+			much other than throw the odd patch in. See below..
+	   Orphan:	No current maintainer [but maybe you could take the
+			role as you write your new code].
+	   Obsolete:	Old code. Something tagged obsolete generally means
+			it has been replaced by a better system and you
+			should be using that.
+	F: Files and directories with wildcard patterns.
+	   A trailing slash includes all files and subdirectory files.
+	   F:	drivers/net/	all files in and below drivers/net
+	   F:	drivers/net/*	all files in drivers/net, but not below
+	   F:	*/net/*		all files in "any top level directory"/net
+	   One pattern per line.  Multiple F: lines acceptable.
+	X: Files and directories that are NOT maintained, same rules as F:
+	   Files exclusions are tested before file matches.
+	   Can be useful for excluding a specific subdirectory, for instance:
+	   F:	net/
+	   X:	net/ipv6/
+	   matches all files in and below net excluding net/ipv6/
+	K: Keyword perl regex pattern to match content in patch
+	   All patterns are surrounded by "\b"
+	   for instance: K: of_get_profile
+	   will match patches that contain the word "of_get_profile"
 
 Note: For the hard of thinking, this list is meant to remain in alphabetical
 order. If you could add yourselves to it in alphabetical order that would be
 so much easier [Ed]
 
-P: Person (obsolete)
-M: Mail patches to: FullName <address@domain>
-L: Mailing list that is relevant to this area
-W: Web-page with status/info
-T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
-S: Status, one of the following:
-
-	Supported:	Someone is actually paid to look after this.
-	Maintained:	Someone actually looks after it.
-	Odd Fixes:	It has a maintainer but they don't have time to do
-			much other than throw the odd patch in. See below..
-	Orphan:		No current maintainer [but maybe you could take the
-			role as you write your new code].
-	Obsolete:	Old code. Something tagged obsolete generally means
-			it has been replaced by a better system and you
-			should be using that.
+Maintainers List (try to look for most precise areas first)
 
-F: Files and directories with wildcard patterns.
-   A trailing slash includes all files and subdirectory files.
-	F:	drivers/net/	all files in and below drivers/net
-	F:	drivers/net/*	all files in drivers/net, but not below
-	F:	*/net/*		all files in "any top level directory"/net
-   One pattern per line.  Multiple F: lines acceptable.
-X: Files and directories that are NOT maintained, same rules as F:
-   Files exclusions are tested before file matches.
-   Can be useful for excluding a specific subdirectory, for instance:
-	F:	net/
-	X:	net/ipv6/
-   matches all files in and below net excluding net/ipv6/
+		-----------------------------------
 
 3C505 NETWORK DRIVER
 M:	Philip Blundell <philb@gnu.org>
@@ -3876,6 +3880,11 @@ S:	Maintained
 F:	Documentation/i2c/busses/i2c-ocores
 F:	drivers/i2c/busses/i2c-ocores.c
 
+OPEN FIRMWARE DEVICE TREE
+L:	devicetree-discuss@lists.ozlabs.org
+S:	Odd Fixes
+K:	of_get_property
+
 OPROFILE
 M:	Robert Richter <robert.richter@amd.com>
 L:	oprofile-list@lists.sf.net
diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index cdb44b6..657711c 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -132,6 +132,8 @@ if (!top_of_kernel_tree($lk_path)) {
 ## Read MAINTAINERS for type/value pairs
 
 my @typevalue = ();
+my %keyword_hash;
+
 open(MAINT, "<${lk_path}MAINTAINERS") || die "$P: Can't open MAINTAINERS\n";
 while (<MAINT>) {
     my $line = $_;
@@ -149,6 +151,8 @@ while (<MAINT>) {
 	    if ((-d $value)) {
 		$value =~ s@([^/])$@$1/@;
 	    }
+	} elsif ($type eq "K") {
+	    $keyword_hash{@typevalue} = $value;
 	}
 	push(@typevalue, "$type:$value");
     } elsif (!/^(\s)*$/) {
@@ -188,6 +192,12 @@ if ($email_remove_duplicates) {
 
 my @files = ();
 my @range = ();
+my @email_to = ();
+my @list_to = ();
+my @scm = ();
+my @web = ();
+my @subsystem = ();
+my @status = ();
 
 foreach my $file (@ARGV) {
     ##if $file is a directory and it lacks a trailing slash, add one
@@ -203,6 +213,7 @@ foreach my $file (@ARGV) {
 	my $lastfile;
 	open(PATCH, "<$file") or die "$P: Can't open ${file}\n";
 	while (<PATCH>) {
+	    my $patch_line = $_;
 	    if (m/^\+\+\+\s+(\S+)/) {
 		my $filename = $1;
 		$filename =~ s@^[^/]*/@@;
@@ -213,6 +224,12 @@ foreach my $file (@ARGV) {
 		if ($email_git_blame) {
 		    push(@range, "$lastfile:$1:$2");
 		}
+	    } else {
+		foreach my $line (keys %keyword_hash) {
+		    if ($patch_line =~ m/^[+-].*\b$keyword_hash{$line}\b/o) {
+			add_categories($line);
+		    }
+		}
 	    }
 	}
 	close(PATCH);
@@ -224,13 +241,6 @@ foreach my $file (@ARGV) {
     }
 }
 
-my @email_to = ();
-my @list_to = ();
-my @scm = ();
-my @web = ();
-my @subsystem = ();
-my @status = ();
-
 # Find responsible parties
 
 foreach my $file (@files) {



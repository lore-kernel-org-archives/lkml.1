Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab0BZVGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:06:17 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:30839 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab0BZVGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:06:15 -0500
Message-ID: <4B8837BB.1000609@oracle.com>
Date: Fri, 26 Feb 2010 13:06:03 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 2/2] scripts/kernel-doc: drop the -filelist option, it doesn't
 work
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B8837B6.0079:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>
Subject: kernel-doc: drop the -filelist option, it doesn't work

I also found the -filelist option, but apparently the implementation
is broken, and it was broken from the very first git commit.
For the -filelist option I suggest the removal (I wasn't able to find
any users of it, moreover it's not even listed in the
usage() output, so presumably nobody knows about it).

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

--- linux-2.6.33-rc3-git5.orig/scripts/kernel-doc
+++ linux-2.6.33-rc3-git5/scripts/kernel-doc
@@ -13,8 +13,6 @@ use strict;
 ## This software falls under the GNU General Public License.     ##
 ## Please read the COPYING file for more information             ##
 
-# w.o. 03-11-2000: added the '-filelist' option.
-
 # 18/01/2001 - 	Cleanups
 # 		Functions prototyped as foo(void) same as foo()
 # 		Stop eval'ing where we don't need to.
@@ -245,7 +243,7 @@ my $man_date = ('January', 'February', '
 # could cause "use of undefined value" or other bugs.
 my ($function, %function_table, %parametertypes, $declaration_purpose);
 my ($type, $declaration_name, $return_type);
-my ($newsection, $newcontents, $prototype, $filelist, $brcount, %source_map);
+my ($newsection, $newcontents, $prototype, $brcount, %source_map);
 
 if (defined($ENV{'KBUILD_VERBOSE'})) {
 	$verbose = "$ENV{'KBUILD_VERBOSE'}";
@@ -338,8 +336,6 @@ while ($ARGV[0] =~ m/^-(.*)/) {
 	$verbose = 1;
     } elsif (($cmd eq "-h") || ($cmd eq "--help")) {
 	usage();
-    } elsif ($cmd eq '-filelist') {
-	    $filelist = shift @ARGV;
     } elsif ($cmd eq '-no-doc-sections') {
 	    $no_doc_sections = 1;
     }
@@ -1811,14 +1807,6 @@ if (open(SOURCE_MAP, "<.tmp_filelist.txt
 	close(SOURCE_MAP);
 }
 
-if ($filelist) {
-	open(FLIST,"<$filelist") or die "Can't open file list $filelist";
-	while(<FLIST>) {
-		chop;
-		process_file($_);
-	}
-}
-
 foreach (@ARGV) {
     chomp;
     process_file($_);

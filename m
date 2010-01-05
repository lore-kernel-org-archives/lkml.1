Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783Ab0AEUol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab0AEUol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817Ab0AEUok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:44:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49705 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab0AEUoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:44:39 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH V2] tracing/recordmount.pl: use apropriate perl-constructs
Date: Tue,  5 Jan 2010 21:41:22 +0100
Message-Id: <1262724082-9517-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1262719455.28171.1663.camel@gandalf.stny.rr.com>
References: <1262719455.28171.1663.camel@gandalf.stny.rr.com>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SA Timed out after 240 secs
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...and add a comment where they are not wanted.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---

Changes since V1:

* dropped the ||=-idiom and simplified the current code

Had to change the syntax for this block again, as "$cc == ''" produces warnings
with 'perl -w' (same for using 'eq'). I hope this version now is also readable
for C-hackers ;) Sorry for the noise here.

* removed the change for $print_warning

 scripts/recordmcount.pl |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 5de12c7..90f2be2 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -136,13 +136,14 @@ my %text_sections = (
      ".text.unlikely" => 1,
 );
 
-$objdump = "objdump" if ((length $objdump) == 0);
-$objcopy = "objcopy" if ((length $objcopy) == 0);
-$cc = "gcc" if ((length $cc) == 0);
-$ld = "ld" if ((length $ld) == 0);
-$nm = "nm" if ((length $nm) == 0);
-$rm = "rm" if ((length $rm) == 0);
-$mv = "mv" if ((length $mv) == 0);
+# Note: we are nice to C-programmers here, thus we skip the '||='-idiom.
+$objdump = 'objdump' if (!$objdump);
+$objcopy = 'objcopy' if (!$objcopy);
+$cc = 'gcc' if (!$cc);
+$ld = 'ld' if (!$ld);
+$nm = 'nm' if (!$nm);
+$rm = 'rm' if (!$rm);
+$mv = 'mv' if (!$mv);
 
 #print STDERR "running: $P '$arch' '$objdump' '$objcopy' '$cc' '$ld' " .
 #    "'$nm' '$rm' '$mv' '$inputfile'\n";
@@ -194,12 +195,8 @@ sub check_objcopy
     }
 }
 
-if ($arch eq "x86") {
-    if ($bits == 64) {
-	$arch = "x86_64";
-    } else {
-	$arch = "i386";
-    }
+if ($arch eq 'x86') {
+    $arch = ($bits == 64) ? 'x86_64' : 'i386';
 }
 
 #
@@ -476,11 +473,7 @@ while (<IN>) {
 	$read_headers = 0;
 
 	# Only record text sections that we know are safe
-	if (defined($text_sections{$1})) {
-	    $read_function = 1;
-	} else {
-	    $read_function = 0;
-	}
+	$read_function = defined($text_sections{$1});
 	# print out any recorded offsets
 	update_funcs();
 
-- 
1.6.3.3


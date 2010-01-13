Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424Ab0AMKYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab0AMKYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932070Ab0AMKYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:24:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:37932 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369Ab0AMKYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:24:21 -0500
Date: Wed, 13 Jan 2010 10:23:55 GMT
From: tip-bot for Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, w.sang@pengutronix.de, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, w.sang@pengutronix.de, tglx@linutronix.de
In-Reply-To: <1262724082-9517-1-git-send-email-w.sang@pengutronix.de>
References: <1262724082-9517-1-git-send-email-w.sang@pengutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Use appropriate perl constructs in recordmcount.pl
Message-ID: <tip-dfaa9e2c5707b2c217c0121aac796e0fa3051482@git.kernel.org>
Git-Commit-ID: dfaa9e2c5707b2c217c0121aac796e0fa3051482
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:23:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dfaa9e2c5707b2c217c0121aac796e0fa3051482
Gitweb:     http://git.kernel.org/tip/dfaa9e2c5707b2c217c0121aac796e0fa3051482
Author:     Wolfram Sang <w.sang@pengutronix.de>
AuthorDate: Tue, 5 Jan 2010 21:41:22 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 6 Jan 2010 18:08:58 -0500

tracing: Use appropriate perl constructs in recordmcount.pl

Modified recordmcount.pl to use perl constructs that are still
understandable by C hackers that are not perl programmers.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
LKML-Reference: <1262724082-9517-1-git-send-email-w.sang@pengutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.pl |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 5de12c7..545fe71 100755
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
 

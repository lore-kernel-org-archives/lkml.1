Return-Path: <linux-kernel-owner+w=401wt.eu-S933020Ab0AFXPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab0AFXPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932656Ab0AFXPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:15:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60484 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab0AFXPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:15:37 -0500
X-Authority-Analysis: v=1.0 c=1 a=ypJXi30cjqsA:10 a=meVymXHHAAAA:8 a=b7U4aDOeHw7s30zpFDIA:9 a=MvOzKO0E9Lmf5UUdgKF4L-GAthMA:4 a=XNN-oNMjSfgA:10 a=jeBq3FmKZ4MA:10 a=QxREhUQXPSKRjfz4:21 a=vJgT1E4iEQA7hs6R:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100106231533.895223898@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jan 2010 18:13:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 10/11] tracing: Use appropriate perl constructs in recordmcount.pl
References: <20100106231349.107649729@goodmis.org>
Content-Disposition: inline; filename=0010-tracing-Use-appropriate-perl-constructs-in-recordmco.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <w.sang@pengutronix.de>

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
 
-- 
1.6.5



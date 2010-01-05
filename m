Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283Ab0AES2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0AES2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 13:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233Ab0AES16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 13:27:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43243 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab0AES14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 13:27:56 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, Wolfram Sang <w.sang@pengutronix.de>
Date: Tue,  5 Jan 2010 19:27:52 +0100
Message-Id: <1262716072-14414-3-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1262716072-14414-2-git-send-email-w.sang@pengutronix.de>
References: <1262716072-14414-1-git-send-email-w.sang@pengutronix.de>
 <1262716072-14414-2-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 2/2] tracing/recordmount.pl: use apropriate perl-constructs
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 scripts/recordmcount.pl |   33 ++++++++++++---------------------
 1 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 5de12c7..59b73b9 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -136,13 +136,13 @@ my %text_sections = (
      ".text.unlikely" => 1,
 );
 
-$objdump = "objdump" if ((length $objdump) == 0);
-$objcopy = "objcopy" if ((length $objcopy) == 0);
-$cc = "gcc" if ((length $cc) == 0);
-$ld = "ld" if ((length $ld) == 0);
-$nm = "nm" if ((length $nm) == 0);
-$rm = "rm" if ((length $rm) == 0);
-$mv = "mv" if ((length $mv) == 0);
+$objdump ||= 'objdump';
+$objcopy ||= 'objcopy';
+$cc ||= 'gcc';
+$ld ||= 'ld';
+$nm ||= 'nm';
+$rm ||= 'rm';
+$mv ||= 'mv';
 
 #print STDERR "running: $P '$arch' '$objdump' '$objcopy' '$cc' '$ld' " .
 #    "'$nm' '$rm' '$mv' '$inputfile'\n";
@@ -163,9 +163,8 @@ my $section_type;	# Section header plus possible alignment command
 my $can_use_local = 0; 	# If we can use local function references
 
 # Shut up recordmcount if user has older objcopy
-my $quiet_recordmcount = ".tmp_quiet_recordmcount";
-my $print_warning = 1;
-$print_warning = 0 if ( -f $quiet_recordmcount);
+my $quiet_recordmcount = '.tmp_quiet_recordmcount';
+my $print_warning = (! -f $quiet_recordmcount);
 
 ##
 # check_objcopy - whether objcopy supports --globalize-symbols
@@ -194,12 +193,8 @@ sub check_objcopy
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
@@ -476,11 +471,7 @@ while (<IN>) {
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


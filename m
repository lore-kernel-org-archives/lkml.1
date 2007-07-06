Return-Path: <linux-kernel-owner+w=401wt.eu-S1762070AbXGFHAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762070AbXGFHAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759245AbXGFHA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:00:26 -0400
Received: from canuck.infradead.org ([209.217.80.40]:43417 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758960AbXGFHAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:00:25 -0400
Subject: [PATCH] Check charset in scripts/checkpatch.pl
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 06 Jul 2007 03:01:03 -0400
Message-Id: <1183705264.2747.20.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reject all legacy 8-bit character sets and allow only ASCII or UTF-8 to
be added to files or used in patch descriptions.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>

Signed-off-by: asd
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 277c326..7a7f283 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -395,6 +395,22 @@ sub process {
 			$clean = 0;
 		}
 
+# UTF-8 regex found at http://www.w3.org/International/questions/qa-forms-utf-8.en.php
+		if ( ($realfile =~ /^$/ || $line =~ /^\+/) &&
+		     !($line =~ m/^(
+				[\x09\x0A\x0D\x20-\x7E]              # ASCII
+				| [\xC2-\xDF][\x80-\xBF]             # non-overlong 2-byte
+				|  \xE0[\xA0-\xBF][\x80-\xBF]        # excluding overlongs
+				| [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2}  # straight 3-byte
+				|  \xED[\x80-\x9F][\x80-\xBF]        # excluding surrogates
+				|  \xF0[\x90-\xBF][\x80-\xBF]{2}     # planes 1-3
+				| [\xF1-\xF3][\x80-\xBF]{3}          # planes 4-15
+				|  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
+				)*$/x ) ) {
+			print "Invalid UTF-8\n";
+			print "$herecurr";
+			$clean = 0;
+		}
 #ignore lines being removed
 		if ($line=~/^-/) {next;}
 


-- 
dwmw2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbYARNVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbYARNVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbYARNVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:21:06 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:57951 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353AbYARNVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:21:05 -0500
To: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.24-rc8-mm1] checkpatch.pl -- Handle backslashes within quoted string.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200801182221.CID64509.JSMOFHtOFLVQFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Fri, 18 Jan 2008 22:21:00 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch.pl was unable to handle \\ within quoted string.

+static void test(char *sp, char *dp)
+{
+       if (*sp == '\\') {
+               *dp++ = '\\';
+               *dp++ = '\\';
+       }
+}

I hope this patch can fix it.
But I don't know whether there is a side effect or not.
Should we use "X" rather than "\\"?

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 scripts/checkpatch.pl |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- linux-2.6-mm.orig/scripts/checkpatch.pl
+++ linux-2.6-mm/scripts/checkpatch.pl
@@ -276,6 +276,11 @@ sub sanitise_line {
 	my $quote = '';
 
 	foreach my $c (split(//, $line)) {
+		if ($quote && $l eq "\\" && $c eq "\\") {
+			$res .= "\\";
+			$l = '';
+			next;
+		}
 		if ($l ne "\\" && ($c eq "'" || $c eq '"')) {
 			if ($quote eq '') {
 				$quote = $c;
@@ -286,7 +291,7 @@ sub sanitise_line {
 				$quote = '';
 			}
 		}
-		if ($quote && $c ne "\t") {
+		if ($quote && $c ne "\t" && $c ne "\\") {
 			$res .= "X";
 		} else {
 			$res .= $c;

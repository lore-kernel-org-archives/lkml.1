Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbYA2XRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbYA2XRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbYA2XRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:17:43 -0500
Received: from de01egw01.freescale.net ([192.88.165.102]:42010 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbYA2XRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:17:42 -0500
From: Timur Tabi <timur@freescale.com>
To: apw@shadowen.org, linux-kernel@vger.kernel.org
Cc: Timur Tabi <timur@freescale.com>
Subject: [PATCH] checkpatch: add __asm__ to function-space-paren exception list
Date: Tue, 29 Jan 2008 17:17:28 -0600
Message-Id: <12016486482483-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch.pl thinks that __asm__ is a function name, so it complains about
a space between the function name and a parenthesis when it sees
"__asm__ ("mov ax,bx")".

This change will also encourage developers to use '__asm__' instead of 'asm'.

Signed-off-by: Timur Tabi <timur@freescale.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 579f50f..971c822 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1115,7 +1115,7 @@ sub process {
 
 # check for spaces between functions and their parentheses.
 		while ($line =~ /($Ident)\s+\(/g) {
-			if ($1 !~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright|case)$/ &&
+			if ($1 !~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright|case|__asm__)$/ &&
 		            $line !~ /$Type\s+\(/ && $line !~ /^.\#\s*define\b/) {
 				WARN("no space between function name and open parenthesis '('\n" . $herecurr);
 			}
-- 
1.5.2.4


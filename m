Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbYLGSey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbYLGSey (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbYLGSbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:31:35 -0500
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:55728 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbYLGSbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:31:34 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 10/13] checkpatch: ensure we actually detect if assignments split across lines
Date: Sun,  7 Dec 2008 18:30:47 +0000
Message-Id: <1228674650-24392-11-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1228674650-24392-1-git-send-email-apw@shadowen.org>
References: <1228674650-24392-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

When checking for assignments within if conditionals we check the whole
of the condition, but the match is performed using a line constrained
regular expression.  This means we can miss split conditionals or those
on the second line.  Allow the check to span lines.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a521d49..c39ce0b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2048,7 +2048,7 @@ sub process {
 		    $line =~ /\b(?:if|while|for)\s*\(/ && $line !~ /^.\s*#/) {
 			my ($s, $c) = ($stat, $cond);
 
-			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/) {
+			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/s) {
 				ERROR("do not use assignment in if condition\n" . $herecurr);
 			}
 
-- 
1.6.0.4.911.gc990


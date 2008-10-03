Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbYJCPvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbYJCPvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYJCPun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:50:43 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:58064 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbYJCPum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:50:42 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 11/13] checkpatch: suspect indent handle macro continuation
Date: Fri,  3 Oct 2008 16:25:52 +0100
Message-Id: <1223047554-31111-12-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.1.451.gc8d31
In-Reply-To: <1223047554-31111-1-git-send-email-apw@shadowen.org>
References: <1223047554-31111-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ignoring a macro in the middle of a conditional, we need to ignore
the macro start and any continuation lines.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2c1afba..862e8e0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1465,6 +1465,7 @@ sub process {
 			}
 
 			my $cond_ptr = -1;
+			$continuation = 0;
 			while ($cond_ptr != $cond_lines) {
 				$cond_ptr = $cond_lines;
 
@@ -1478,9 +1479,11 @@ sub process {
 				#  1) blank lines, they should be at 0,
 				#  2) preprocessor lines, and
 				#  3) labels.
-				if ($s =~ /^\s*?\n/ ||
+				if ($continuation ||
+				    $s =~ /^\s*?\n/ ||
 				    $s =~ /^\s*#\s*?/ ||
 				    $s =~ /^\s*$Ident\s*:/) {
+					$continuation = ($s =~ /^.*?\\\n/) ? 1 : 0;
 					$s =~ s/^.*?\n//;
 					$cond_lines++;
 				}
-- 
1.6.0.1.451.gc8d31


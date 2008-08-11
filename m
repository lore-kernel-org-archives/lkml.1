Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbYHKUOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbYHKUOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYHKUNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:13:22 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41158 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbYHKUNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:13:18 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 01/17] checkpatch: square brackets -- exemption for array slices in braces
Date: Mon, 11 Aug 2008 21:12:56 +0100
Message-Id: <1218485592-6679-2-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1218485592-6679-1-git-send-email-apw@shadowen.org>
References: <1218485592-6679-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is wholy reasonable to have square brackets representing array slices
in braces on the same line.  These should be spaced.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bc67793..6f821a0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1493,11 +1493,13 @@ sub process {
 
 # check for spacing round square brackets; allowed:
 #  1. with a type on the left -- int [] a;
-#  2. at the beginning of a line for slice initialisers -- [0..10] = 5,
+#  2. at the beginning of a line for slice initialisers -- [0...10] = 5,
+#  3. inside a curly brace -- = { [0...10] = 5 }
 		while ($line =~ /(.*?\s)\[/g) {
 			my ($where, $prefix) = ($-[1], $1);
 			if ($prefix !~ /$Type\s+$/ &&
-			    ($where != 0 || $prefix !~ /^.\s+$/)) {
+			    ($where != 0 || $prefix !~ /^.\s+$/) &&
+			    $prefix !~ /{\s+$/) {
 				ERROR("space prohibited before open square bracket '['\n" . $herecurr);
 			}
 		}
-- 
1.6.0.rc1.258.g80295


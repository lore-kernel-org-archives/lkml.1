Return-Path: <linux-kernel-owner+w=401wt.eu-S1760292AbYFLMWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292AbYFLMWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbYFLMWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:22:40 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1277 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864AbYFLMWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:22:39 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 20/23] checkpatch: macro complexity checks are meaningless in linker scripts
Date: Thu, 12 Jun 2008 13:05:59 +0100
Message-Id: <1213272362-19457-21-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exclude vmlinux.lds.h from the macro complexity checks.  They will never
apply sanely here.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 53ec394..775f2b1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1860,7 +1860,8 @@ sub process {
 # multi-statement macros should be enclosed in a do while loop, grab the
 # first statement and ensure its the whole macro if its not enclosed
 # in a known good container
-		if ($line =~ /^.\s*\#\s*define\s*$Ident(\()?/) {
+		if ($realfile !~ m@/vmlinux.lds.h$@ &&
+		    $line =~ /^.\s*\#\s*define\s*$Ident(\()?/) {
 			my $ln = $linenr;
 			my $cnt = $realcnt;
 			my ($off, $dstat, $dcond, $rest);
-- 
1.5.6.rc0.140.ga9675


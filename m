Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYFLMJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYFLMJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760198AbYFLMH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:07:59 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4319 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903AbYFLMH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:07:57 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 05/23] checkpatch: possible types: __asm__ is never a type
Date: Thu, 12 Jun 2008 13:05:44 +0100
Message-Id: <1213272362-19457-6-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are false matching __asm__ as a type, and then tripping the external
function checks.  Squash.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index cf70f12..fd597a4 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -846,7 +846,7 @@ sub possible {
 	if ($possible !~ /^(?:$Storage|$Type|DEFINE_\S+)$/ &&
 	    $possible ne 'goto' && $possible ne 'return' &&
 	    $possible ne 'case' && $possible ne 'else' &&
-	    $possible ne 'asm' &&
+	    $possible ne 'asm' && $possible ne '__asm__' &&
 	    $possible !~ /^(typedef|struct|enum)\b/) {
 		# Check for modifiers.
 		$possible =~ s/\s*$Storage\s*//g;
-- 
1.5.6.rc0.140.ga9675


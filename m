Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbYFLMKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbYFLMKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760202AbYFLMIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:08:00 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4320 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760189AbYFLMH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:07:57 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 07/23] checkpatch: types: unary -- goto introduces unary context
Date: Thu, 12 Jun 2008 13:05:46 +0100
Message-Id: <1213272362-19457-8-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we see a goto we enter unary context.  For example:

	goto *h;

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 94250d1..b2b0648 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -780,7 +780,7 @@ sub annotate_values {
 			$av_pending = 'N';
 			$type = 'N';
 
-		} elsif ($cur =~/^(return|case|else)/o) {
+		} elsif ($cur =~/^(return|case|else|goto)/o) {
 			print "KEYWORD($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
-- 
1.5.6.rc0.140.ga9675


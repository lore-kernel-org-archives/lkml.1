Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbYH3Lro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbYH3Lro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 07:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYH3Lrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 07:47:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:18267 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbYH3Lrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 07:47:35 -0400
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
From: Hannes Eder <hannes@hanneseder.net>
Date: Fri, 29 Aug 2008 22:33:55 +0200
Subject: [PATCH] Fix build warning in kernel/auditsc.c
Message-ID: <48b93353.02e2660a.0e28.3e54@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this:

kernel/auditsc.c: In function 'audit_match_perm':
kernel/auditsc.c:249: warning: ISO C90 forbids mixed declarations and code

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 kernel/auditsc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 972f8e6..e72b161 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -243,10 +243,12 @@ static inline int open_arg(int flags, int mask)
 
 static int audit_match_perm(struct audit_context *ctx, int mask)
 {
+	unsigned n;
+
 	if (unlikely(!ctx))
 		return 0;
 
-	unsigned n = ctx->major;
+	n = ctx->major;
 	switch (audit_classify_syscall(ctx->arch, n)) {
 	case 0:	/* native */
 		if ((mask & AUDIT_PERM_WRITE) &&

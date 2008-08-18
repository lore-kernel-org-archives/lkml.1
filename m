Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbYHRQut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbYHRQut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbYHRQqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:46:01 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51753 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbYHRQpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:45:53 -0400
Message-ID: <48A9A73F.9060400@linux.vnet.ibm.com>
Date: Mon, 18 Aug 2008 09:45:51 -0700
From: Cordelia <cordsam@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] audit: Moved variable declaration to beginning of function
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

got rid of compilation warning:
ISO C90 forbids mixed declarations and code

Signed-off-by: Cordelia Sam <cordesam@gmail.com>
---
 kernel/auditsc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 972f8e6..59cedfb 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -243,10 +243,11 @@ static inline int open_arg(int flags, int mask)
 
 static int audit_match_perm(struct audit_context *ctx, int mask)
 {
+	unsigned n;
 	if (unlikely(!ctx))
 		return 0;
 
-	unsigned n = ctx->major;
+	n = ctx->major;
 	switch (audit_classify_syscall(ctx->arch, n)) {
 	case 0:	/* native */
 		if ((mask & AUDIT_PERM_WRITE) &&
-- 
1.5.4.3

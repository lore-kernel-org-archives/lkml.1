Return-Path: <linux-kernel-owner+w=401wt.eu-S1761454AbZCRWBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761454AbZCRWBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761355AbZCRWAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:00:09 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:42963 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761357AbZCRWAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:00:05 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Subject: [PATCH 3/3] Restrict definition of a static function in kernel/auditsc.c
Date: Wed, 18 Mar 2009 23:49:27 +0200
Message-Id: <1237412967-20754-3-git-send-email-dmitri.vorobiev@movial.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1237412967-20754-2-git-send-email-dmitri.vorobiev@movial.com>
References: <1237412967-20754-1-git-send-email-dmitri.vorobiev@movial.com>
 <1237412967-20754-2-git-send-email-dmitri.vorobiev@movial.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function 'audit_set_auditable' in kernel/auditsc.c is called
only when the CONFIG_AUDIT_TREE option is set. Therefore, the
following warning may be produced:

kernel/auditsc.c:745: warning: 'audit_set_auditable' defined but not used

This patch fixes the warning by moving the function definition under an
appropriate preprocessor construct.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
---
 kernel/auditsc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 8cbddff..bac40d0 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -741,6 +741,7 @@ void audit_filter_inodes(struct task_struct *tsk, struct audit_context *ctx)
 	rcu_read_unlock();
 }
 
+#ifdef CONFIG_AUDIT_TREE
 static void audit_set_auditable(struct audit_context *ctx)
 {
 	if (!ctx->prio) {
@@ -748,6 +749,7 @@ static void audit_set_auditable(struct audit_context *ctx)
 		ctx->current_state = AUDIT_RECORD_CONTEXT;
 	}
 }
+#endif
 
 static inline struct audit_context *audit_get_context(struct task_struct *tsk,
 						      int return_valid,
-- 
1.5.6.3


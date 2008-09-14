Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYINRiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYINRiM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 13:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYINRh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 13:37:57 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41487 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbYINRh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 13:37:56 -0400
Date: Sun, 14 Sep 2008 20:37:54 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, menage@google.com, balbir@linux.vnet.ibm.com
Subject: [PATCH] cgroups: don't depend on CONFIG_MM_OWNER
Message-ID: <Pine.LNX.4.64.0809142037070.30252@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The revoke patches, for example, select CONFIG_MM_OWNER independently of
cgroups. Therefore, don't depend on CONFIG_MM_OWNER in cgroup specific code.

Cc: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/cgroup.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c98dd7c..e270ec3 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -413,10 +413,10 @@ static inline int cgroupstats_build(struct cgroupstats *stats,
 
 #endif /* !CONFIG_CGROUPS */
 
-#ifdef CONFIG_MM_OWNER
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
 extern void
 cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new);
-#else /* !CONFIG_MM_OWNER */
+#else /* !CONFIG_CGROUP_MEM_RES_CTLR */
 static inline void
 cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
 {
-- 
1.5.4.3


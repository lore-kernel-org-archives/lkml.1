Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbZEVE5C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbZEVE5C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 00:57:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbZEVEzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:55:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:3469 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbZEVEzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:55:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YzWv8RDDknYup1/1jca2bF6SxKlIL5jNuBGhA6dVr5CC+nR0wdDLqhAacyfwnaKCAS
         oDYKKp5zeeOb4BTNKOa/0JRV1T6ddk88AeYA6pBhBmN7yjy0NTbJ9l90lvBYU2LeuRSC
         +mj0j8lMGSg3yCutZN1y+dSc9vLUBUSyPtDDQ=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 06/38] ipcns 4/2: move free_ipcs() proto
Date: Fri, 22 May 2009 08:55:00 +0400
Message-Id: <1242968132-1044-6-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function is really private to ipc/ and avoid struct kern_ipc_perm
forward declaration.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 include/linux/ipc_namespace.h |    4 ----
 ipc/util.h                    |    3 ++-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 804e4e4..e408722 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -96,10 +96,6 @@ static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
 #if defined(CONFIG_IPC_NS)
 extern struct ipc_namespace *copy_ipcs(unsigned long flags,
 				       struct ipc_namespace *ns);
-extern void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
-		      void (*free)(struct ipc_namespace *,
-				   struct kern_ipc_perm *));
-
 static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
 {
 	if (ns)
diff --git a/ipc/util.h b/ipc/util.h
index 1187332..7a2861b 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -171,5 +171,6 @@ static inline void ipc_unlock(struct kern_ipc_perm *perm)
 struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
 			struct ipc_ops *ops, struct ipc_params *params);
-
+void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
+		void (*free)(struct ipc_namespace *, struct kern_ipc_perm *));
 #endif
-- 
1.5.6.5


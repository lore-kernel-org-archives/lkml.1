Return-Path: <linux-kernel-owner+w=401wt.eu-S1761508AbZE0Rn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761508AbZE0Rn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758876AbZE0Rns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:43:48 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:53844 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771AbZE0Rnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:43:47 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 May 2009 13:43:47 EDT
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: [RFC v16][PATCH 39/43] c/r (ipc): export interface from ipc/sem.c to cleanup ipc sem
Date: Wed, 27 May 2009 13:33:05 -0400
Message-Id: <1243445589-32388-40-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1243445589-32388-1-git-send-email-orenl@cs.columbia.edu>
References: <1243445589-32388-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export freeary() which will be used in the next patch during restart
to cleanup an ipc sem.

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
---
 ipc/sem.c  |    3 +--
 ipc/util.h |    1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 207dbbb..c60076e 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -93,7 +93,6 @@
 #define sem_checkid(sma, semid)	ipc_checkid(&sma->sem_perm, semid)
 
 static int newary(struct ipc_namespace *, struct ipc_params *, int);
-static void freeary(struct ipc_namespace *, struct kern_ipc_perm *);
 #ifdef CONFIG_PROC_FS
 static int sysvipc_sem_proc_show(struct seq_file *s, void *it);
 #endif
@@ -521,7 +520,7 @@ static void free_un(struct rcu_head *head)
  * as a writer and the spinlock for this semaphore set hold. sem_ids.rw_mutex
  * remains locked on exit.
  */
-static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
+void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 {
 	struct sem_undo *un, *tu;
 	struct sem_queue *q, *tq;
diff --git a/ipc/util.h b/ipc/util.h
index 2a05fb3..347ffb2 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -185,6 +185,7 @@ int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
 extern int do_shmget(key_t key, size_t size, int shmflg, int req_id);
 extern int do_msgget(key_t key, int msgflg, int req_id);
 extern void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp);
+extern void freeary(struct ipc_namespace *, struct kern_ipc_perm *);
 
 extern void do_shm_rmid(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp);
 
-- 
1.6.0.4


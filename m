Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbZLKGKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbZLKGKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 01:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbZLKGKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 01:10:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756632AbZLKGK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 01:10:28 -0500
Date: Fri, 11 Dec 2009 01:10:14 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       Amerigo Wang <amwang@redhat.com>, Cedric Le Goater <clg@fr.ibm.com>
Message-Id: <20091211061316.3969.99500.sendpatchset@localhost.localdomain>
Subject: [Patch] ipc: HARD_MSGMAX should be higher not lower on 64bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks weird that we have HARD_MSGMAX lower on 64bit than on 32bit,
since usually 64bit machines have more memory than 32bit machines.

Making it higher on 64bit seems reasonable, and keep the original
number on 32bit.

Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index e408722..07baa38 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -87,7 +87,7 @@ extern int mq_init_ns(struct ipc_namespace *ns);
 /* default values */
 #define DFLT_QUEUESMAX 256     /* max number of message queues */
 #define DFLT_MSGMAX    10      /* max number of messages in each queue */
-#define HARD_MSGMAX    (131072/sizeof(void *))
+#define HARD_MSGMAX    (32768*sizeof(void *)/4)
 #define DFLT_MSGSIZEMAX 8192   /* max message size */
 #else
 static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }

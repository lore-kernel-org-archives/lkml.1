Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbXKBPqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbXKBPqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbXKBPoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:44:44 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53866 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760250AbXKBPon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:44:43 -0400
Date: Fri, 2 Nov 2007 16:44:21 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper prototype for signals_init()
Message-ID: <20071102154421.GO30287@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proper prototype for signals_init() in 
include/linux/signal.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/signal.h |    2 ++
 init/main.c            |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

bf5554aad7a7880c3573f89e5fbed8231734b1a4 
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 0ae3388..7e09514 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -371,6 +371,8 @@ int unhandled_signal(struct task_struct *tsk, int sig);
 	(!siginmask(signr, SIG_KERNEL_IGNORE_MASK|SIG_KERNEL_STOP_MASK) && \
 	 (t)->sighand->action[(signr)-1].sa.sa_handler == SIG_DFL)
 
+void signals_init(void);
+
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_SIGNAL_H */
diff --git a/init/main.c b/init/main.c
index 80b04b6..62153ff 100644
--- a/init/main.c
+++ b/init/main.c
@@ -57,6 +57,7 @@
 #include <linux/device.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
+#include <linux/signal.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -83,7 +84,6 @@ extern void init_IRQ(void);
 extern void fork_init(unsigned long);
 extern void mca_init(void);
 extern void sbus_init(void);
-extern void signals_init(void);
 extern void pidhash_init(void);
 extern void pidmap_init(void);
 extern void prio_tree_init(void);


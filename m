Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbXLFXU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbXLFXU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 18:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbXLFXUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 18:20:23 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:50735 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbXLFXUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 18:20:21 -0500
From: Zach Brown <zach.brown@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Simon Holm Thogersen <odie@cs.aau.dk>, suresh.b.siddha@intel.com
Subject: [PATCH 2/6] syslet: asm-generic support to disable syslets
Date: Thu,  6 Dec 2007 15:20:15 -0800
Message-Id: <1196983219225-git-send-email-zach.brown@oracle.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11969832193635-git-send-email-zach.brown@oracle.com>
References: <1196983219534-git-send-email-zach.brown@oracle.com>
 <11969832193635-git-send-email-zach.brown@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides an implementation of the architecture dependent portion of
syslets which disables syslet operations.

This patch is an incomplete demonstration.  All asm-*/syslet*.h files would
include these files until their architectures provide implementations which
enable syslet support.

Signed-off-by: Zach Brown <zach.brown@oracle.com>

diff --git a/include/asm-generic/syslet-abi.h b/include/asm-generic/syslet-abi.h
new file mode 100644
index 0000000..5d19971
--- /dev/null
+++ b/include/asm-generic/syslet-abi.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_GENERIC_SYSLET_ABI_H
+#define _ASM_GENERIC_SYSLET_ABI_H
+
+/*
+ * I'm assuming that a u64 ip and u64 esp won't be enough for all
+ * archs, so I just let each arch define its own.
+ */
+struct syslet_frame {
+};
+
+#endif
diff --git a/include/asm-generic/syslet.h b/include/asm-generic/syslet.h
new file mode 100644
index 0000000..de9a750
--- /dev/null
+++ b/include/asm-generic/syslet.h
@@ -0,0 +1,34 @@
+#ifndef _ASM_GENERIC_SYSLET_H
+#define _ASM_GENERIC_SYSLET_H
+
+/*
+ * This provider of the arch-specific syslet APIs is used when an architecture
+ * doesn't support syslets.
+ */
+
+/* this stops the other functions from ever being called */
+static inline int syslet_frame_valid(struct syslet_frame *frame)
+{
+	return 0;
+}
+
+static inline void set_user_frame(struct task_struct *task,
+				  struct syslet_frame *frame)
+{
+	BUG();
+}
+
+static inline void move_user_context(struct task_struct *dest,
+					struct task_struct *src)
+{
+	BUG();
+}
+
+static inline int create_syslet_thread(long (*fn)(void *),
+				       void *arg, unsigned long flags)
+{
+	BUG();
+	return 0;
+}
+
+#endif
diff --git a/include/asm-x86/syslet-abi.h b/include/asm-x86/syslet-abi.h
new file mode 100644
index 0000000..14a7182
--- /dev/null
+++ b/include/asm-x86/syslet-abi.h
@@ -0,0 +1 @@
+#include <asm-generic/syslet-abi.h>
diff --git a/include/asm-x86/syslet.h b/include/asm-x86/syslet.h
new file mode 100644
index 0000000..583d810
--- /dev/null
+++ b/include/asm-x86/syslet.h
@@ -0,0 +1 @@
+#include <asm-generic/syslet.h>
-- 
1.5.2.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbXLFXVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbXLFXVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 18:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbXLFXUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 18:20:24 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:50752 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbXLFXUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 3/6] syslet: introduce abi structs
Date: Thu,  6 Dec 2007 15:20:16 -0800
Message-Id: <11969832192868-git-send-email-zach.brown@oracle.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1196983219225-git-send-email-zach.brown@oracle.com>
References: <1196983219534-git-send-email-zach.brown@oracle.com>
 <11969832193635-git-send-email-zach.brown@oracle.com>
 <1196983219225-git-send-email-zach.brown@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the architecture independent structures of the
syslet ABI.

Signed-off-by: Zach Brown <zach.brown@oracle.com>

diff --git a/include/linux/syslet-abi.h b/include/linux/syslet-abi.h
new file mode 100644
index 0000000..a8bc1a3
--- /dev/null
+++ b/include/linux/syslet-abi.h
@@ -0,0 +1,34 @@
+#ifndef _LINUX_SYSLET_ABI_H
+#define _LINUX_SYSLET_ABI_H
+
+#include <asm/syslet-abi.h> /* for struct syslet_frame */
+
+struct syslet_args {
+	u64 completion_ring_ptr;
+	u64 caller_data;
+	struct syslet_frame frame;
+};
+
+struct syslet_completion {
+	u64 status;
+	u64 caller_data;
+};
+
+/*
+ * The ring follows the "wrapping" convention as described by Andrew at:
+ * 	http://lkml.org/lkml/2007/4/11/276
+ * The head is updated by the kernel as completions are added and the
+ * tail is updated by userspace as completions are removed.
+ *
+ * The number of elements must be a power of two and the ring must be
+ * aligned to a u64.
+ */
+struct syslet_ring {
+	u32 kernel_head;
+	u32 user_tail;
+	u32 elements;
+	u32 wait_group;
+	struct syslet_completion comp[0];
+};
+
+#endif
-- 
1.5.2.2


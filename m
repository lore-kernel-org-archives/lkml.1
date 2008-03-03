Return-Path: <linux-kernel-owner+w=401wt.eu-S1761907AbYCCTEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761907AbYCCTEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbYCCTEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:04:06 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:1079 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbYCCTED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:04:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AUqo9r2VTyXlZQi8IjuQDkdiVuGp6b51VPd1SC6JmfiLtKv87PtCr06Qx5vUMXrcb8wG0NsqNq0cq4G6gIF2vYX4gWddR5mDLroNERbF53UpihBCT+V85chti+HlSbBzzZLhX3ksELQKaGGJf4kcKCQBH0EbT++Qzzs7oBN75KE=
Subject: [PATCH] parisc: replace remaining __FUNCTION__ occurances
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 11:03:51 -0800
Message-Id: <1204571031.3266.33.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/parisc/kernel/inventory.c |    2 +-
 arch/parisc/kernel/traps.c     |    2 +-
 arch/parisc/kernel/unaligned.c |    2 +-
 arch/parisc/lib/memcpy.c       |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/parisc/kernel/inventory.c b/arch/parisc/kernel/inventory.c
index 4845a64..bd1f7f1 100644
--- a/arch/parisc/kernel/inventory.c
+++ b/arch/parisc/kernel/inventory.c
@@ -499,7 +499,7 @@ add_system_map_addresses(struct parisc_device *dev, int num_addrs,
 	dev->addr = kmalloc(num_addrs * sizeof(unsigned long), GFP_KERNEL);
 	if(!dev->addr) {
 		printk(KERN_ERR "%s %s(): memory allocation failure\n",
-		       __FILE__, __FUNCTION__);
+		       __FILE__, __func__);
 		return;
 	}
 
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index 99fd569..3765376 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -256,7 +256,7 @@ KERN_CRIT "                     ||     ||\n");
 
 	/* Wot's wrong wif bein' racy? */
 	if (current->thread.flags & PARISC_KERNEL_DEATH) {
-		printk(KERN_CRIT "%s() recursion detected.\n", __FUNCTION__);
+		printk(KERN_CRIT "%s() recursion detected.\n", __func__);
 		local_irq_enable();
 		while (1);
 	}
diff --git a/arch/parisc/kernel/unaligned.c b/arch/parisc/kernel/unaligned.c
index aebf3c1..9f5f01e 100644
--- a/arch/parisc/kernel/unaligned.c
+++ b/arch/parisc/kernel/unaligned.c
@@ -30,7 +30,7 @@
 /* #define DEBUG_UNALIGNED 1 */
 
 #ifdef DEBUG_UNALIGNED
-#define DPRINTF(fmt, args...) do { printk(KERN_DEBUG "%s:%d:%s ", __FILE__, __LINE__, __FUNCTION__ ); printk(KERN_DEBUG fmt, ##args ); } while (0)
+#define DPRINTF(fmt, args...) do { printk(KERN_DEBUG "%s:%d:%s ", __FILE__, __LINE__, __func__ ); printk(KERN_DEBUG fmt, ##args ); } while (0)
 #else
 #define DPRINTF(fmt, args...)
 #endif
diff --git a/arch/parisc/lib/memcpy.c b/arch/parisc/lib/memcpy.c
index d22042d..2d68431 100644
--- a/arch/parisc/lib/memcpy.c
+++ b/arch/parisc/lib/memcpy.c
@@ -91,7 +91,7 @@ DECLARE_PER_CPU(struct exception_data, exception_data);
 #define THRESHOLD	16
 
 #ifdef DEBUG_MEMCPY
-#define DPRINTF(fmt, args...) do { printk(KERN_DEBUG "%s:%d:%s ", __FILE__, __LINE__, __FUNCTION__ ); printk(KERN_DEBUG fmt, ##args ); } while (0)
+#define DPRINTF(fmt, args...) do { printk(KERN_DEBUG "%s:%d:%s ", __FILE__, __LINE__, __func__ ); printk(KERN_DEBUG fmt, ##args ); } while (0)
 #else
 #define DPRINTF(fmt, args...)
 #endif
-- 
1.5.4.3.500.g83a2c




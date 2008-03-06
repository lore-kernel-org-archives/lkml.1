Return-Path: <linux-kernel-owner+w=401wt.eu-S933607AbYCFCZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607AbYCFCZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758687AbYCFCY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:24:58 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:61432 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745AbYCFCY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:24:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oyGfB6E22HEwLRlJDbh2L1Y28arlKwNiQk1CwA3305KNiMAB4Ye0rE8kUeBSSVwjr0X/iK1oRyg33vS4pPMkKxDvOYrOPF624tuQfp3iWZNyQRb2/63qTskrJ856CHr71hz8xK36rnLyA4GVpApqPvPdbyo/72LrE7qqkIT63Ig=
Subject: [PATCH 03/16] atm: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 18:24:52 -0800
Message-Id: <1204770292.14154.39.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/atm/firestream.c |    4 ++--
 drivers/atm/fore200e.c   |    4 ++--
 drivers/atm/idt77252.c   |   12 ++++++------
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index c662d68..fcf974f 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -331,8 +331,8 @@ module_param(fs_keystream, int, 0);
 #define FS_DEBUG_QSIZE   0x00001000
 

-#define func_enter() fs_dprintk (FS_DEBUG_FLOW, "fs: enter %s\n", __FUNCTION__)
-#define func_exit()  fs_dprintk (FS_DEBUG_FLOW, "fs: exit  %s\n", __FUNCTION__)
+#define func_enter() fs_dprintk(FS_DEBUG_FLOW, "fs: enter %s\n", __func__)
+#define func_exit()  fs_dprintk(FS_DEBUG_FLOW, "fs: exit  %s\n", __func__)
 

 static struct fs_dev *fs_boards = NULL;
diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index f97e050..9427a61 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -95,8 +95,8 @@
 #if 1
 #define ASSERT(expr)     if (!(expr)) { \
 			     printk(FORE200E "assertion failed! %s[%d]: %s\n", \
-				    __FUNCTION__, __LINE__, #expr); \
-			     panic(FORE200E "%s", __FUNCTION__); \
+				    __func__, __LINE__, #expr); \
+			     panic(FORE200E "%s", __func__); \
 			 }
 #else
 #define ASSERT(expr)     do {} while (0)
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index eee54c0..b967919 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -555,7 +555,7 @@ idt77252_tx_dump(struct idt77252_dev *card)
 	struct vc_map *vc;
 	int i;
 
-	printk("%s\n", __FUNCTION__);
+	printk("%s\n", __func__);
 	for (i = 0; i < card->tct_size; i++) {
 		vc = card->vcs[i];
 		if (!vc)
@@ -1035,7 +1035,7 @@ dequeue_rx(struct idt77252_dev *card, struct rsq_entry *rsqe)
 	skb = sb_pool_skb(card, le32_to_cpu(rsqe->word_2));
 	if (skb == NULL) {
 		printk("%s: NULL skb in %s, rsqe: %08x %08x %08x %08x\n",
-		       card->name, __FUNCTION__,
+		       card->name, __func__,
 		       le32_to_cpu(rsqe->word_1), le32_to_cpu(rsqe->word_2),
 		       le32_to_cpu(rsqe->word_3), le32_to_cpu(rsqe->word_4));
 		return;
@@ -1873,7 +1873,7 @@ add_rx_skb(struct idt77252_dev *card, int queue,
 			return;
 
 		if (sb_pool_add(card, skb, queue)) {
-			printk("%s: SB POOL full\n", __FUNCTION__);
+			printk("%s: SB POOL full\n", __func__);
 			goto outfree;
 		}
 
@@ -1883,7 +1883,7 @@ add_rx_skb(struct idt77252_dev *card, int queue,
 		IDT77252_PRV_PADDR(skb) = paddr;
 
 		if (push_rx_skb(card, skb, queue)) {
-			printk("%s: FB QUEUE full\n", __FUNCTION__);
+			printk("%s: FB QUEUE full\n", __func__);
 			goto outunmap;
 		}
 	}
@@ -3821,12 +3821,12 @@ static int __init idt77252_init(void)
 {
 	struct sk_buff *skb;
 
-	printk("%s: at %p\n", __FUNCTION__, idt77252_init);
+	printk("%s: at %p\n", __func__, idt77252_init);
 
 	if (sizeof(skb->cb) < sizeof(struct atm_skb_data) +
 			      sizeof(struct idt77252_skb_prv)) {
 		printk(KERN_ERR "%s: skb->cb is too small (%lu < %lu)\n",
-		       __FUNCTION__, (unsigned long) sizeof(skb->cb),
+		       __func__, (unsigned long) sizeof(skb->cb),
 		       (unsigned long) sizeof(struct atm_skb_data) +
 				       sizeof(struct idt77252_skb_prv));
 		return -EIO;
-- 
1.5.4.GIT



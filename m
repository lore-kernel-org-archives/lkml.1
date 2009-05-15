Return-Path: <linux-kernel-owner+w=401wt.eu-S1763267AbZEOSB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763267AbZEOSB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761814AbZEOSAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:00:00 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2051 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761660AbZEOR76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 13:59:58 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 06/11] drivers/isdn: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
Date: Fri, 15 May 2009 10:59:40 -0700
Message-Id: <0c3a6ad937c8a1eaf3ca914b2edc4a1cd6ffc18e.1242407227.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b.dirty
In-Reply-To: <cover.1242407227.git.joe@perches.com>
References: <cover.1242407227.git.joe@perches.com>
In-Reply-To: <cover.1242407227.git.joe@perches.com>
References: <cover.1242407227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/isdn/i4l/isdn_bsdcomp.c |    4 +---
 drivers/isdn/pcbit/callbacks.c  |    9 ++-------
 drivers/isdn/pcbit/capi.c       |   16 ++++------------
 drivers/isdn/pcbit/drv.c        |   30 +++++++++---------------------
 drivers/isdn/pcbit/layer2.c     |   30 +++++++++---------------------
 5 files changed, 25 insertions(+), 64 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_bsdcomp.c b/drivers/isdn/i4l/isdn_bsdcomp.c
index 02d9918..ab77384 100644
--- a/drivers/isdn/i4l/isdn_bsdcomp.c
+++ b/drivers/isdn/i4l/isdn_bsdcomp.c
@@ -769,10 +769,8 @@ static int bsd_decompress (void *state, struct sk_buff *skb_in, struct sk_buff *
 		if( skb_tailroom(skb_out) < codelen + extra) {
 			if (db->debug) {
 				printk(KERN_DEBUG "bsd_decomp%d: ran out of mru\n", db->unit);
-#ifdef DEBUG
-				printk(KERN_DEBUG "  len=%d, finchar=0x%x, codelen=%d,skblen=%d\n",
+				pr_debug("  len=%d, finchar=0x%x, codelen=%d,skblen=%d\n",
 					ilen, finchar, codelen, skb_out->len);
-#endif
 			}
 			return DECOMP_FATALERROR;
 		}
diff --git a/drivers/isdn/pcbit/callbacks.c b/drivers/isdn/pcbit/callbacks.c
index 43ecd0f..57a065c 100644
--- a/drivers/isdn/pcbit/callbacks.c
+++ b/drivers/isdn/pcbit/callbacks.c
@@ -48,10 +48,7 @@ void cb_out_1(struct pcbit_dev * dev, struct pcbit_chan* chan,
         ushort refnum;
 
 
-#ifdef DEBUG
-        printk(KERN_DEBUG "Called Party Number: %s\n", 
-               cbdata->data.setup.CalledPN);
-#endif
+        pr_debug("Called Party Number: %s\n", cbdata->data.setup.CalledPN);
         /*
          * hdr - kmalloc in capi_conn_req
          *     - kfree   when msg has been sent
@@ -164,9 +161,7 @@ void cb_in_1(struct pcbit_dev * dev, struct pcbit_chan* chan,
 	ictl.parm.setup.plan = 0;
 	ictl.parm.setup.screen = 0;
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "statstr: %s\n", ictl.num);
-#endif
+	pr_debug("statstr: %s\n", ictl.num);
 
         dev->dev_if->statcallb(&ictl);
 
diff --git a/drivers/isdn/pcbit/capi.c b/drivers/isdn/pcbit/capi.c
index ac5a91c..4a812e7 100644
--- a/drivers/isdn/pcbit/capi.c
+++ b/drivers/isdn/pcbit/capi.c
@@ -162,9 +162,7 @@ int capi_conn_active_req(struct pcbit_chan* chan, struct sk_buff **skb)
 
         *((ushort*) skb_put(*skb, 2) ) = chan->callref;  
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "Call Reference: %04x\n", chan->callref); 
-#endif
+	pr_debug("Call Reference: %04x\n", chan->callref); 
 
         *(skb_put(*skb, 1)) = 0;       /*  BC.Length = 0;          */
         *(skb_put(*skb, 1)) = 0;       /*  ConnectedPN.Length = 0  */
@@ -226,9 +224,7 @@ int capi_select_proto_req(struct pcbit_chan *chan, struct sk_buff **skb,
 		*(skb_put(*skb, 1)) = 0x06;
 		break;
         default:
-#ifdef DEBUG 
-                printk(KERN_DEBUG "Transparent\n");
-#endif
+                pr_debug("Transparent\n");
                 *(skb_put(*skb, 1)) = 0x03;
                 break;
         }
@@ -388,9 +384,7 @@ int capi_decode_conn_ind(struct pcbit_chan * chan,
         chan->callref = *((ushort*) skb->data);
         skb_pull(skb, 2);
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "Call Reference: %04x\n", chan->callref); 
-#endif
+	pr_debug("Call Reference: %04x\n", chan->callref); 
 
         /* Channel Identification */
 
@@ -420,9 +414,7 @@ int capi_decode_conn_ind(struct pcbit_chan * chan,
 	if (len > 0) {
 		int count = 1;
 		
-#ifdef DEBUG
-		printk(KERN_DEBUG "CPN: Octect 3 %02x\n", skb->data[1]);
-#endif
+		pr_debug("CPN: Octect 3 %02x\n", skb->data[1]);
 		if ((skb->data[1] & 0x80) == 0)
 			count = 2;
 		
diff --git a/drivers/isdn/pcbit/drv.c b/drivers/isdn/pcbit/drv.c
index 8c66bcb..8ec12b0 100644
--- a/drivers/isdn/pcbit/drv.c
+++ b/drivers/isdn/pcbit/drv.c
@@ -313,9 +313,8 @@ static void pcbit_block_timer(unsigned long data)
 	del_timer(&chan->block_timer);
 	chan->block_timer.function = NULL;
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "pcbit_block_timer\n");
-#endif	
+	pr_debug("pcbit_block_timer\n");
+
 	chan->queued = 0;
 	ictl.driver = dev->id;
 	ictl.command = ISDN_STAT_BSENT;
@@ -565,11 +564,9 @@ void pcbit_l3_receive(struct pcbit_dev * dev, ulong msg,
 		 * reference number. The current version of the firmware
 		 * doesn't sent the ref number correctly.
 		 */
-#ifdef DEBUG
-		printk(KERN_DEBUG "refnum=%04x b1=%04x b2=%04x\n", refnum, 
-		       dev->b1->s_refnum, 
-		       dev->b2->s_refnum);
-#endif
+		pr_debug("refnum=%04x b1=%04x b2=%04x\n", refnum, 
+			 dev->b1->s_refnum, 
+			 dev->b2->s_refnum);
 		/* We just try to find a channel in the right state */
 
 		if (dev->b1->fsm_state == ST_CALL_INIT)
@@ -676,9 +673,7 @@ void pcbit_l3_receive(struct pcbit_dev * dev, ulong msg,
 			printk(KERN_WARNING "capi_decode_disc_conf - error\n");
 		break;
 	case MSG_INFO_IND:
-#ifdef DEBUG
-		printk(KERN_DEBUG "received Info Indication - discarded\n");
-#endif
+		pr_debug("received Info Indication - discarded\n");
 		break;
 #ifdef DEBUG
 	case MSG_DEBUG_188:
@@ -794,9 +789,7 @@ static void set_running_timeout(unsigned long ptr)
 {
 	struct pcbit_dev * dev;
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "set_running_timeout\n");
-#endif
+	pr_debug("set_running_timeout\n");
 	dev = (struct pcbit_dev *) ptr;
 
 	wake_up_interruptible(&dev->set_running_wq);
@@ -847,10 +840,7 @@ static int set_protocol_running(struct pcbit_dev * dev)
 
 		dev->l2_state = L2_DOWN;
 
-#ifdef DEBUG
-		printk(KERN_DEBUG "Bank3 = %02x\n", 
-		       readb(dev->sh_mem + BANK3));
-#endif
+		pr_debug("Bank3 = %02x\n", readb(dev->sh_mem + BANK3));
 		writeb(0x40, dev->sh_mem + BANK4);
 
 		/* warn the upper layer */
@@ -1048,9 +1038,7 @@ static void pcbit_set_msn(struct pcbit_dev *dev, char *list)
 		memcpy(ptr->msn, sp, len - 1);
 		ptr->msn[len] = 0;
 
-#ifdef DEBUG
-		printk(KERN_DEBUG "msn: %s\n", ptr->msn);
-#endif
+		pr_debug("msn: %s\n", ptr->msn);
 		if (dev->msn_list == NULL)
 			dev->msn_list = ptr;
 		else
diff --git a/drivers/isdn/pcbit/layer2.c b/drivers/isdn/pcbit/layer2.c
index e075e8d..7f3ab02 100644
--- a/drivers/isdn/pcbit/layer2.c
+++ b/drivers/isdn/pcbit/layer2.c
@@ -267,11 +267,9 @@ pcbit_transmit(struct pcbit_dev *dev)
 		spin_unlock_irqrestore(&dev->lock, flags);
 	} else {
 		spin_unlock_irqrestore(&dev->lock, flags);
-#ifdef DEBUG
-		printk(KERN_DEBUG "unacked %d free %d write_queue %s\n",
-		     unacked, dev->free, dev->write_queue ? "not empty" :
-		       "empty");
-#endif
+		pr_debug("unacked %d free %d write_queue %s\n",
+			 unacked, dev->free,
+			 dev->write_queue ? "not empty" : "empty");
 	}
 }
 
@@ -385,20 +383,15 @@ pcbit_receive(struct pcbit_dev *dev)
 
 		if (frame->hdr_len == 0) {
 			kfree(frame);
-#ifdef DEBUG
-			printk(KERN_DEBUG "0 sized frame\n");
-#endif
+			pr_debug("0 sized frame\n");
 			pcbit_firmware_bug(dev);
 			return;
 		}
 		/* sanity check the length values */
 		if (frame->hdr_len > 1024 || frame->dt_len > 2048) {
-#ifdef DEBUG
-			printk(KERN_DEBUG "length problem: ");
-			printk(KERN_DEBUG "TH=%04x TD=%04x\n",
-			       frame->hdr_len,
-			       frame->dt_len);
-#endif
+			pr_debug("length problem: TH=%04x TD=%04x\n",
+				 frame->hdr_len,
+				 frame->dt_len);
 			pcbit_l2_error(dev);
 			kfree(frame);
 			return;
@@ -521,9 +514,7 @@ pcbit_irq_handler(int interrupt, void *devptr)
 		return IRQ_HANDLED;
 	}
 	if (info & 0x40U) {     /* E bit set */
-#ifdef DEBUG
-		printk(KERN_DEBUG "pcbit_irq_handler: E bit on\n");
-#endif
+		pr_debug("pcbit_irq_handler: E bit on\n");
 		pcbit_l2_error(dev);
 		dev->interrupt = 0;
 		return IRQ_HANDLED;
@@ -562,10 +553,7 @@ pcbit_l2_active_conf(struct pcbit_dev *dev, u_char info)
 
 	state = dev->l2_state;
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "layer2_active_confirm\n");
-#endif
-
+	pr_debug("layer2_active_confirm\n");
 
 	if (info & 0x80U) {
 		dev->rcv_seq = info & 0x07U;
-- 
1.6.3.1.9.g95405b.dirty


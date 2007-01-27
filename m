Return-Path: <linux-kernel-owner+w=401wt.eu-S932077AbXA0VEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbXA0VEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 16:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932089AbXA0VEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 16:04:35 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:35249 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbXA0VEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 16:04:34 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 27 Jan 2007 16:03:58 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: kkeil@suse.de
Subject: [PATCH] ISDN: Rename some debugging macros to not resemble CONFIG
 options.
Message-ID: <Pine.LNX.4.64.0701271600150.10901@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, TW_TX 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Rename some of the debugging macros for ISDN AVM so that they don't
resemble kernel config settings, as they're primarily for author
debugging instead.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  Replace the "CONFIG_" prefix with an "AVM_" prefix so that the macro
name is still relatively meaningful.


 drivers/isdn/hardware/avm/b1dma.c |   14 +++++++-------
 drivers/isdn/hardware/avm/c4.c    |   16 ++++++++--------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/isdn/hardware/avm/b1dma.c b/drivers/isdn/hardware/avm/b1dma.c
index ddd47cd..1e2d38e 100644
--- a/drivers/isdn/hardware/avm/b1dma.c
+++ b/drivers/isdn/hardware/avm/b1dma.c
@@ -29,7 +29,7 @@

 static char *revision = "$Revision: 1.1.2.3 $";

-#undef CONFIG_B1DMA_DEBUG
+#undef AVM_B1DMA_DEBUG

 /* ------------------------------------------------------------- */

@@ -391,16 +391,16 @@ static void b1dma_dispatch_tx(avmcard *card)
 			_put_slice(&p, skb->data, len);
 		}
 		txlen = (u8 *)p - (u8 *)dma->sendbuf.dmabuf;
-#ifdef CONFIG_B1DMA_DEBUG
+#ifdef AVM_B1DMA_DEBUG
 		printk(KERN_DEBUG "tx: put msg len=%d\n", txlen);
 #endif
 	} else {
 		txlen = skb->len-2;
-#ifdef CONFIG_B1DMA_POLLDEBUG
+#ifdef AVM_B1DMA_POLLDEBUG
 		if (skb->data[2] == SEND_POLLACK)
 			printk(KERN_INFO "%s: send ack\n", card->name);
 #endif
-#ifdef CONFIG_B1DMA_DEBUG
+#ifdef AVM_B1DMA_DEBUG
 		printk(KERN_DEBUG "tx: put 0x%x len=%d\n",
 		       skb->data[2], txlen);
 #endif
@@ -450,7 +450,7 @@ static void b1dma_handle_rx(avmcard *card)
 	u32 ApplId, MsgLen, DataB3Len, NCCI, WindowSize;
 	u8 b1cmd =  _get_byte(&p);

-#ifdef CONFIG_B1DMA_DEBUG
+#ifdef AVM_B1DMA_DEBUG
 	printk(KERN_DEBUG "rx: 0x%x %lu\n", b1cmd, (unsigned long)dma->recvlen);
 #endif

@@ -515,7 +515,7 @@ static void b1dma_handle_rx(avmcard *card)
 		break;

 	case RECEIVE_START:
-#ifdef CONFIG_B1DMA_POLLDEBUG
+#ifdef AVM_B1DMA_POLLDEBUG
 		printk(KERN_INFO "%s: receive poll\n", card->name);
 #endif
 		if (!suppress_pollack)
@@ -601,7 +601,7 @@ static void b1dma_handle_interrupt(avmcard *card)
 				rxlen = (dma->recvlen + 3) & ~3;
 				b1dma_writel(card, dma->recvbuf.dmaaddr+4, AMCC_RXPTR);
 				b1dma_writel(card, rxlen, AMCC_RXLEN);
-#ifdef CONFIG_B1DMA_DEBUG
+#ifdef AVM_B1DMA_DEBUG
 			} else {
 				printk(KERN_ERR "%s: rx not complete (%d).\n",
 					card->name, rxlen);
diff --git a/drivers/isdn/hardware/avm/c4.c b/drivers/isdn/hardware/avm/c4.c
index 2a3eb38..6f5efa8 100644
--- a/drivers/isdn/hardware/avm/c4.c
+++ b/drivers/isdn/hardware/avm/c4.c
@@ -28,8 +28,8 @@
 #include <linux/isdn/capilli.h>
 #include "avmcard.h"

-#undef CONFIG_C4_DEBUG
-#undef CONFIG_C4_POLLDEBUG
+#undef AVM_C4_DEBUG
+#undef AVM_C4_POLLDEBUG

 /* ------------------------------------------------------------- */

@@ -420,7 +420,7 @@ static void c4_dispatch_tx(avmcard *card)

 	skb = skb_dequeue(&dma->send_queue);
 	if (!skb) {
-#ifdef CONFIG_C4_DEBUG
+#ifdef AVM_C4_DEBUG
 		printk(KERN_DEBUG "%s: tx underrun\n", card->name);
 #endif
 		return;
@@ -444,16 +444,16 @@ static void c4_dispatch_tx(avmcard *card)
 			_put_slice(&p, skb->data, len);
 		}
 		txlen = (u8 *)p - (u8 *)dma->sendbuf.dmabuf;
-#ifdef CONFIG_C4_DEBUG
+#ifdef AVM_C4_DEBUG
 		printk(KERN_DEBUG "%s: tx put msg len=%d\n", card->name, txlen);
 #endif
 	} else {
 		txlen = skb->len-2;
-#ifdef CONFIG_C4_POLLDEBUG
+#ifdef AVM_C4_POLLDEBUG
 		if (skb->data[2] == SEND_POLLACK)
 			printk(KERN_INFO "%s: ack to c4\n", card->name);
 #endif
-#ifdef CONFIG_C4_DEBUG
+#ifdef AVM_C4_DEBUG
 		printk(KERN_DEBUG "%s: tx put 0x%x len=%d\n",
 				card->name, skb->data[2], txlen);
 #endif
@@ -508,7 +508,7 @@ static void c4_handle_rx(avmcard *card)
 	u32 cidx;


-#ifdef CONFIG_C4_DEBUG
+#ifdef AVM_C4_DEBUG
 	printk(KERN_DEBUG "%s: rx 0x%x len=%lu\n", card->name,
 				b1cmd, (unsigned long)dma->recvlen);
 #endif
@@ -586,7 +586,7 @@ static void c4_handle_rx(avmcard *card)
 		break;

 	case RECEIVE_START:
-#ifdef CONFIG_C4_POLLDEBUG
+#ifdef AVM_C4_POLLDEBUG
 		printk(KERN_INFO "%s: poll from c4\n", card->name);
 #endif
 		if (!suppress_pollack)
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758594AbYCDDMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbYCDDMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758901AbYCDDKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:10:15 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:39909 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658AbYCDDJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:09:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=C30BVgr3yO5VLvJnK+4Aj38PsZwEPyrWrG3PnMDy0b3/wgq6aXTprlyQN7ZKFB2QVs1ivFBPfrGsBSx3frXD9w/i8rVzv2ajgcFlTw2+ME5gzT5Vba6b+XqFrs8Samh5dYP5GpYxK9bj4q1cttK0G1DZQkM3ObnUJEWtkaDM5mA=
Subject: [PATCH 07/14] isdn: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
References: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 19:09:48 -0800
Message-Id: <1204600188.22933.87.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/isdn/capi/capidrv.c         |    4 ++--
 drivers/isdn/capi/capilib.c         |    2 +-
 drivers/isdn/capi/kcapi.c           |    4 ++--
 drivers/isdn/capi/kcapi.h           |    2 +-
 drivers/isdn/hisax/asuscom.c        |    2 +-
 drivers/isdn/hisax/avm_pci.c        |    2 +-
 drivers/isdn/hisax/diva.c           |    2 +-
 drivers/isdn/hisax/elsa.c           |    2 +-
 drivers/isdn/hisax/hfc_sx.c         |    2 +-
 drivers/isdn/hisax/hfc_usb.c        |    6 +++---
 drivers/isdn/hisax/hfcscard.c       |    2 +-
 drivers/isdn/hisax/hisax_debug.h    |    6 +++---
 drivers/isdn/hisax/hisax_fcpcipnp.c |    2 +-
 drivers/isdn/hisax/ix1_micro.c      |    2 +-
 drivers/isdn/hisax/niccy.c          |    2 +-
 drivers/isdn/hisax/sedlbauer.c      |    2 +-
 drivers/isdn/hisax/st5481.h         |   10 +++++-----
 drivers/isdn/hisax/teles3.c         |    2 +-
 drivers/isdn/i4l/isdn_common.c      |    2 +-
 drivers/isdn/i4l/isdn_net.h         |    6 +++---
 drivers/isdn/i4l/isdn_ppp.c         |   32 ++++++++++++++++----------------
 drivers/isdn/i4l/isdn_tty.c         |    6 +++---
 22 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index cb42b69..36784eb 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -1388,12 +1388,12 @@ static void capidrv_recv_message(struct capi20_appl *ap, struct sk_buff *skb)
 		_cdebbuf *cdb = capi_cmsg2str(&s_cmsg);
 
 		if (cdb) {
-			printk(KERN_DEBUG "%s: applid=%d %s\n", __FUNCTION__,
+			printk(KERN_DEBUG "%s: applid=%d %s\n", __func__,
 				ap->applid, cdb->buf);
 			cdebbuf_free(cdb);
 		} else
 			printk(KERN_DEBUG "%s: applid=%d %s not traced\n",
-				__FUNCTION__, ap->applid,
+				__func__, ap->applid,
 				capi_cmd2str(s_cmsg.Command, s_cmsg.Subcommand));
 	}
 	if (s_cmsg.Command == CAPI_DATA_B3
diff --git a/drivers/isdn/capi/capilib.c b/drivers/isdn/capi/capilib.c
index 68409d9..fed2a58 100644
--- a/drivers/isdn/capi/capilib.c
+++ b/drivers/isdn/capi/capilib.c
@@ -4,7 +4,7 @@
 #include <linux/isdn/capilli.h>
 
 #define DBG(format, arg...) do { \
-printk(KERN_DEBUG "%s: " format "\n" , __FUNCTION__ , ## arg); \
+printk(KERN_DEBUG "%s: " format "\n" , __func__ , ## arg); \
 } while (0)
 
 struct capilib_msgidqueue {
diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index f555318..5b333ad 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -154,7 +154,7 @@ static void register_appl(struct capi_ctr *card, u16 applid, capi_register_param
 	if (card)
 		card->register_appl(card, applid, rparam);
 	else
-		printk(KERN_WARNING "%s: cannot get card resources\n", __FUNCTION__);
+		printk(KERN_WARNING "%s: cannot get card resources\n", __func__);
 }
 

@@ -178,7 +178,7 @@ static void notify_up(u32 contr)
 	        printk(KERN_DEBUG "kcapi: notify up contr %d\n", contr);
 	}
 	if (!card) {
-		printk(KERN_WARNING "%s: invalid contr %d\n", __FUNCTION__, contr);
+		printk(KERN_WARNING "%s: invalid contr %d\n", __func__, contr);
 		return;
 	}
 	for (applid = 1; applid <= CAPI_MAXAPPL; applid++) {
diff --git a/drivers/isdn/capi/kcapi.h b/drivers/isdn/capi/kcapi.h
index 1cb2c40..244711f 100644
--- a/drivers/isdn/capi/kcapi.h
+++ b/drivers/isdn/capi/kcapi.h
@@ -17,7 +17,7 @@
 
 #ifdef KCAPI_DEBUG
 #define DBG(format, arg...) do { \
-printk(KERN_DEBUG "%s: " format "\n" , __FUNCTION__ , ## arg); \
+printk(KERN_DEBUG "%s: " format "\n" , __func__ , ## arg); \
 } while (0)
 #else
 #define DBG(format, arg...) /* */
diff --git a/drivers/isdn/hisax/asuscom.c b/drivers/isdn/hisax/asuscom.c
index 61e69e9..88aaa55 100644
--- a/drivers/isdn/hisax/asuscom.c
+++ b/drivers/isdn/hisax/asuscom.c
@@ -346,7 +346,7 @@ setup_asuscom(struct IsdnCard *card)
 					err = pnp_activate_dev(pnp_d);
 					if (err<0) {
 						printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-							__FUNCTION__, err);
+							__func__, err);
 						return(0);
 					}
 					card->para[1] = pnp_port_start(pnp_d, 0);
diff --git a/drivers/isdn/hisax/avm_pci.c b/drivers/isdn/hisax/avm_pci.c
index 0f1db1f..7cabc5a 100644
--- a/drivers/isdn/hisax/avm_pci.c
+++ b/drivers/isdn/hisax/avm_pci.c
@@ -797,7 +797,7 @@ static int __devinit avm_pnp_setup(struct IsdnCardState *cs)
 			err = pnp_activate_dev(pnp_avm_d);
 			if (err<0) {
 				printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-					__FUNCTION__, err);
+					__func__, err);
 				return(0);
 			}
 			cs->hw.avm.cfg_reg =
diff --git a/drivers/isdn/hisax/diva.c b/drivers/isdn/hisax/diva.c
index 2d67085..018bd29 100644
--- a/drivers/isdn/hisax/diva.c
+++ b/drivers/isdn/hisax/diva.c
@@ -1088,7 +1088,7 @@ static int __devinit setup_diva_isapnp(struct IsdnCard *card)
 				err = pnp_activate_dev(pnp_d);
 				if (err<0) {
 					printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-						__FUNCTION__, err);
+						__func__, err);
 					return(0);
 				}
 				card->para[1] = pnp_port_start(pnp_d, 0);
diff --git a/drivers/isdn/hisax/elsa.c b/drivers/isdn/hisax/elsa.c
index d272d8c..343835f 100644
--- a/drivers/isdn/hisax/elsa.c
+++ b/drivers/isdn/hisax/elsa.c
@@ -937,7 +937,7 @@ setup_elsa_isapnp(struct IsdnCard *card)
 					err = pnp_activate_dev(pnp_d);
 					if (err<0) {
 						printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-							__FUNCTION__, err);
+							__func__, err);
 						return(0);
 					}
 					card->para[1] = pnp_port_start(pnp_d, 0);
diff --git a/drivers/isdn/hisax/hfc_sx.c b/drivers/isdn/hisax/hfc_sx.c
index 05482d2..0bb9d26 100644
--- a/drivers/isdn/hisax/hfc_sx.c
+++ b/drivers/isdn/hisax/hfc_sx.c
@@ -1419,7 +1419,7 @@ setup_hfcsx(struct IsdnCard *card)
 					err = pnp_activate_dev(pnp_d);
 					if (err<0) {
 						printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-							__FUNCTION__, err);
+							__func__, err);
 						return(0);
 					}
 					card->para[1] = pnp_port_start(pnp_d, 0);
diff --git a/drivers/isdn/hisax/hfc_usb.c b/drivers/isdn/hisax/hfc_usb.c
index 98b0149..8df889b 100644
--- a/drivers/isdn/hisax/hfc_usb.c
+++ b/drivers/isdn/hisax/hfc_usb.c
@@ -905,7 +905,7 @@ rx_int_complete(struct urb *urb)
 	if (status) {
 		printk(KERN_INFO
 		       "HFC-S USB: %s error resubmitting URB fifo(%d)\n",
-		       __FUNCTION__, fifon);
+		       __func__, fifon);
 	}
 }
 
@@ -1543,14 +1543,14 @@ hfc_usb_disconnect(struct usb_interface *intf)
 				stop_isoc_chain(&context->fifos[i]);
 				DBG(HFCUSB_DBG_INIT,
 				    "HFC-S USB: %s stopping ISOC chain Fifo(%i)",
-				    __FUNCTION__, i);
+				    __func__, i);
 			}
 		} else {
 			if (context->fifos[i].active > 0) {
 				context->fifos[i].active = 0;
 				DBG(HFCUSB_DBG_INIT,
 				    "HFC-S USB: %s unlinking URB for Fifo(%i)",
-				    __FUNCTION__, i);
+				    __func__, i);
 			}
 			usb_kill_urb(context->fifos[i].urb);
 			usb_free_urb(context->fifos[i].urb);
diff --git a/drivers/isdn/hisax/hfcscard.c b/drivers/isdn/hisax/hfcscard.c
index 909d670..cf08266 100644
--- a/drivers/isdn/hisax/hfcscard.c
+++ b/drivers/isdn/hisax/hfcscard.c
@@ -193,7 +193,7 @@ setup_hfcs(struct IsdnCard *card)
 					err = pnp_activate_dev(pnp_d);
 					if (err<0) {
 						printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-							__FUNCTION__, err);
+							__func__, err);
 						return(0);
 					}
 					card->para[1] = pnp_port_start(pnp_d, 0);
diff --git a/drivers/isdn/hisax/hisax_debug.h b/drivers/isdn/hisax/hisax_debug.h
index ceafecd..5ed3b1c 100644
--- a/drivers/isdn/hisax/hisax_debug.h
+++ b/drivers/isdn/hisax/hisax_debug.h
@@ -27,14 +27,14 @@
 
 #define DBG(level, format, arg...) do { \
 if (level & __debug_variable) \
-printk(KERN_DEBUG "%s: " format "\n" , __FUNCTION__ , ## arg); \
+printk(KERN_DEBUG "%s: " format "\n" , __func__ , ## arg); \
 } while (0)
 
 #define DBG_PACKET(level,data,count) \
-  if (level & __debug_variable) dump_packet(__FUNCTION__,data,count)
+  if (level & __debug_variable) dump_packet(__func__,data,count)
 
 #define DBG_SKB(level,skb) \
-  if ((level & __debug_variable) && skb) dump_packet(__FUNCTION__,skb->data,skb->len)
+  if ((level & __debug_variable) && skb) dump_packet(__func__,skb->data,skb->len)
 

 static void __attribute__((unused))
diff --git a/drivers/isdn/hisax/hisax_fcpcipnp.c b/drivers/isdn/hisax/hisax_fcpcipnp.c
index 7993e01..f9cfb3a 100644
--- a/drivers/isdn/hisax/hisax_fcpcipnp.c
+++ b/drivers/isdn/hisax/hisax_fcpcipnp.c
@@ -935,7 +935,7 @@ static int __devinit fcpnp_probe(struct pnp_dev *pdev, const struct pnp_device_i
 	pnp_disable_dev(pdev);
 	retval = pnp_activate_dev(pdev);
 	if (retval < 0) {
-		printk(KERN_WARNING "%s: pnp_activate_dev(%s) ret(%d)\n", __FUNCTION__,
+		printk(KERN_WARNING "%s: pnp_activate_dev(%s) ret(%d)\n", __func__,
 			(char *)dev_id->driver_data, retval);
 		goto err_free;
 	}
diff --git a/drivers/isdn/hisax/ix1_micro.c b/drivers/isdn/hisax/ix1_micro.c
index 252d79d..b80d972 100644
--- a/drivers/isdn/hisax/ix1_micro.c
+++ b/drivers/isdn/hisax/ix1_micro.c
@@ -253,7 +253,7 @@ setup_ix1micro(struct IsdnCard *card)
 					err = pnp_activate_dev(pnp_d);
 					if (err<0) {
 						printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-							__FUNCTION__, err);
+							__func__, err);
 						return(0);
 					}
 					card->para[1] = pnp_port_start(pnp_d, 0);
diff --git a/drivers/isdn/hisax/niccy.c b/drivers/isdn/hisax/niccy.c
index bd99211..f6c3d25 100644
--- a/drivers/isdn/hisax/niccy.c
+++ b/drivers/isdn/hisax/niccy.c
@@ -256,7 +256,7 @@ int __devinit setup_niccy(struct IsdnCard *card)
 			err = pnp_activate_dev(pnp_d);
 			if (err < 0) {
 				printk(KERN_WARNING "%s: pnp_activate_dev "
-					"ret(%d)\n", __FUNCTION__, err);
+					"ret(%d)\n", __func__, err);
 				return 0;
 			}
 			card->para[1] = pnp_port_start(pnp_d, 0);
diff --git a/drivers/isdn/hisax/sedlbauer.c b/drivers/isdn/hisax/sedlbauer.c
index 95425f3..a10dfa8 100644
--- a/drivers/isdn/hisax/sedlbauer.c
+++ b/drivers/isdn/hisax/sedlbauer.c
@@ -555,7 +555,7 @@ setup_sedlbauer_isapnp(struct IsdnCard *card, int *bytecnt)
 				err = pnp_activate_dev(pnp_d);
 				if (err<0) {
 					printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-						__FUNCTION__, err);
+						__func__, err);
 					return(0);
 				}
 				card->para[1] = pnp_port_start(pnp_d, 0);
diff --git a/drivers/isdn/hisax/st5481.h b/drivers/isdn/hisax/st5481.h
index 04416ba..2044e71 100644
--- a/drivers/isdn/hisax/st5481.h
+++ b/drivers/isdn/hisax/st5481.h
@@ -218,13 +218,13 @@ enum {
 #define L1_EVENT_COUNT (EV_TIMER3 + 1)
 
 #define ERR(format, arg...) \
-printk(KERN_ERR "%s:%s: " format "\n" , __FILE__,  __FUNCTION__ , ## arg)
+printk(KERN_ERR "%s:%s: " format "\n" , __FILE__,  __func__ , ## arg)
 
 #define WARN(format, arg...) \
-printk(KERN_WARNING "%s:%s: " format "\n" , __FILE__,  __FUNCTION__ , ## arg)
+printk(KERN_WARNING "%s:%s: " format "\n" , __FILE__,  __func__ , ## arg)
 
 #define INFO(format, arg...) \
-printk(KERN_INFO "%s:%s: " format "\n" , __FILE__,  __FUNCTION__ , ## arg)
+printk(KERN_INFO "%s:%s: " format "\n" , __FILE__,  __func__ , ## arg)
 
 #include "isdnhdlc.h"
 #include "fsm.h"
@@ -406,7 +406,7 @@ struct st5481_adapter {
 
 /*
  * Submit an URB with error reporting. This is a macro so
- * the __FUNCTION__ returns the caller function name.
+ * the __func__ returns the caller function name.
  */
 #define SUBMIT_URB(urb, mem_flags) \
 ({ \
@@ -470,7 +470,7 @@ extern int st5481_debug;
 #ifdef CONFIG_HISAX_DEBUG
 
 #define DBG_ISO_PACKET(level,urb) \
-  if (level & __debug_variable) dump_iso_packet(__FUNCTION__,urb)
+  if (level & __debug_variable) dump_iso_packet(__func__,urb)
 
 static void __attribute__((unused))
 dump_iso_packet(const char *name, struct urb *urb)
diff --git a/drivers/isdn/hisax/teles3.c b/drivers/isdn/hisax/teles3.c
index 6a5e379..5dc9f1a 100644
--- a/drivers/isdn/hisax/teles3.c
+++ b/drivers/isdn/hisax/teles3.c
@@ -301,7 +301,7 @@ setup_teles3(struct IsdnCard *card)
 					err = pnp_activate_dev(pnp_d);
 					if (err<0) {
 						printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-							__FUNCTION__, err);
+							__func__, err);
 						return(0);
 					}
 					card->para[3] = pnp_port_start(pnp_d, 2);
diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index 9cef6fc..bd78019 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -1924,7 +1924,7 @@ isdn_free_channel(int di, int ch, int usage)
 
 	if ((di < 0) || (ch < 0)) {
 		printk(KERN_WARNING "%s: called with invalid drv(%d) or channel(%d)\n",
-			__FUNCTION__, di, ch);
+			__func__, di, ch);
 		return;
 	}
 	for (i = 0; i < ISDN_MAX_CHANNELS; i++)
diff --git a/drivers/isdn/i4l/isdn_net.h b/drivers/isdn/i4l/isdn_net.h
index bc2f0dd..be49497 100644
--- a/drivers/isdn/i4l/isdn_net.h
+++ b/drivers/isdn/i4l/isdn_net.h
@@ -108,7 +108,7 @@ static __inline__ void isdn_net_add_to_bundle(isdn_net_dev *nd, isdn_net_local *
 
 	lp = nd->queue;
 //	printk(KERN_DEBUG "%s: lp:%s(%p) nlp:%s(%p) last(%p)\n",
-//		__FUNCTION__, lp->name, lp, nlp->name, nlp, lp->last);
+//		__func__, lp->name, lp, nlp->name, nlp, lp->last);
 	nlp->last = lp->last;
 	lp->last->next = nlp;
 	lp->last = nlp;
@@ -129,7 +129,7 @@ static __inline__ void isdn_net_rm_from_bundle(isdn_net_local *lp)
 		master_lp = (isdn_net_local *) lp->master->priv;
 
 //	printk(KERN_DEBUG "%s: lp:%s(%p) mlp:%s(%p) last(%p) next(%p) mndq(%p)\n",
-//		__FUNCTION__, lp->name, lp, master_lp->name, master_lp, lp->last, lp->next, master_lp->netdev->queue);
+//		__func__, lp->name, lp, master_lp->name, master_lp, lp->last, lp->next, master_lp->netdev->queue);
 	spin_lock_irqsave(&master_lp->netdev->queue_lock, flags);
 	lp->last->next = lp->next;
 	lp->next->last = lp->last;
@@ -141,7 +141,7 @@ static __inline__ void isdn_net_rm_from_bundle(isdn_net_local *lp)
 	}
 	lp->next = lp->last = lp;	/* (re)set own pointers */
 //	printk(KERN_DEBUG "%s: mndq(%p)\n",
-//		__FUNCTION__, master_lp->netdev->queue);
+//		__func__, master_lp->netdev->queue);
 	spin_unlock_irqrestore(&master_lp->netdev->queue_lock, flags);
 }
 
diff --git a/drivers/isdn/i4l/isdn_ppp.c b/drivers/isdn/i4l/isdn_ppp.c
index 9f5fe37..127cfda 100644
--- a/drivers/isdn/i4l/isdn_ppp.c
+++ b/drivers/isdn/i4l/isdn_ppp.c
@@ -110,7 +110,7 @@ isdn_ppp_free(isdn_net_local * lp)
 
 	if (lp->ppp_slot < 0 || lp->ppp_slot >= ISDN_MAX_CHANNELS) {
 		printk(KERN_ERR "%s: ppp_slot(%d) out of range\n",
-			__FUNCTION__, lp->ppp_slot);
+			__func__, lp->ppp_slot);
 		return 0;
 	}
 
@@ -127,7 +127,7 @@ isdn_ppp_free(isdn_net_local * lp)
 #endif /* CONFIG_ISDN_MPP */
 	if (lp->ppp_slot < 0 || lp->ppp_slot >= ISDN_MAX_CHANNELS) {
 		printk(KERN_ERR "%s: ppp_slot(%d) now invalid\n",
-			__FUNCTION__, lp->ppp_slot);
+			__func__, lp->ppp_slot);
 		return 0;
 	}
 	is = ippp_table[lp->ppp_slot];
@@ -226,7 +226,7 @@ isdn_ppp_wakeup_daemon(isdn_net_local * lp)
 {
 	if (lp->ppp_slot < 0 || lp->ppp_slot >= ISDN_MAX_CHANNELS) {
 		printk(KERN_ERR "%s: ppp_slot(%d) out of range\n",
-			__FUNCTION__, lp->ppp_slot);
+			__func__, lp->ppp_slot);
 		return;
 	}
 	ippp_table[lp->ppp_slot]->state = IPPP_OPEN | IPPP_CONNECT | IPPP_NOBLOCK;
@@ -245,7 +245,7 @@ isdn_ppp_closewait(int slot)
 
 	if (slot < 0 || slot >= ISDN_MAX_CHANNELS) {
 		printk(KERN_ERR "%s: slot(%d) out of range\n",
-			__FUNCTION__, slot);
+			__func__, slot);
 		return 0;
 	}
 	is = ippp_table[slot];
@@ -343,7 +343,7 @@ isdn_ppp_release(int min, struct file *file)
 	is = file->private_data;
 
 	if (!is) {
-		printk(KERN_ERR "%s: no file->private_data\n", __FUNCTION__);
+		printk(KERN_ERR "%s: no file->private_data\n", __func__);
 		return;
 	}
 	if (is->debug & 0x1)
@@ -353,7 +353,7 @@ isdn_ppp_release(int min, struct file *file)
 		isdn_net_dev *p = is->lp->netdev;
 
 		if (!p) {
-			printk(KERN_ERR "%s: no lp->netdev\n", __FUNCTION__);
+			printk(KERN_ERR "%s: no lp->netdev\n", __func__);
 			return;
 		}
 		is->state &= ~IPPP_CONNECT;	/* -> effect: no call of wakeup */
@@ -1080,7 +1080,7 @@ isdn_ppp_push_higher(isdn_net_dev * net_dev, isdn_net_local * lp, struct sk_buff
 				printk(KERN_DEBUG "isdn_ppp: VJC_UNCOMP\n");
 			if (net_dev->local->ppp_slot < 0) {
 				printk(KERN_ERR "%s: net_dev->local->ppp_slot(%d) out of range\n",
-					__FUNCTION__, net_dev->local->ppp_slot);
+					__func__, net_dev->local->ppp_slot);
 				goto drop_packet;
 			}
 			if (slhc_remember(ippp_table[net_dev->local->ppp_slot]->slcomp, skb->data, skb->len) <= 0) {
@@ -1107,7 +1107,7 @@ isdn_ppp_push_higher(isdn_net_dev * net_dev, isdn_net_local * lp, struct sk_buff
 							  skb_old->len);
 				if (net_dev->local->ppp_slot < 0) {
 					printk(KERN_ERR "%s: net_dev->local->ppp_slot(%d) out of range\n",
-						__FUNCTION__, net_dev->local->ppp_slot);
+						__func__, net_dev->local->ppp_slot);
 					goto drop_packet;
 				}
 				pkt_len = slhc_uncompress(ippp_table[net_dev->local->ppp_slot]->slcomp,
@@ -1553,7 +1553,7 @@ static int isdn_ppp_mp_init( isdn_net_local * lp, ippp_bundle * add_to )
 
 	if (lp->ppp_slot < 0) {
 		printk(KERN_ERR "%s: lp->ppp_slot(%d) out of range\n",
-			__FUNCTION__, lp->ppp_slot);
+			__func__, lp->ppp_slot);
 		return(-EINVAL);
 	}
 
@@ -1604,7 +1604,7 @@ static void isdn_ppp_mp_receive(isdn_net_dev * net_dev, isdn_net_local * lp,
 	slot = lp->ppp_slot;
 	if (slot < 0 || slot >= ISDN_MAX_CHANNELS) {
 		printk(KERN_ERR "%s: lp->ppp_slot(%d)\n",
-			__FUNCTION__, lp->ppp_slot);
+			__func__, lp->ppp_slot);
 		stats->frame_drops++;
 		dev_kfree_skb(skb);
 		spin_unlock_irqrestore(&mp->lock, flags);
@@ -1641,7 +1641,7 @@ static void isdn_ppp_mp_receive(isdn_net_dev * net_dev, isdn_net_local * lp,
 		slot = lpq->ppp_slot;
 		if (slot < 0 || slot >= ISDN_MAX_CHANNELS) {
 			printk(KERN_ERR "%s: lpq->ppp_slot(%d)\n",
-				__FUNCTION__, lpq->ppp_slot);
+				__func__, lpq->ppp_slot);
 		} else {
 			u32 lls = ippp_table[slot]->last_link_seqno;
 			if (MP_LT(lls, minseq))
@@ -1875,7 +1875,7 @@ void isdn_ppp_mp_reassembly( isdn_net_dev * net_dev, isdn_net_local * lp,
 
 	if (lp->ppp_slot < 0 || lp->ppp_slot >= ISDN_MAX_CHANNELS) {
 		printk(KERN_ERR "%s: lp->ppp_slot(%d) out of range\n",
-			__FUNCTION__, lp->ppp_slot);
+			__func__, lp->ppp_slot);
 		return;
 	}
 	if( MP_FLAGS(from) == (MP_BEGIN_FRAG | MP_END_FRAG) ) {
@@ -2655,7 +2655,7 @@ static void isdn_ppp_receive_ccp(isdn_net_dev *net_dev, isdn_net_local *lp,
 		lp->ppp_slot);
 	if (lp->ppp_slot < 0 || lp->ppp_slot >= ISDN_MAX_CHANNELS) {
 		printk(KERN_ERR "%s: lp->ppp_slot(%d) out of range\n",
-			__FUNCTION__, lp->ppp_slot);
+			__func__, lp->ppp_slot);
 		return;
 	}
 	is = ippp_table[lp->ppp_slot];
@@ -2665,7 +2665,7 @@ static void isdn_ppp_receive_ccp(isdn_net_dev *net_dev, isdn_net_local *lp,
 		int slot = ((isdn_net_local *) (lp->master->priv))->ppp_slot;
 		if (slot < 0 || slot >= ISDN_MAX_CHANNELS) {
 			printk(KERN_ERR "%s: slot(%d) out of range\n",
-				__FUNCTION__, slot);
+				__func__, slot);
 			return;
 		}	
 		mis = ippp_table[slot];
@@ -2829,7 +2829,7 @@ static void isdn_ppp_send_ccp(isdn_net_dev *net_dev, isdn_net_local *lp, struct
 		return;
 	if (slot < 0 || slot >= ISDN_MAX_CHANNELS) {
 		printk(KERN_ERR "%s: lp->ppp_slot(%d) out of range\n",
-			__FUNCTION__, slot);
+			__func__, slot);
 		return;
 	}	
 	is = ippp_table[slot];
@@ -2852,7 +2852,7 @@ static void isdn_ppp_send_ccp(isdn_net_dev *net_dev, isdn_net_local *lp, struct
 		slot = ((isdn_net_local *) (lp->master->priv))->ppp_slot;
 		if (slot < 0 || slot >= ISDN_MAX_CHANNELS) {
 			printk(KERN_ERR "%s: slot(%d) out of range\n",
-				__FUNCTION__, slot);
+				__func__, slot);
 			return;
 		}	
 		mis = ippp_table[slot];
diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 133eb18..8af0df1 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1347,7 +1347,7 @@ isdn_tty_tiocmget(struct tty_struct *tty, struct file *file)
 	modem_info *info = (modem_info *) tty->driver_data;
 	u_char control, status;
 
-	if (isdn_tty_paranoia_check(info, tty->name, __FUNCTION__))
+	if (isdn_tty_paranoia_check(info, tty->name, __func__))
 		return -ENODEV;
 	if (tty->flags & (1 << TTY_IO_ERROR))
 		return -EIO;
@@ -1372,7 +1372,7 @@ isdn_tty_tiocmset(struct tty_struct *tty, struct file *file,
 {
 	modem_info *info = (modem_info *) tty->driver_data;
 
-	if (isdn_tty_paranoia_check(info, tty->name, __FUNCTION__))
+	if (isdn_tty_paranoia_check(info, tty->name, __func__))
 		return -ENODEV;
 	if (tty->flags & (1 << TTY_IO_ERROR))
 		return -EIO;
@@ -1608,7 +1608,7 @@ isdn_tty_open(struct tty_struct *tty, struct file *filp)
 	if (isdn_tty_paranoia_check(info, tty->name, "isdn_tty_open"))
 		return -ENODEV;
 	if (!try_module_get(info->owner)) {
-		printk(KERN_WARNING "%s: cannot reserve module\n", __FUNCTION__);
+		printk(KERN_WARNING "%s: cannot reserve module\n", __func__);
 		return -ENODEV;
 	}
 #ifdef ISDN_DEBUG_MODEM_OPEN
-- 
1.5.4.3.500.g83a2c



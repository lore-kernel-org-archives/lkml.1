Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbYGHRBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbYGHRBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757618AbYGHQ6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:58:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:55157 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757606AbYGHQ6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:58:02 -0400
Date: Tue, 8 Jul 2008 09:39:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu
Subject: [patch 1/17] Clear the WARN() namespace
Message-ID: <20080708093930.44ba9d08@infradead.org>
In-Reply-To: <20080708093800.274504ba@infradead.org>
References: <20080708093800.274504ba@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

We want to use WARN() as a variant of WARN_ON(), however a few drivers are
using WARN() internally.  This patch renames these to WARNING() to avoid the
namespace clash.  A few cases were defining but not using the thing, for those
cases I just deleted the definition.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Greg KH <greg@kroah.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/st5481.h       |    4 
 drivers/isdn/hisax/st5481_b.c     |    4 
 drivers/isdn/hisax/st5481_d.c     |    6 
 drivers/isdn/hisax/st5481_usb.c   |   18 +-
 drivers/usb/gadget/at91_udc.h     |    2 
 drivers/usb/gadget/cdc2.c         |    2 
 drivers/usb/gadget/ether.c        |    2 
 drivers/usb/gadget/file_storage.c |   14 -
 drivers/usb/gadget/fsl_usb2_udc.c |    2 
 drivers/usb/gadget/fsl_usb2_udc.h |    2 
 drivers/usb/gadget/gmidi.c        |    2 
 drivers/usb/gadget/goku_udc.c     |    2 
 drivers/usb/gadget/goku_udc.h     |    2 
 drivers/usb/gadget/inode.c        |    2 
 drivers/usb/gadget/net2280.c      |    2 
 drivers/usb/gadget/net2280.h      |    2 
 drivers/usb/gadget/omap_udc.c     |    6 
 drivers/usb/gadget/omap_udc.h     |    2 
 drivers/usb/gadget/printer.c      |    2 
 drivers/usb/gadget/pxa25x_udc.c   |    6 
 drivers/usb/gadget/pxa25x_udc.h   |    2 
 drivers/usb/gadget/u_ether.c      |    3 
 drivers/usb/host/isp116x-hcd.c    |    2 
 drivers/usb/host/isp116x.h        |    2 
 drivers/usb/host/sl811-hcd.c      |    2 
 drivers/usb/host/sl811.h          |    2 
 drivers/usb/misc/usbtest.c        |    4 
 include/linux/usb/composite.h     |    2 
 usr/share/quilt/refresh           |  304 --------------------------------------
 29 files changed, 48 insertions(+), 359 deletions(-)

Index: linux.trees.git/drivers/isdn/hisax/st5481.h
===================================================================
--- linux.trees.git.orig/drivers/isdn/hisax/st5481.h
+++ linux.trees.git/drivers/isdn/hisax/st5481.h
@@ -220,7 +220,7 @@ enum {
 #define ERR(format, arg...) \
 printk(KERN_ERR "%s:%s: " format "\n" , __FILE__,  __func__ , ## arg)
 
-#define WARN(format, arg...) \
+#define WARNING(format, arg...) \
 printk(KERN_WARNING "%s:%s: " format "\n" , __FILE__,  __func__ , ## arg)
 
 #define INFO(format, arg...) \
@@ -412,7 +412,7 @@ struct st5481_adapter {
 ({ \
 	int status; \
 	if ((status = usb_submit_urb(urb, mem_flags)) < 0) { \
-		WARN("usb_submit_urb failed,status=%d", status); \
+		WARNING("usb_submit_urb failed,status=%d", status); \
 	} \
         status; \
 })
Index: linux.trees.git/drivers/isdn/hisax/st5481_b.c
===================================================================
--- linux.trees.git.orig/drivers/isdn/hisax/st5481_b.c
+++ linux.trees.git/drivers/isdn/hisax/st5481_b.c
@@ -180,7 +180,7 @@ static void usb_b_out_complete(struct ur
 				DBG(4,"urb killed status %d", urb->status);
 				return; // Give up
 			default: 
-				WARN("urb status %d",urb->status);
+				WARNING("urb status %d",urb->status);
 				if (b_out->busy == 0) {
 					st5481_usb_pipe_reset(adapter, (bcs->channel+1)*2 | USB_DIR_OUT, NULL, NULL);
 				}
@@ -372,6 +372,6 @@ void st5481_b_l2l1(struct hisax_if *ifc,
 		B_L1L2(bcs, PH_DEACTIVATE | INDICATION, NULL);
 		break;
 	default:
-		WARN("pr %#x\n", pr);
+		WARNING("pr %#x\n", pr);
 	}
 }
Index: linux.trees.git/drivers/isdn/hisax/st5481_d.c
===================================================================
--- linux.trees.git.orig/drivers/isdn/hisax/st5481_d.c
+++ linux.trees.git/drivers/isdn/hisax/st5481_d.c
@@ -389,7 +389,7 @@ static void usb_d_out_complete(struct ur
 				DBG(1,"urb killed status %d", urb->status);
 				break;
 			default: 
-				WARN("urb status %d",urb->status);
+				WARNING("urb status %d",urb->status);
 				if (d_out->busy == 0) {
 					st5481_usb_pipe_reset(adapter, EP_D_OUT | USB_DIR_OUT, fifo_reseted, adapter);
 				}
@@ -420,7 +420,7 @@ static void dout_start_xmit(struct FsmIn
 	isdnhdlc_out_init(&d_out->hdlc_state, 1, 0);
 
 	if (test_and_set_bit(buf_nr, &d_out->busy)) {
-		WARN("ep %d urb %d busy %#lx", EP_D_OUT, buf_nr, d_out->busy);
+		WARNING("ep %d urb %d busy %#lx", EP_D_OUT, buf_nr, d_out->busy);
 		return;
 	}
 	urb = d_out->urb[buf_nr];
@@ -601,7 +601,7 @@ void st5481_d_l2l1(struct hisax_if *hisa
 		FsmEvent(&adapter->d_out.fsm, EV_DOUT_START_XMIT, NULL);
 		break;
 	default:
-		WARN("pr %#x\n", pr);
+		WARNING("pr %#x\n", pr);
 		break;
 	}
 }
Index: linux.trees.git/drivers/isdn/hisax/st5481_usb.c
===================================================================
--- linux.trees.git.orig/drivers/isdn/hisax/st5481_usb.c
+++ linux.trees.git/drivers/isdn/hisax/st5481_usb.c
@@ -66,7 +66,7 @@ static void usb_ctrl_msg(struct st5481_a
 	struct ctrl_msg *ctrl_msg;
 	
 	if ((w_index = fifo_add(&ctrl->msg_fifo.f)) < 0) {
-		WARN("control msg FIFO full");
+		WARNING("control msg FIFO full");
 		return;
 	}
 	ctrl_msg = &ctrl->msg_fifo.data[w_index]; 
@@ -139,7 +139,7 @@ static void usb_ctrl_complete(struct urb
 				DBG(1,"urb killed status %d", urb->status);
 				return; // Give up
 			default: 
-				WARN("urb status %d",urb->status);
+				WARNING("urb status %d",urb->status);
 				break;
 		}
 	}
@@ -198,7 +198,7 @@ static void usb_int_complete(struct urb 
 			DBG(2, "urb shutting down with status: %d", urb->status);
 			return;
 		default:
-			WARN("nonzero urb status received: %d", urb->status);
+			WARNING("nonzero urb status received: %d", urb->status);
 			goto exit;
 	}
 
@@ -235,7 +235,7 @@ static void usb_int_complete(struct urb 
 exit:
 	status = usb_submit_urb (urb, GFP_ATOMIC);
 	if (status)
-		WARN("usb_submit_urb failed with result %d", status);
+		WARNING("usb_submit_urb failed with result %d", status);
 }
 
 /* ======================================================================
@@ -257,7 +257,7 @@ int st5481_setup_usb(struct st5481_adapt
 	DBG(2,"");
 	
 	if ((status = usb_reset_configuration (dev)) < 0) {
-		WARN("reset_configuration failed,status=%d",status);
+		WARNING("reset_configuration failed,status=%d",status);
 		return status;
 	}
 
@@ -269,7 +269,7 @@ int st5481_setup_usb(struct st5481_adapt
 
 	// Check if the config is sane
 	if ( altsetting->desc.bNumEndpoints != 7 ) {
-		WARN("expecting 7 got %d endpoints!", altsetting->desc.bNumEndpoints);
+		WARNING("expecting 7 got %d endpoints!", altsetting->desc.bNumEndpoints);
 		return -EINVAL;
 	}
 
@@ -279,7 +279,7 @@ int st5481_setup_usb(struct st5481_adapt
 
 	// Use alternative setting 3 on interface 0 to have 2B+D
 	if ((status = usb_set_interface (dev, 0, 3)) < 0) {
-		WARN("usb_set_interface failed,status=%d",status);
+		WARNING("usb_set_interface failed,status=%d",status);
 		return status;
 	}
 
@@ -497,7 +497,7 @@ static void usb_in_complete(struct urb *
 				DBG(1,"urb killed status %d", urb->status);
 				return; // Give up
 			default: 
-				WARN("urb status %d",urb->status);
+				WARNING("urb status %d",urb->status);
 				break;
 		}
 	}
@@ -523,7 +523,7 @@ static void usb_in_complete(struct urb *
 			DBG(4,"count=%d",status);
 			DBG_PACKET(0x400, in->rcvbuf, status);
 			if (!(skb = dev_alloc_skb(status))) {
-				WARN("receive out of memory\n");
+				WARNING("receive out of memory\n");
 				break;
 			}
 			memcpy(skb_put(skb, status), in->rcvbuf, status);
Index: linux.trees.git/drivers/usb/gadget/ether.c
===================================================================
--- linux.trees.git.orig/drivers/usb/gadget/ether.c
+++ linux.trees.git/drivers/usb/gadget/ether.c
@@ -293,7 +293,7 @@ static int __init eth_bind(struct usb_co
 		 * but if the controller isn't recognized at all then
 		 * that assumption is a bit more likely to be wrong.
 		 */
-		WARN(cdev, "controller '%s' not recognized; trying %s\n",
+		WARNING(cdev, "controller '%s' not recognized; trying %s\n",
 				gadget->name,
 				eth_config_driver.label);
 		device_desc.bcdDevice =
Index: linux.trees.git/drivers/usb/gadget/file_storage.c
===================================================================
--- linux.trees.git.orig/drivers/usb/gadget/file_storage.c
+++ linux.trees.git/drivers/usb/gadget/file_storage.c
@@ -308,7 +308,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 	dev_vdbg(&(d)->gadget->dev , fmt , ## args)
 #define ERROR(d, fmt, args...) \
 	dev_err(&(d)->gadget->dev , fmt , ## args)
-#define WARN(d, fmt, args...) \
+#define WARNING(d, fmt, args...) \
 	dev_warn(&(d)->gadget->dev , fmt , ## args)
 #define INFO(d, fmt, args...) \
 	dev_info(&(d)->gadget->dev , fmt , ## args)
@@ -1091,7 +1091,7 @@ static int ep0_queue(struct fsg_dev *fsg
 	if (rc != 0 && rc != -ESHUTDOWN) {
 
 		/* We can't do much more than wait for a reset */
-		WARN(fsg, "error in submission: %s --> %d\n",
+		WARNING(fsg, "error in submission: %s --> %d\n",
 				fsg->ep0->name, rc);
 	}
 	return rc;
@@ -1227,7 +1227,7 @@ static void received_cbi_adsc(struct fsg
 
 	/* Save the command for later */
 	if (fsg->cbbuf_cmnd_size)
-		WARN(fsg, "CB[I] overwriting previous command\n");
+		WARNING(fsg, "CB[I] overwriting previous command\n");
 	fsg->cbbuf_cmnd_size = req->actual;
 	memcpy(fsg->cbbuf_cmnd, req->buf, fsg->cbbuf_cmnd_size);
 
@@ -1506,7 +1506,7 @@ static void start_transfer(struct fsg_de
 		 * submissions if DMA is enabled. */
 		if (rc != -ESHUTDOWN && !(rc == -EOPNOTSUPP &&
 						req->length == 0))
-			WARN(fsg, "error in submission: %s --> %d\n",
+			WARNING(fsg, "error in submission: %s --> %d\n",
 					ep->name, rc);
 	}
 }
@@ -2294,7 +2294,7 @@ static int halt_bulk_in_endpoint(struct 
 		VDBG(fsg, "delayed bulk-in endpoint halt\n");
 	while (rc != 0) {
 		if (rc != -EAGAIN) {
-			WARN(fsg, "usb_ep_set_halt -> %d\n", rc);
+			WARNING(fsg, "usb_ep_set_halt -> %d\n", rc);
 			rc = 0;
 			break;
 		}
@@ -2317,7 +2317,7 @@ static int wedge_bulk_in_endpoint(struct
 		VDBG(fsg, "delayed bulk-in endpoint wedge\n");
 	while (rc != 0) {
 		if (rc != -EAGAIN) {
-			WARN(fsg, "usb_ep_set_wedge -> %d\n", rc);
+			WARNING(fsg, "usb_ep_set_wedge -> %d\n", rc);
 			rc = 0;
 			break;
 		}
@@ -3755,7 +3755,7 @@ static int __init check_parameters(struc
 		if (gcnum >= 0)
 			mod_data.release = 0x0300 + gcnum;
 		else {
-			WARN(fsg, "controller '%s' not recognized\n",
+			WARNING(fsg, "controller '%s' not recognized\n",
 				fsg->gadget->name);
 			mod_data.release = 0x0399;
 		}
Index: linux.trees.git/drivers/usb/gadget/fsl_usb2_udc.c
===================================================================
--- linux.trees.git.orig/drivers/usb/gadget/fsl_usb2_udc.c
+++ linux.trees.git/drivers/usb/gadget/fsl_usb2_udc.c
@@ -1538,7 +1538,7 @@ static void dtd_complete_irq(struct fsl_
 
 		/* If the ep is configured */
 		if (curr_ep->name == NULL) {
-			WARN("Invalid EP?");
+			WARNING("Invalid EP?");
 			continue;
 		}
 
Index: linux.trees.git/drivers/usb/gadget/fsl_usb2_udc.h
===================================================================
--- linux.trees.git.orig/drivers/usb/gadget/fsl_usb2_udc.h
+++ linux.trees.git/drivers/usb/gadget/fsl_usb2_udc.h
@@ -552,7 +552,7 @@ static void dump_msg(const char *label, 
 #endif
 
 #define ERR(stuff...)		pr_err("udc: " stuff)
-#define WARN(stuff...)		pr_warning("udc: " stuff)
+#define WARNING(stuff...)		pr_warning("udc: " stuff)
 #define INFO(stuff...)		pr_info("udc: " stuff)
 
 /*-------------------------------------------------------------------------*/
Index: linux.trees.git/drivers/usb/gadget/gmidi.c
===================================================================
--- linux.trees.git.orig/drivers/usb/gadget/gmidi.c
+++ linux.trees.git/drivers/usb/gadget/gmidi.c
@@ -138,8 +138,6 @@ static void gmidi_transmit(struct gmidi_
 	dev_vdbg(&(d)->gadget->dev , fmt , ## args)
 #define ERROR(d, fmt, args...) \
 	dev_err(&(d)->gadget->dev , fmt , ## args)
-#define WARN(d, fmt, args...) \
-	dev_warn(&(d)->gadget->dev , fmt , ## args)
 #define INFO(d, fmt, args...) \
 	dev_info(&(d)->gadget->dev , fmt , ## args)
 
Index: linux.trees.git/drivers/usb/gadget/goku_udc.c
===================================================================
--- linux.trees.git.orig/drivers/usb/gadget/goku_udc.c
+++ linux.trees.git/drivers/usb/gadget/goku_udc.c
@@ -1768,7 +1768,7 @@ static int goku_probe(struct pci_dev *pd
 	 * usb_gadget_driver_{register,unregister}() must change.
 	 */
 	if (the_controller) {
-		WARN(dev, "ignoring %s\n", pci_name(pdev));
+		WARNING(dev, "ignoring %s\n", pci_name(pdev));
 		return -EBUSY;
 	}
 	if (!pdev->irq) {
Index: linux.trees.git/drivers/usb/gadget/goku_udc.h
===================================================================
--- linux.trees.git.orig/drivers/usb/gadget/goku_udc.h
+++ linux.trees.git/drivers/usb/gadget/goku_udc.h
@@ -285,7 +285,7 @@ struct goku_udc {
 
 #define ERROR(dev,fmt,args...) \
 	xprintk(dev , KERN_ERR , fmt , ## args)
-#define WARN(dev,fmt,args...) \
+#define WARNING(dev,fmt,args...) \
 	xprintk(dev , KERN_WARNING , fmt , ## args)
 #define INFO(dev,fmt,args...) \
 	xprintk(dev , KERN_INFO , fmt , ## args)
Index: linux.trees.git/drivers/usb/gadget/inode.c
===================================================================
--- linux.trees.git.orig/drivers/usb/gadget/inode.c
+++ linux.trees.git/drivers/usb/gadget/inode.c
@@ -262,8 +262,6 @@ static const char *CHIP;
 
 #define ERROR(dev,fmt,args...) \
 	xprintk(dev , KERN_ERR , fmt , ## args)
-#define WARN(dev,fmt,args...) \
-	xprintk(dev , KERN_WARNING , fmt , ## args)
 #define INFO(dev,fmt,args...) \
 	xprintk(dev , KERN_INFO , fmt , ## args)
 
Index: linux.trees.git/drivers/usb/gadget/net2280.c
===================================================================
--- linux.trees.git.orig/drivers/usb/gadget/net2280.c
+++ linux.trees.git/drivers/usb/gadget/net2280.c
@@ -1007,7 +1007,7 @@ static void scan_dma_completions (struct
 			 * 0122, and 0124; not all cases trigger the warning.
 			 */
 			if ((tmp & (1 << NAK_OUT_PACKETS)) == 0) {
-				WARN (ep->dev, "%s lost packet sync!\n",
+				WARNING (ep->dev, "%s lost packet sync!\n",
 						ep->ep.name);
 				req->req.status = -EOVERFLOW;
 			} else if ((tmp = readl (&ep->regs->ep_avail)) != 0) {
Index: linux.trees.git/drivers/usb/gadget/net2280.h
===================================================================
--- linux.trees.git.orig/drivers/usb/gadget/net2280.h
+++ linux.trees.git/drivers/usb/gadget/net2280.h
@@ -272,7 +272,7 @@ static inline void net2280_led_shutdown 
 
 #define ERROR(dev,fmt,args...) \
 	xprintk(dev , KERN_ERR , fmt , ## args)
-#define WARN(dev,fmt,args...) \
+#define WARNING(dev,fmt,args...) \
 	xprintk(dev , KERN_WARNING , fmt , ## args)
 #define INFO(dev,fmt,args...) \
 	xprintk(dev , KERN_INFO , fmt , ## args)
Index: linux.trees.git/drivers/usb/gadget/omap_udc.c
===================================================================
--- linux.trees.git.orig/drivers/usb/gadget/omap_udc.c
+++ linux.trees.git/drivers/usb/gadget/omap_udc.c
@@ -1120,7 +1120,7 @@ static int omap_ep_set_halt(struct usb_e
 			status = -EINVAL;
 		else if (value) {
 			if (ep->udc->ep0_set_config) {
-				WARN("error changing config?\n");
+				WARNING("error changing config?\n");
 				omap_writew(UDC_CLR_CFG, UDC_SYSCON2);
 			}
 			omap_writew(UDC_STALL_CMD, UDC_SYSCON2);
@@ -1764,7 +1764,7 @@ do_stall:
 					u.r.bRequestType, u.r.bRequest, status);
 			if (udc->ep0_set_config) {
 				if (udc->ep0_reset_config)
-					WARN("error resetting config?\n");
+					WARNING("error resetting config?\n");
 				else
 					omap_writew(UDC_CLR_CFG, UDC_SYSCON2);
 			}
@@ -3076,7 +3076,7 @@ static int omap_udc_suspend(struct platf
 	 * which would prevent entry to deep sleep...
 	 */
 	if ((devstat & UDC_ATT) != 0 && (devstat & UDC_SUS) == 0) {
-		WARN("session active; suspend requires disconnect\n");
+		WARNING("session active; suspend requires disconnect\n");
 		omap_pullup(&udc->gadget, 0);
 	}
 
Index: linux.trees.git/drivers/usb/gadget/omap_udc.h
===================================================================
--- linux.trees.git.orig/drivers/usb/gadget/omap_udc.h
+++ linux.trees.git/drivers/usb/gadget/omap_udc.h
@@ -188,7 +188,7 @@ struct omap_udc {
 #endif
 
 #define ERR(stuff...)		pr_err("udc: " stuff)
-#define WARN(stuff...)		pr_warning("udc: " stuff)
+#define WARNING(stuff...)	pr_warning("udc: " stuff)
 #define INFO(stuff...)		pr_info("udc: " stuff)
 #define DBG(stuff...)		pr_debug("udc: " stuff)
 
Index: linux.trees.git/drivers/usb/host/isp116x-hcd.c
===================================================================
--- linux.trees.git.orig/drivers/usb/host/isp116x-hcd.c
+++ linux.trees.git/drivers/usb/host/isp116x-hcd.c
@@ -882,7 +882,7 @@ static void isp116x_endpoint_disable(str
 	for (i = 0; i < 100 && !list_empty(&hep->urb_list); i++)
 		msleep(3);
 	if (!list_empty(&hep->urb_list))
-		WARN("ep %p not empty?\n", ep);
+		WARNING("ep %p not empty?\n", ep);
 
 	kfree(ep);
 	hep->hcpriv = NULL;
Index: linux.trees.git/drivers/usb/host/isp116x.h
===================================================================
--- linux.trees.git.orig/drivers/usb/host/isp116x.h
+++ linux.trees.git/drivers/usb/host/isp116x.h
@@ -338,7 +338,7 @@ struct isp116x_ep {
 #endif
 
 #define ERR(stuff...)		printk(KERN_ERR "116x: " stuff)
-#define WARN(stuff...)		printk(KERN_WARNING "116x: " stuff)
+#define WARNING(stuff...)	printk(KERN_WARNING "116x: " stuff)
 #define INFO(stuff...)		printk(KERN_INFO "116x: " stuff)
 
 /* ------------------------------------------------- */
Index: linux.trees.git/drivers/usb/host/sl811-hcd.c
===================================================================
--- linux.trees.git.orig/drivers/usb/host/sl811-hcd.c
+++ linux.trees.git/drivers/usb/host/sl811-hcd.c
@@ -1026,7 +1026,7 @@ sl811h_endpoint_disable(struct usb_hcd *
 	if (!list_empty(&hep->urb_list))
 		msleep(3);
 	if (!list_empty(&hep->urb_list))
-		WARN("ep %p not empty?\n", ep);
+		WARNING("ep %p not empty?\n", ep);
 
 	kfree(ep);
 	hep->hcpriv = NULL;
Index: linux.trees.git/drivers/usb/host/sl811.h
===================================================================
--- linux.trees.git.orig/drivers/usb/host/sl811.h
+++ linux.trees.git/drivers/usb/host/sl811.h
@@ -261,6 +261,6 @@ sl811_read_buf(struct sl811 *sl811, int 
 #endif
 
 #define ERR(stuff...)		printk(KERN_ERR "sl811: " stuff)
-#define WARN(stuff...)		printk(KERN_WARNING "sl811: " stuff)
+#define WARNING(stuff...)	printk(KERN_WARNING "sl811: " stuff)
 #define INFO(stuff...)		printk(KERN_INFO "sl811: " stuff)
 
Index: linux.trees.git/drivers/usb/misc/usbtest.c
===================================================================
--- linux.trees.git.orig/drivers/usb/misc/usbtest.c
+++ linux.trees.git/drivers/usb/misc/usbtest.c
@@ -81,7 +81,7 @@ static struct usb_device *testdev_to_usb
 
 #define ERROR(tdev, fmt, args...) \
 	dev_err(&(tdev)->intf->dev , fmt , ## args)
-#define WARN(tdev, fmt, args...) \
+#define WARNING(tdev, fmt, args...) \
 	dev_warn(&(tdev)->intf->dev , fmt , ## args)
 
 /*-------------------------------------------------------------------------*/
@@ -1946,7 +1946,7 @@ usbtest_probe (struct usb_interface *int
 
 			status = get_endpoints (dev, intf);
 			if (status < 0) {
-				WARN(dev, "couldn't get endpoints, %d\n",
+				WARNING(dev, "couldn't get endpoints, %d\n",
 						status);
 				return status;
 			}
Index: linux.trees.git/drivers/usb/gadget/printer.c
===================================================================
--- linux.trees.git.orig/drivers/usb/gadget/printer.c
+++ linux.trees.git/drivers/usb/gadget/printer.c
@@ -179,7 +179,7 @@ module_param(qlen, uint, S_IRUGO|S_IWUSR
 
 #define ERROR(dev, fmt, args...) \
 	xprintk(dev, KERN_ERR, fmt, ## args)
-#define WARN(dev, fmt, args...) \
+#define WARNING(dev, fmt, args...) \
 	xprintk(dev, KERN_WARNING, fmt, ## args)
 #define INFO(dev, fmt, args...) \
 	xprintk(dev, KERN_INFO, fmt, ## args)
Index: linux.trees.git/drivers/usb/gadget/pxa25x_udc.c
===================================================================
--- linux.trees.git.orig/drivers/usb/gadget/pxa25x_udc.c
+++ linux.trees.git/drivers/usb/gadget/pxa25x_udc.c
@@ -340,7 +340,7 @@ pxa25x_ep_free_request (struct usb_ep *_
 	struct pxa25x_request	*req;
 
 	req = container_of (_req, struct pxa25x_request, req);
-	WARN_ON (!list_empty (&req->queue));
+	WARN_ON(!list_empty (&req->queue));
 	kfree(req);
 }
 
@@ -1554,7 +1554,7 @@ config_change:
 					 * tell us about config change events,
 					 * so later ones may fail...
 					 */
-					WARN("config change %02x fail %d?\n",
+					WARNING("config change %02x fail %d?\n",
 						u.r.bRequest, i);
 					return;
 					/* TODO experiment:  if has_cfr,
@@ -2328,7 +2328,7 @@ static int pxa25x_udc_suspend(struct pla
 	unsigned long flags;
 
 	if (!udc->mach->gpio_pullup && !udc->mach->udc_command)
-		WARN("USB host won't detect disconnect!\n");
+		WARNING("USB host won't detect disconnect!\n");
 	udc->suspended = 1;
 
 	local_irq_save(flags);
Index: linux.trees.git/drivers/usb/gadget/cdc2.c
===================================================================
--- linux.trees.git.orig/drivers/usb/gadget/cdc2.c
+++ linux.trees.git/drivers/usb/gadget/cdc2.c
@@ -170,7 +170,7 @@ static int __init cdc_bind(struct usb_co
 		 * but if the controller isn't recognized at all then
 		 * that assumption is a bit more likely to be wrong.
 		 */
-		WARN(cdev, "controller '%s' not recognized; trying %s\n",
+		WARNING(cdev, "controller '%s' not recognized; trying %s\n",
 				gadget->name,
 				cdc_config_driver.label);
 		device_desc.bcdDevice =
Index: linux.trees.git/drivers/usb/gadget/u_ether.c
===================================================================
--- linux.trees.git.orig/drivers/usb/gadget/u_ether.c
+++ linux.trees.git/drivers/usb/gadget/u_ether.c
@@ -116,7 +116,6 @@ static inline int qlen(struct usb_gadget
 #undef DBG
 #undef VDBG
 #undef ERROR
-#undef WARN
 #undef INFO
 
 #define xprintk(d, level, fmt, args...) \
@@ -140,8 +139,6 @@ static inline int qlen(struct usb_gadget
 
 #define ERROR(dev, fmt, args...) \
 	xprintk(dev , KERN_ERR , fmt , ## args)
-#define WARN(dev, fmt, args...) \
-	xprintk(dev , KERN_WARNING , fmt , ## args)
 #define INFO(dev, fmt, args...) \
 	xprintk(dev , KERN_INFO , fmt , ## args)
 
Index: linux.trees.git/drivers/usb/gadget/at91_udc.h
===================================================================
--- linux.trees.git.orig/drivers/usb/gadget/at91_udc.h
+++ linux.trees.git/drivers/usb/gadget/at91_udc.h
@@ -171,7 +171,7 @@ struct at91_request {
 #endif
 
 #define ERR(stuff...)		pr_err("udc: " stuff)
-#define WARN(stuff...)		pr_warning("udc: " stuff)
+#define WARNING(stuff...)	pr_warning("udc: " stuff)
 #define INFO(stuff...)		pr_info("udc: " stuff)
 #define DBG(stuff...)		pr_debug("udc: " stuff)
 
Index: linux.trees.git/drivers/usb/gadget/pxa25x_udc.h
===================================================================
--- linux.trees.git.orig/drivers/usb/gadget/pxa25x_udc.h
+++ linux.trees.git/drivers/usb/gadget/pxa25x_udc.h
@@ -259,7 +259,7 @@ dump_state(struct pxa25x_udc *dev)
 #define DBG(lvl, stuff...) do{if ((lvl) <= UDC_DEBUG) DMSG(stuff);}while(0)
 
 #define ERR(stuff...)		pr_err("udc: " stuff)
-#define WARN(stuff...)		pr_warning("udc: " stuff)
+#define WARNING(stuff...)	pr_warning("udc: " stuff)
 #define INFO(stuff...)		pr_info("udc: " stuff)
 
 
Index: linux.trees.git/include/linux/usb/composite.h
===================================================================
--- linux.trees.git.orig/include/linux/usb/composite.h
+++ linux.trees.git/include/linux/usb/composite.h
@@ -330,7 +330,7 @@ extern int usb_string_id(struct usb_comp
 	dev_vdbg(&(d)->gadget->dev , fmt , ## args)
 #define ERROR(d, fmt, args...) \
 	dev_err(&(d)->gadget->dev , fmt , ## args)
-#define WARN(d, fmt, args...) \
+#define WARNING(d, fmt, args...) \
 	dev_warn(&(d)->gadget->dev , fmt , ## args)
 #define INFO(d, fmt, args...) \
 	dev_info(&(d)->gadget->dev , fmt , ## args)
Index: linux.trees.git/usr/share/quilt/refresh
===================================================================
--- linux.trees.git.orig/usr/share/quilt/refresh
+++ /dev/null
@@ -1,304 +0,0 @@
-#! /bin/bash
-
-#  This script is free software; you can redistribute it and/or modify
-#  it under the terms of the GNU General Public License version 2 as
-#  published by the Free Software Foundation.
-#
-#  See the COPYING and AUTHORS files for more details.
-
-# Read in library functions
-if [ "$(type -t patch_file_name)" != function ]
-then
-	if ! [ -r $QUILT_DIR/scripts/patchfns ]
-	then
-		echo "Cannot read library $QUILT_DIR/scripts/patchfns" >&2
-		exit 1
-	fi
-	. $QUILT_DIR/scripts/patchfns
-fi
-
-usage()
-{
-	printf $"Usage: quilt refresh [-p n|-p ab] [-u|-U num|-c|-C num] [-f] [--no-timestamps] [--no-index] [--diffstat] [--sort] [--backup] [--strip-trailing-whitespace] [patch]\n"
-
-	if [ x$1 = x-h ]
-	then
-		printf $"
-Refreshes the specified patch, or the topmost patch by default.
-Documentation that comes before the actual patch in the patch file is
-retained.
-
-It is possible to refresh patches that are not on top.  If any patches
-on top of the patch to refresh modify the same files, the script aborts
-by default.  Patches can still be refreshed with -f.  In that case this
-script will print a warning for each shadowed file, changes by more
-recent patches will be ignored, and only changes in files that have not
-been modified by any more recent patches will end up in the specified
-patch.
-
--p n	Create a -p n style patch (-p0 or -p1 supported).
-
--p ab	Create a -p1 style patch, but use a/file and b/file as the
-	original and new filenames instead of the default
-	dir.orig/file and dir/file names.
-
--u, -U num, -c, -C num
-	Create a unified diff (-u, -U) with num lines of context. Create
-	a context diff (-c, -C) with num lines of context. The number of
-	context lines defaults to 3.
-
---no-timestamps
-	Do not include file timestamps in patch headers.
-
---no-index
-	Do not output Index: lines.
-
---diffstat
-	Add a diffstat section to the patch header, or replace the
-	existing diffstat section.
-
--f	Enforce refreshing of a patch that is not on top.
-
---backup
-	Create a backup copy of the old version of a patch as patch~.
-
---sort	Sort files by their name instead of preserving the original order.
-
---strip-trailing-whitespace
-	Strip trailing whitespace at the end of lines.
-"
-		exit 0
-	else
-		exit 1
-	fi
-}
-
-die()
-{
-	local status=$1
-	[ -n "$tmp_patch" ] && rm -f $tmp_patch
-	[ -n "$tmp_header" ] && rm -f $tmp_header
-	[ -n "$tmp_result" ] && rm -f $tmp_result
-	exit $status
-}
-
-options=`getopt -o p:uU:cC:fh --long no-timestamps,diffstat,backup,sort \
-			      --long no-index \
-			      --long strip-trailing-whitespace -- "$@"`
-
-if [ $? -ne 0 ]
-then
-	usage
-fi
-
-eval set -- "$options"
-
-opt_format=-u
-while true
-do
-	case "$1" in
-	-p)
-		opt_strip_level=$2
-		shift 2 ;;
-	-f)
-		opt_force=1
-		shift ;;
-	-u|-c)
-		opt_format=$1
-		shift ;;
-	-U|-C)
-		opt_format="$1 $2"
-		shift 2 ;;
-	-h)
-		usage -h ;;
-	--no-timestamps)
-		QUILT_NO_DIFF_TIMESTAMPS=1
-		shift ;;
-	--no-index)
-		QUILT_NO_DIFF_INDEX=1
-		shift ;;
-	--diffstat)
-		opt_diffstat=1
-		shift ;;
-	--backup)
-		QUILT_BACKUP=1
-		shift ;;
-	--sort)
-		opt_sort=1
-		shift ;;
-	--strip-trailing-whitespace)
-		opt_strip_whitespace=1
-		shift ;;
-	--)
-		shift
-		break ;;
-	esac
-done
-
-if [ $# -gt 1 ]
-then
-	usage
-fi
-
-QUILT_DIFF_OPTS="$QUILT_DIFF_OPTS $opt_format"
-
-patch=$(find_applied_patch "$1") || exit 1
-
-if [ -z "$opt_strip_level" ]
-then
-	opt_strip_level=$(patch_strip_level $patch)
-fi
-case "$opt_strip_level" in
-0 | 1)
-	num_strip_level=$opt_strip_level
-	;;
-ab)
-	num_strip_level=1
-	;;
-*)
-	printf $"Cannot refresh patches with -p%s, please specify -p0 or -p1 instead\n" "$opt_strip_level\n" >&2
-	exit 1
-	;;
-esac
-
-trap "die 1" SIGTERM
-
-tmp_patch=$(gen_tempfile)
-
-if [ -z "$opt_sort" ]
-then
-	files=( $(files_in_patch_ordered $patch) )
-else
-	files=( $(files_in_patch $patch | sort) )
-fi
-
-for file in "${files[@]}"
-do
-	old_file=$(backup_file_name $patch $file)
-	next_patch=$(next_patch_for_file $patch $file)
-	if [ -z "$next_patch" ]
-	then
-		new_file=$file
-	else
-		new_file=$(backup_file_name $next_patch $file)
-		files_were_shadowed=1
-	fi
-	if ! diff_file $file $old_file $new_file >> $tmp_patch
-	then
-		printf $"Diff failed, aborting\n" >&2
-		die 1
-	fi
-
-	if [ -n "$files_were_shadowed" -a -z "$opt_force" ]
-	then
-		printf $"More recent patches modify files in patch %s. Enforce refresh with -f.\n" "$(print_patch $patch)" >&2
-		die 1
-	fi
-
-	if [ -n "$files_were_shadowed" -a -n "$opt_strip_whitespace" ]
-	then
-		printf $"Cannot use --strip-trailing-whitespace on a patch that has shadowed files.\n" >&2
-	fi
-done
-
-if ! [ -s $tmp_patch ]
-then
-	printf $"Nothing in patch %s\n" "$(print_patch $patch)" >&2
-	die 1
-fi
-
-# Check for trailing whitespace
-if [ -z "$opt_strip_whitespace" ]
-then
-	$QUILT_DIR/scripts/remove-trailing-ws -n -p$num_strip_level \
-	< $tmp_patch
-else
-	tmp_patch2=$(gen_tempfile)
-	if $QUILT_DIR/scripts/remove-trailing-ws -p$num_strip_level \
-				       < $tmp_patch > $tmp_patch2
-	then
-		rm -f $tmp_patch
-		tmp_patch=$tmp_patch2
-	fi
-fi
-# FIXME: no stripping of non-topmost patch !!!
-
-patch_file=$(patch_file_name $patch)
-
-trap "" SIGINT
-
-if ! tmp_header=$(gen_tempfile)
-then
-	die 1
-fi
-
-mkdir -p $(dirname $patch_file)
-
-if ! cat_file $patch_file | patch_header > $tmp_header
-then
-	die 1
-fi
-
-tmp_result=$(gen_tempfile) || die 1
-
-if [ -n "$opt_diffstat" ]
-then
-	diffstat="$(diffstat $QUILT_DIFFSTAT_OPTS \
-			     -p$num_strip_level $tmp_patch)" || die 1
-	awk '
-	    function print_diffstat(arr, i) {
-	      split(diffstat, arr, "\n")
-	      for (i=1; i in arr; i++)
-		print prefix arr[i]
-	    }
-			{ prefix=""
-			  if (index($0, "#") == 1)
-			    prefix="#"
-			}
-	    /^#? .* \|  *[1-9][0-9]* /	{ eat = eat $0 "\n"
-			  next }
-	    /^#? .* files? changed(, .* insertions?\(\+\))?(, .* deletions?\(-\))?/ \
-			{ print_diffstat()
-			  diffstat = "" ; eat = ""
-			  next }
-			{ print eat $0
-			  eat = "" }
-	    END		{ printf "%s", eat
-	    		  if (diffstat != "") {
-			    print "---"
-			    print_diffstat()
-			    print prefix
-			  }
-			}
-	    ' diffstat="$diffstat" \
-	    $tmp_header > $tmp_result
-else
-	cat $tmp_header > $tmp_result
-fi
-
-cat $tmp_patch >> $tmp_result
-
-if [ -e $patch_file ] && \
-   diff -q $patch_file $tmp_result > /dev/null
-then
-	printf $"Patch %s is unchanged\n" "$(print_patch $patch)"
-elif ( [ -z "$QUILT_BACKUP" -o ! -e $patch_file ] || \
-       mv $patch_file $patch_file~ ) && \
-     cat_to_new_file $patch_file < $tmp_result
-then
-	touch $QUILT_PC/$patch/.timestamp
-	printf $"Refreshed patch %s\n" "$(print_patch $patch)"
-else
-	die 1
-fi
-
-rm -f $QUILT_PC/$patch~refresh
-if ! change_db_strip_level -p$num_strip_level $patch
-then
-	die 1
-fi
-die 0
-### Local Variables:
-### mode: shell-script
-### End:
-# vim:filetype=sh

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbYGOP0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbYGOP0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbYGOPY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:24:59 -0400
Received: from multi.imgtec.com ([194.200.65.239]:63831 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbYGOPY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:24:56 -0400
From: Will Newton <will.newton@imgtec.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, leoli@freescale.com, tanya.jiang@freescale.com,
       gregkh@suse.de, Will Newton <will.newton@gmail.com>
Subject: [PATCH 04/11] fsl_usb2_udc: Clean up whitespace in errors and warnings.
Date: Tue, 15 Jul 2008 16:24:43 +0100
Message-Id: <1216135490-21656-5-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1216135490-21656-4-git-send-email-will.newton@imgtec.com>
References: <1216135490-21656-1-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-2-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-3-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-4-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 15 Jul 2008 15:24:52.0980 (UTC) FILETIME=[EDD28340:01C8E68E]
X-SEF-Processed: 6_0_1_111__2008_07_15_16_24_54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

VDBG always outputs a trailing \n.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 7b898a5..18f4881 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.c
+++ b/drivers/usb/gadget/fsl_usb2_udc.c
@@ -193,7 +193,7 @@ static int dr_controller_setup(struct fsl_udc *udc)
 	timeout = jiffies + FSL_UDC_RESET_TIMEOUT;
 	while (fsl_readl(&dr_regs->usbcmd) & USB_CMD_CTRL_RESET) {
 		if (time_after(jiffies, timeout)) {
-			ERR("udc reset timeout! \n");
+			ERR("udc reset timeout!\n");
 			return -ETIMEDOUT;
 		}
 		cpu_relax();
@@ -702,7 +702,7 @@ static struct ep_td_struct *fsl_build_dtd(struct fsl_req *req, unsigned *length,
 		*is_last = 0;
 
 	if ((*is_last) == 0)
-		VDBG("multi-dtd request!\n");
+		VDBG("multi-dtd request!");
 	/* Fill in the transfer size; set active bit */
 	swap_temp = ((*length << DTD_LENGTH_BIT_POS) | DTD_STATUS_ACTIVE);
 
@@ -765,11 +765,11 @@ fsl_ep_queue(struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
 	/* catch various bogus parameters */
 	if (!_req || !req->req.complete || !req->req.buf
 			|| !list_empty(&req->queue)) {
-		VDBG("%s, bad params\n", __func__);
+		VDBG("%s, bad params", __func__);
 		return -EINVAL;
 	}
 	if (unlikely(!_ep || !ep->desc)) {
-		VDBG("%s, bad ep\n", __func__);
+		VDBG("%s, bad ep", __func__);
 		return -EINVAL;
 	}
 	if (ep->desc->bmAttributes == USB_ENDPOINT_XFER_ISOC) {
@@ -1061,7 +1061,7 @@ static int fsl_vbus_session(struct usb_gadget *gadget, int is_active)
 
 	udc = container_of(gadget, struct fsl_udc, gadget);
 	spin_lock_irqsave(&udc->lock, flags);
-	VDBG("VBUS %s\n", is_active ? "on" : "off");
+	VDBG("VBUS %s", is_active ? "on" : "off");
 	udc->vbus_active = (is_active != 0);
 	if (can_pullup(udc))
 		fsl_writel((fsl_readl(&dr_regs->usbcmd) | USB_CMD_RUN_STOP),
@@ -1161,7 +1161,7 @@ static int ep0_prime_status(struct fsl_udc *udc, int direction)
 		return -ENOMEM;
 
 	if (status)
-		ERR("Can't queue ep0 status request \n");
+		ERR("Can't queue ep0 status request\n");
 	list_add_tail(&req->queue, &ep->queue);
 
 	return status;
@@ -1247,7 +1247,7 @@ static void ch9getstatus(struct fsl_udc *udc, u8 request_type, u16 value,
 		goto stall;
 
 	if (status) {
-		ERR("Can't respond to getstatus request \n");
+		ERR("Can't respond to getstatus request\n");
 		goto stall;
 	}
 	list_add_tail(&req->queue, &ep->queue);
@@ -1389,7 +1389,7 @@ static void ep0_req_complete(struct fsl_udc *udc, struct fsl_ep *ep0,
 		udc->ep0_state = WAIT_FOR_SETUP;
 		break;
 	case WAIT_FOR_SETUP:
-		ERR("Unexpect ep0 packets \n");
+		ERR("Unexpect ep0 packets\n");
 		break;
 	default:
 		ep0stall(udc);
@@ -1468,7 +1468,7 @@ static int process_ep_req(struct fsl_udc *udc, int pipe,
 				status = -EILSEQ;
 				break;
 			} else
-				ERR("Unknown error has occured (0x%x)!\r\n",
+				ERR("Unknown error has occured (0x%x)!\n",
 					errors);
 
 		} else if (le32_to_cpu(curr_td->size_ioc_sts)
@@ -1487,7 +1487,7 @@ static int process_ep_req(struct fsl_udc *udc, int pipe,
 			}
 		} else {
 			td_complete++;
-			VDBG("dTD transmitted successful ");
+			VDBG("dTD transmitted successful");
 		}
 
 		if (j != curr_req->dtd_count - 1)
@@ -1755,7 +1755,7 @@ static irqreturn_t fsl_udc_irq(int irq, void *_udc)
 	}
 
 	if (irq_src & (USB_STS_ERR | USB_STS_SYS_ERR)) {
-		VDBG("Error IRQ %x ", irq_src);
+		VDBG("Error IRQ %x", irq_src);
 	}
 
 	spin_unlock_irqrestore(&udc->lock, flags);
@@ -1806,12 +1806,12 @@ int usb_gadget_register_driver(struct usb_gadget_driver *driver)
 	udc_controller->usb_state = USB_STATE_ATTACHED;
 	udc_controller->ep0_state = WAIT_FOR_SETUP;
 	udc_controller->ep0_dir = 0;
-	printk(KERN_INFO "%s: bind to driver %s \n",
+	printk(KERN_INFO "%s: bind to driver %s\n",
 			udc_controller->gadget.name, driver->driver.name);
 
 out:
 	if (retval)
-		printk("retval %d \n", retval);
+		printk("gadget driver register failed %d\n", retval);
 	return retval;
 }
 EXPORT_SYMBOL(usb_gadget_register_driver);
@@ -1853,7 +1853,7 @@ int usb_gadget_unregister_driver(struct usb_gadget_driver *driver)
 	udc_controller->gadget.dev.driver = NULL;
 	udc_controller->driver = NULL;
 
-	printk("unregistered gadget driver '%s'\r\n", driver->driver.name);
+	printk("unregistered gadget driver '%s'\n", driver->driver.name);
 	return 0;
 }
 EXPORT_SYMBOL(usb_gadget_unregister_driver);
@@ -2241,7 +2241,7 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 	u32 dccparams;
 
 	if (strcmp(pdev->name, driver_name)) {
-		VDBG("Wrong device\n");
+		VDBG("Wrong device");
 		return -ENODEV;
 	}
 
@@ -2259,7 +2259,7 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 
 	if (!request_mem_region(res->start, res->end - res->start + 1,
 				driver_name)) {
-		ERR("request mem region for %s failed \n", pdev->name);
+		ERR("request mem region for %s failed\n", pdev->name);
 		kfree(udc_controller);
 		return -EBUSY;
 	}
@@ -2293,7 +2293,7 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 	ret = request_irq(udc_controller->irq, fsl_udc_irq, IRQF_SHARED,
 			driver_name, udc_controller);
 	if (ret != 0) {
-		ERR("cannot request irq %d err %d \n",
+		ERR("cannot request irq %d err %d\n",
 				udc_controller->irq, ret);
 		goto err2;
 	}
@@ -2456,7 +2456,7 @@ module_init(udc_init);
 static void __exit udc_exit(void)
 {
 	platform_driver_unregister(&udc_driver);
-	printk("%s unregistered \n", driver_desc);
+	printk("%s unregistered\n", driver_desc);
 }
 
 module_exit(udc_exit);
-- 
1.5.5.2


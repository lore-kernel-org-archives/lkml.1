Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYLGD7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYLGD7N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 22:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYLGD66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 22:58:58 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:33568 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbYLGD6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 22:58:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=EiwRJ7lQn6a1QeWoCJLYGwDz8sHQE2Xl3OU+4avO8nNpL3/XcVo5cQMvP9+Fd1u/vA
         +9Hz3TyuMbwtVpMHiUme6mH7ULTylmagZylmpBpl7dFXNgoAJCadV6wIGvBKC7CtRpPW
         iFHKIvJQBi+ttbHQ2bvbzKIPwNDgiN95CxleA=
Date: Sun, 7 Dec 2008 06:58:47 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: lrodriguez@atheros.com, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: otus: remove dependence on kernel version
Message-ID: <20081207035847.GA21608@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dependence on kernel version is not needed anymore
if we are in mainline now.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/otus/ioctl.c    |   22 --------------
 drivers/staging/otus/usbdrv.c   |   61 ---------------------------------------
 drivers/staging/otus/usbdrv.h   |    9 +----
 drivers/staging/otus/wrap_pkt.c |    4 --
 drivers/staging/otus/wrap_usb.c |    4 --
 drivers/staging/otus/wwrap.c    |   57 ------------------------------------
 drivers/staging/otus/zdcompat.h |   54 ----------------------------------
 drivers/staging/otus/zdusb.c    |   56 -----------------------------------
 8 files changed, 2 insertions(+), 265 deletions(-)

diff --git a/drivers/staging/otus/ioctl.c b/drivers/staging/otus/ioctl.c
index 3bc420a..69e51b6 100644
--- a/drivers/staging/otus/ioctl.c
+++ b/drivers/staging/otus/ioctl.c
@@ -309,9 +309,7 @@ char *usbdrv_translate_scan(struct net_device *dev,
     iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
     memcpy(iwe.u.ap_addr.sa_data, list->bssid, ETH_ALEN);
     current_ev = iwe_stream_add_event(
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
 	info,
-#endif
 	current_ev,
 	end_buf, &iwe, IW_EV_ADDR_LEN);
 
@@ -332,9 +330,7 @@ char *usbdrv_translate_scan(struct net_device *dev,
     iwe.cmd = SIOCGIWESSID;
     iwe.u.data.flags = 1;
     current_ev = iwe_stream_add_point(
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
 	info,
-#endif
 	current_ev, end_buf, &iwe, &list->ssid[2]);
 
     /* Ran out of buffer */
@@ -355,9 +351,7 @@ char *usbdrv_translate_scan(struct net_device *dev,
         else
             iwe.u.mode = IW_MODE_ADHOC;
         current_ev = iwe_stream_add_event(
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
 		info,
-#endif
 		current_ev, end_buf, &iwe, IW_EV_UINT_LEN);
     }
 
@@ -389,9 +383,7 @@ char *usbdrv_translate_scan(struct net_device *dev,
     }
     iwe.u.freq.e = 6;
     current_ev = iwe_stream_add_event(
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
 	info,
-#endif
     	current_ev, end_buf, &iwe, IW_EV_FREQ_LEN);
 
     /* Ran out of buffer */
@@ -412,9 +404,7 @@ char *usbdrv_translate_scan(struct net_device *dev,
     iwe.u.qual.noise = 0;
     iwe.u.qual.qual = list->signalQuality;
     current_ev = iwe_stream_add_event(
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
 	info,
-#endif
 	current_ev, end_buf, &iwe, IW_EV_QUAL_LEN);
 
     /* Ran out of buffer */
@@ -435,9 +425,7 @@ char *usbdrv_translate_scan(struct net_device *dev,
 
     iwe.u.data.length = 0;
     current_ev = iwe_stream_add_point(
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
 	info,
-#endif
 	current_ev, end_buf, &iwe, list->ssid);
 
     /* Ran out of buffer */
@@ -462,9 +450,7 @@ char *usbdrv_translate_scan(struct net_device *dev,
         iwe.u.bitrate.value = ((list->supportedRates[i+2] & 0x7f) * 500000);
 /* Add new value to event */
         current_val = iwe_stream_add_value(
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
 		info,
-#endif
 		current_ev, current_val, end_buf, &iwe, IW_EV_PARAM_LEN);
 
         /* Ran out of buffer */
@@ -482,9 +468,7 @@ char *usbdrv_translate_scan(struct net_device *dev,
         iwe.u.bitrate.value = ((list->extSupportedRates[i+2] & 0x7f) * 500000);
 /* Add new value to event */
         current_val = iwe_stream_add_value(
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
 		info,
-#endif
 		current_ev, current_val, end_buf, &iwe, IW_EV_PARAM_LEN);
 
         /* Ran out of buffer */
@@ -506,9 +490,7 @@ char *usbdrv_translate_scan(struct net_device *dev,
     snprintf(buf, sizeof(buf), "bcn_int=%d", (list->beaconInterval[1] << 8) + list->beaconInterval[0]);
     iwe.u.data.length = strlen(buf);
     current_ev = iwe_stream_add_point(
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
 		info,
-#endif
 		current_ev, end_buf, &iwe, buf);
 
     /* Ran out of buffer */
@@ -537,9 +519,7 @@ char *usbdrv_translate_scan(struct net_device *dev,
 
         if (iwe.u.data.length != 0)
             current_ev = iwe_stream_add_point(
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
 		info,
-#endif
 		current_ev, end_buf, &iwe, buf);
 
         /* Ran out of buffer */
@@ -563,9 +543,7 @@ char *usbdrv_translate_scan(struct net_device *dev,
                 rsn_leader, sizeof(rsn_leader)-1);
             if (iwe.u.data.length != 0)
                 current_ev = iwe_stream_add_point(
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
 			info,
-#endif
 			current_ev, end_buf,  &iwe, buf);
 
             /* Ran out of buffer */
diff --git a/drivers/staging/otus/usbdrv.c b/drivers/staging/otus/usbdrv.c
index a0dd605..817228d 100644
--- a/drivers/staging/otus/usbdrv.c
+++ b/drivers/staging/otus/usbdrv.c
@@ -51,11 +51,7 @@ extern void zfDumpDescriptor(zdev_t* dev, u16_t type);
 //extern void zfiWlanQueryMacAddress(zdev_t* dev, u8_t* addr);
 
 // ISR handler
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,0))
 irqreturn_t usbdrv_intr(int, void *, struct pt_regs *);
-#else
-void usbdrv_intr(int, void *, struct pt_regs *);
-#endif
 
 // Network Device interface related function
 int usbdrv_open(struct net_device *);
@@ -316,11 +312,7 @@ void zfLnxInitVapStruct(void);
  * the RX & TX queues & starts the RU if it has stopped due
  * to no resources.
  */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))
 irqreturn_t usbdrv_intr(int irq, void *dev_inst, struct pt_regs *regs)
-#else
-void usbdrv_intr(int irq, void *dev_inst, struct pt_regs *regs)
-#endif
 {
     struct net_device *dev;
     struct usbdrv_private *macp;
@@ -331,38 +323,22 @@ void usbdrv_intr(int irq, void *dev_inst, struct pt_regs *regs)
 
     /* Read register error, card may be unpluged */
     if (0)//(intr_status == -1)
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))
         return IRQ_NONE;
-#else
-        return;
-#endif
 
     /* the device is closed, don't continue or else bad things may happen. */
     if (!netif_running(dev)) {
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))
         return IRQ_NONE;
-#else
-        return;
-#endif
     }
 
     if (macp->driver_isolated) {
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))
         return IRQ_NONE;
-#else
-        return;
-#endif
     }
 
 #if (WLAN_HOSTIF == WLAN_PCI)
     //zfiIsrPci(dev);
 #endif
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))
     return IRQ_HANDLED;
-#else
-    return;
-#endif
 }
 
 int usbdrv_open(struct net_device *dev)
@@ -477,11 +453,7 @@ int usbdrv_open(struct net_device *dev)
     zfiWlanEnable(dev);
 
 #ifdef ZM_ENABLE_CENC
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14)
-    macp->netlink_sk = netlink_kernel_create(NETLINK_USERSOCK, NULL);
-#else
     macp->netlink_sk = netlink_kernel_create(NETLINK_USERSOCK, 1, NULL, THIS_MODULE);
-#endif
 
     if (macp->netlink_sk == NULL)
     {
@@ -884,11 +856,7 @@ int zfLnxRegisterVapDev(struct net_device* parentDev, u16_t vapId)
 #else
     vap[vapId].dev->do_ioctl = NULL;
 #endif
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))
     vap[vapId].dev->destructor = free_netdev;
-#else
-    vap[vapId].dev->features |= NETIF_F_DYNALLOC;
-#endif
 
     vap[vapId].dev->tx_queue_len = 0;
 
@@ -939,13 +907,8 @@ int zfLnxUnregisterVapDev(struct net_device* parentDev, u16_t vapId)
 
 
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0) /* tune me! */
 #  define SUBMIT_URB(u,f)       usb_submit_urb(u,f)
 #  define USB_ALLOC_URB(u,f)    usb_alloc_urb(u,f)
-#else
-#  define SUBMIT_URB(u,f)       usb_submit_urb(u)
-#  define USB_ALLOC_URB(u,f)    usb_alloc_urb(u)
-#endif
 
 //extern void zfiWlanQueryMacAddress(zdev_t* dev, u8_t* addr);
 
@@ -963,26 +926,16 @@ extern UsbTxQ_t *zfLnxGetUsbTxBuffer(struct net_device *dev);
 int zfLnxAllocAllUrbs(struct usbdrv_private *macp)
 {
     struct usb_interface *interface = macp->interface;
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-    struct usb_interface_descriptor *iface_desc = &interface->altsetting[0];
-#else
     struct usb_host_interface *iface_desc = &interface->altsetting[0];
-#endif
 
     struct usb_endpoint_descriptor *endpoint;
     int i;
 
     /* descriptor matches, let's find the endpoints needed */
     /* check out the endpoints */
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-    for (i = 0; i < iface_desc->bNumEndpoints; ++i)
-    {
-        endpoint = &iface_desc->endpoint[i];
-#else
     for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i)
     {
         endpoint = &iface_desc->endpoint[i].desc;
-#endif
         if ((endpoint->bEndpointAddress & 0x80) &&
             ((endpoint->bmAttributes & 3) == 0x02))
         {
@@ -1100,9 +1053,6 @@ void zfLnxUnlinkAllUrbs(struct usbdrv_private *macp)
     {
         if (macp->WlanTxDataUrb[i] != NULL)
         {
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,15)
-            macp->WlanTxDataUrb[i]->transfer_flags &= ~URB_ASYNC_UNLINK;
-#endif
             usb_unlink_urb(macp->WlanTxDataUrb[i]);
         }
     }
@@ -1112,22 +1062,13 @@ void zfLnxUnlinkAllUrbs(struct usbdrv_private *macp)
     {
         if (macp->WlanRxDataUrb[i] != NULL)
         {
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,15)
-            macp->WlanRxDataUrb[i]->transfer_flags &= ~URB_ASYNC_UNLINK;
-#endif
             usb_unlink_urb(macp->WlanRxDataUrb[i]);
         }
     }
 
     /* Unlink USB Register Read/Write URB */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,15)
-    macp->RegOutUrb->transfer_flags &= ~URB_ASYNC_UNLINK;
-#endif
     usb_unlink_urb(macp->RegOutUrb);
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,15)
-    macp->RegInUrb->transfer_flags &= ~URB_ASYNC_UNLINK;
-#endif
     usb_unlink_urb(macp->RegInUrb);
 }
 
@@ -1166,14 +1107,12 @@ u8_t zfLnxInitSetup(struct net_device *dev, struct usbdrv_private *macp)
 
     dev->flags |= IFF_MULTICAST;
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24))
     dev->dev_addr[0] = 0x00;
     dev->dev_addr[1] = 0x03;
     dev->dev_addr[2] = 0x7f;
     dev->dev_addr[3] = 0x11;
     dev->dev_addr[4] = 0x22;
     dev->dev_addr[5] = 0x33;
-#endif
 
     /* Initialize Heart Beat timer */
     init_timer(&macp->hbTimer10ms);
diff --git a/drivers/staging/otus/usbdrv.h b/drivers/staging/otus/usbdrv.h
index 6e41881..a11b3b3 100644
--- a/drivers/staging/otus/usbdrv.h
+++ b/drivers/staging/otus/usbdrv.h
@@ -35,15 +35,10 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
-#include <linux/version.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/wireless.h>
 #include <linux/if_arp.h>
-#include <asm/io.h>
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-    #include <asm/div64.h>
-#endif
+#include <linux/io.h>
 
 #include "zdcompat.h"
 
diff --git a/drivers/staging/otus/wrap_pkt.c b/drivers/staging/otus/wrap_pkt.c
index f2dda4b..bd3481b 100644
--- a/drivers/staging/otus/wrap_pkt.c
+++ b/drivers/staging/otus/wrap_pkt.c
@@ -65,11 +65,7 @@ void zfLnxRecv80211(zdev_t* dev, zbuf_t* buf, struct zsAdditionInfo* addInfo)
                 if(skb1 != NULL)
                 {
                     skb1->dev = dev;
-                #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22))
-	            skb1->mac.raw = skb1->data;
-                #else
                     skb1->mac_header = skb1->data;
-                #endif
 	            skb1->ip_summed = CHECKSUM_NONE;
 	            skb1->pkt_type = PACKET_OTHERHOST;
 	            skb1->protocol = __constant_htons(0x0019);  /* ETH_P_80211_RAW */
diff --git a/drivers/staging/otus/wrap_usb.c b/drivers/staging/otus/wrap_usb.c
index 93c0ece..64d6d1c 100644
--- a/drivers/staging/otus/wrap_usb.c
+++ b/drivers/staging/otus/wrap_usb.c
@@ -144,11 +144,7 @@ void zfwUsbCmd(zdev_t* dev, u8_t endpt, u32_t* cmd, u16_t cmdLen)
     if (ret != 0)
     {
         usb_free_urb(macp->RegOutUrb);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0) /* tune me! */
         macp->RegOutUrb = usb_alloc_urb(0, GFP_ATOMIC);
-#else
-        macp->RegOutUrb = usb_alloc_urb(0);
-#endif
         ret = zfLnxUsbWriteReg(dev, cmd, cmdLen);
     }
 }
diff --git a/drivers/staging/otus/wwrap.c b/drivers/staging/otus/wwrap.c
index 5c3da2b..57f8880 100644
--- a/drivers/staging/otus/wwrap.c
+++ b/drivers/staging/otus/wwrap.c
@@ -31,10 +31,6 @@
 #include <net/iw_handler.h>
 #endif
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-#define URB_ZERO_PACKET USB_ZERO_PACKET
-#endif
-
 extern void zfiRecv80211(zdev_t* dev, zbuf_t* buf, struct zsAdditionInfo* addInfo);
 extern void zfCoreRecv(zdev_t* dev, zbuf_t* buf, struct zsAdditionInfo* addInfo);
 extern void zfIdlChkRsp(zdev_t* dev, u32_t* rsp, u16_t rspLen);
@@ -310,10 +306,6 @@ void zfLnxUsbDataIn_callback(urb_t *urb)
         if ((urb->status != -ENOENT) && (urb->status != -ECONNRESET)
             && (urb->status != -ESHUTDOWN))
         {
-            #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-                if (urb->status == USB_ST_INTERNALERROR)
-                    status = -1;
-            #else
                 if (urb->status == -EPIPE){
                     //printk(KERN_ERR "nonzero read bulk status received: -EPIPE");
                     status = -1;
@@ -323,7 +315,6 @@ void zfLnxUsbDataIn_callback(urb_t *urb)
                     //printk(KERN_ERR "nonzero read bulk status received: -EPROTO");
                     status = -1;
                 }
-            #endif
         }
 
         //printk(KERN_ERR "urb->status: 0x%08x\n", urb->status);
@@ -538,10 +529,6 @@ void zfLnxUsbRegIn_callback(urb_t *urb)
         if ((urb->status != -ENOENT) && (urb->status != -ECONNRESET)
             && (urb->status != -ESHUTDOWN))
         {
-            #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-                if (urb->status == USB_ST_INTERNALERROR)
-                    status = -1;
-            #else
                 if (urb->status == -EPIPE){
                     //printk(KERN_ERR "nonzero read bulk status received: -EPIPE");
                     status = -1;
@@ -551,7 +538,6 @@ void zfLnxUsbRegIn_callback(urb_t *urb)
                     //printk(KERN_ERR "nonzero read bulk status received: -EPROTO");
                     status = -1;
                 }
-            #endif
         }
 
         //printk(KERN_ERR "urb->status: 0x%08x\n", urb->status);
@@ -810,15 +796,9 @@ u32_t zfLnxUsbWriteReg(zdev_t* dev, u32_t* cmd, u16_t cmdLen)
 
     /* Issue an USB Out transfer */
     /* Submit a tx urb */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24)
-    ret = zfLnxUsbSubmitBulkUrb(macp->RegOutUrb, macp->udev,
-            USB_REG_OUT_PIPE, USB_DIR_OUT, macp->regUsbWriteBuf,
-            cmdLen, zfLnxUsbRegOut_callback, dev);
-#else
     ret = zfLnxUsbSubmitIntUrb(macp->RegOutUrb, macp->udev,
             USB_REG_OUT_PIPE, USB_DIR_OUT, macp->regUsbWriteBuf,
             cmdLen, zfLnxUsbRegOut_callback, dev, 1);
-#endif
 
     return ret;
 }
@@ -914,10 +894,6 @@ u32_t zfLnxUsbSubmitBulkUrb(urb_t *urb, struct usb_device *usb, u16_t epnum, u16
                 transfer_buffer, buffer_length, complete, context);
     }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,15)
-    urb->transfer_flags |= URB_ASYNC_UNLINK;
-#endif
-
     if (epnum == 4)
     {
         if (urb->hcpriv)
@@ -927,11 +903,7 @@ u32_t zfLnxUsbSubmitBulkUrb(urb_t *urb, struct usb_device *usb, u16_t epnum, u16
         }
     }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
     ret = usb_submit_urb(urb, GFP_ATOMIC);
-#else
-    ret = usb_submit_urb(urb);
-#endif
     if ((epnum == 4) & (ret != 0))
     {
         //printk("CWY - ret = %x\n", ret);
@@ -956,15 +928,7 @@ u32_t zfLnxUsbSubmitIntUrb(urb_t *urb, struct usb_device *usb, u16_t epnum, u16_
                 transfer_buffer, buffer_length, complete, context, interval);
     }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,15)
-    urb->transfer_flags |= URB_ASYNC_UNLINK;
-#endif
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
     ret = usb_submit_urb(urb, GFP_ATOMIC);
-#else
-    ret = usb_submit_urb(urb);
-#endif
 
     return ret;
 }
@@ -1001,11 +965,7 @@ int zfLnxCencSendMsg(struct sock *netlink_sk, u_int8_t *msg, int len)
 	memcpy(pos, msg,  len);
 	/*Б∙╙я└п╨п╕Б∙╛Б∙°Б∙╖п╘п╡п╤Б∙╚п╥Б∙╓я┌я└п■Б∙╗п║Б∙ёп╢п╧п╘Б∙╛я┴п╧Б∙ёБ∙╙п╧п│Б∙⌠Б∙╓я┘*/
 	nlh->nlmsg_len = skb->tail - old_tail;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14)
-    NETLINK_CB(skb).dst_groups = COMMTYPE_GROUP;
-#else
 	NETLINK_CB(skb).dst_group = COMMTYPE_GROUP;
-#endif
 	netlink_broadcast(netlink_sk, skb, 0, COMMTYPE_GROUP, GFP_ATOMIC);
 	ret = 0;
 out:
@@ -1043,11 +1003,7 @@ u32_t zfwReadReg(zdev_t* dev, u32_t offset)
 #ifndef INIT_WORK
 #define work_struct tq_struct
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0))
-#define schedule_work(a)   queue_task(a, &tq_scheduler)
-#else
 #define schedule_work(a)  schedule_task(a)
-#endif
 
 #define flush_scheduled_work  flush_scheduled_tasks
 #define INIT_WORK(_wq, _routine, _data)  INIT_TQUEUE(_wq, _routine, _data)
@@ -1058,20 +1014,11 @@ u32_t zfwReadReg(zdev_t* dev, u32_t offset)
 
 u32_t smp_kevent_Lock = 0;
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,20))
 void kevent(struct work_struct *work)
-#else
-void kevent(void *data)
-#endif
 {
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,20))
     struct usbdrv_private *macp =
                container_of(work, struct usbdrv_private, kevent);
     zdev_t *dev = macp->device;
-#else
-    zdev_t *dev = (zdev_t *) data;
-    struct usbdrv_private *macp = (struct usbdrv_private *)dev->priv;
-#endif
 
     if (macp == NULL)
     {
@@ -1120,11 +1067,7 @@ u8_t zfLnxCreateThread(zdev_t *dev)
     struct usbdrv_private *macp = (struct usbdrv_private *)dev->priv;
 
     /* Create Mutex and keventd */
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20))
-    INIT_WORK(&macp->kevent, kevent, dev);
-#else
     INIT_WORK(&macp->kevent, kevent);
-#endif
     init_MUTEX(&macp->ioctl_sem);
 
     return 0;
diff --git a/drivers/staging/otus/zdcompat.h b/drivers/staging/otus/zdcompat.h
index 27c807b..8acf400 100644
--- a/drivers/staging/otus/zdcompat.h
+++ b/drivers/staging/otus/zdcompat.h
@@ -27,58 +27,13 @@
 #ifndef _ZDCOMPAT_H
 #define _ZDCOMPAT_H
 
-#ifndef KERNEL_VERSION
-#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))
-#endif
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-#ifndef INIT_TQUEUE
-#define INIT_TQUEUE(_tq, _routine, _data)                       \
-        do {                                                    \
-                (_tq)->next = NULL;                             \
-                (_tq)->sync = 0;                                \
-                PREPARE_TQUEUE((_tq), (_routine), (_data));     \
-        } while (0)
-#define PREPARE_TQUEUE(_tq, _routine, _data)                    \
-        do {                                                    \
-                (_tq)->routine = _routine;                      \
-                (_tq)->data = _data;                            \
-        } while (0)
-#endif
-
-#ifndef INIT_WORK
-#define work_struct tq_struct
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0))
-#define schedule_work(a)   queue_task(a, &tq_scheduler)
-#else
-#define schedule_work(a)  schedule_task(a)
-#endif
-
-#define flush_scheduled_work  flush_scheduled_tasks
-#define INIT_WORK(_wq, _routine, _data)  INIT_TQUEUE(_wq, _routine, _data)
-#define PREPARE_WORK(_wq, _routine, _data)  PREPARE_TQUEUE(_wq, _routine, _data)
-#endif
-#endif // < 2.5 kernel
-
 
 #ifndef DECLARE_TASKLET
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0))
-#define tasklet_schedule(a)   queue_task(a, &tq_scheduler)
-#else
 #define tasklet_schedule(a)   schedule_task(a)
 #endif
-#endif
 
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,3,38))
-typedef struct device netdevice_t;
-#elif (LINUX_VERSION_CODE < KERNEL_VERSION(2,4,4))
-typedef struct net_device netdevice_t;
-#else
 #undef netdevice_t
 typedef struct net_device netdevice_t;
-#endif
 
 #ifdef WIRELESS_EXT
 #if (WIRELESS_EXT < 13)
@@ -90,7 +45,6 @@ struct iw_request_info
 #endif
 #endif
 
-/* linux < 2.5.69 */
 #ifndef IRQ_NONE
 typedef void irqreturn_t;
 #define IRQ_NONE
@@ -102,15 +56,7 @@ typedef void irqreturn_t;
 #define in_atomic()  0
 #endif
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))  // fixme
-#define URB_ASYNC_UNLINK  USB_ASYNC_UNLINK
-#else
 #define USB_QUEUE_BULK 0
-#endif
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0))
-#define free_netdev(x)       kfree(x)
-#endif
 
 
 #endif
diff --git a/drivers/staging/otus/zdusb.c b/drivers/staging/otus/zdusb.c
index 24831f7..52ec543 100644
--- a/drivers/staging/otus/zdusb.c
+++ b/drivers/staging/otus/zdusb.c
@@ -24,7 +24,6 @@
 /*                                                                      */
 /************************************************************************/
 
-#include <linux/version.h>
 #ifdef MODVERSIONS
 #include <linux/modversions.h>
 #endif
@@ -69,26 +68,17 @@ extern struct zsWdsStruct wds[ZM_WDS_PORT_NUMBER];
 /* VAP */
 extern struct zsVapStruct vap[ZM_VAP_PORT_NUMBER];
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-static void *zfLnxProbe(struct usb_device *dev, unsigned int ifnum,
-        const struct usb_device_id *id)
-{
-    struct usb_interface *interface = &dev->actconfig->interface[ifnum];
-#else
 static int zfLnxProbe(struct usb_interface *interface,
 	const struct usb_device_id *id)
 {
     struct usb_device *dev = interface_to_usbdev(interface);
-#endif
 
     struct net_device *net = NULL;
     struct usbdrv_private *macp = NULL;
     int vendor_id, product_id;
     int result = 0;
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0))
     usb_get_dev(dev);
-#endif
 
     vendor_id = dev->descriptor.idVendor;
     product_id = dev->descriptor.idProduct;
@@ -103,15 +93,6 @@ static int zfLnxProbe(struct usb_interface *interface,
         printk(KERN_NOTICE "USB 1.1 Host\n");
 #endif
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-    if (usb_set_configuration(dev, dev->config[0].bConfigurationValue))
-    {
-        printk(KERN_ERR "usb_set_configuration() failed\n");
-        result = -EIO;
-        goto fail;
-    }
-#endif
-
     if (!(macp = kmalloc(sizeof(struct usbdrv_private), GFP_KERNEL)))
     {
         printk(KERN_ERR "out of memory allocating device structure\n");
@@ -122,10 +103,6 @@ static int zfLnxProbe(struct usb_interface *interface,
     /* Zero the memory */
     memset(macp, 0, sizeof(struct usbdrv_private));
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-    usb_inc_dev_use(dev);
-#endif
-
     net = alloc_etherdev(0);
 
     if (net == NULL)
@@ -137,10 +114,6 @@ static int zfLnxProbe(struct usb_interface *interface,
 
     strcpy(net->name, "ath%d");
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
-    SET_MODULE_OWNER(net);
-#endif
-
     net->priv = macp;   //kernel 2.6
     macp->udev = dev;
     macp->device = net;
@@ -166,16 +139,12 @@ static int zfLnxProbe(struct usb_interface *interface,
     }
     else
     {
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0))
         usb_set_intfdata(interface, macp);
         SET_NETDEV_DEV(net, &interface->dev);
-#endif
 
         if (register_netdev(net) != 0)
         {
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0))
             usb_set_intfdata(interface, NULL);
-#endif
             goto fail3;
         }
     }
@@ -191,30 +160,16 @@ fail1:
     kfree(macp);
 
 fail:
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0))
     usb_put_dev(dev);
-#endif
     macp = NULL;
 
 done:
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-    return macp;
-#else
     return result;
-#endif
 }
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-static void zfLnxDisconnect(struct usb_device *dev, void *ptr)
-#else
 static void zfLnxDisconnect(struct usb_interface *interface)
-#endif
 {
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0))
     struct usbdrv_private *macp = (struct usbdrv_private *) usb_get_intfdata(interface);
-#else
-    struct usbdrv_private *macp = (struct usbdrv_private *)ptr;
-#endif
 
     printk(KERN_DEBUG "zfLnxDisconnect\n");
 
@@ -246,11 +201,7 @@ static void zfLnxDisconnect(struct usb_interface *interface)
 
     unregister_netdev(macp->device);
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-    usb_dec_dev_use(dev);
-#else
     usb_put_dev(interface_to_usbdev(interface));
-#endif
 
     //printk(KERN_ERR "3. zfLnxUnlinkAllUrbs\n");
     //zfLnxUnlinkAllUrbs(macp);
@@ -263,17 +214,10 @@ static void zfLnxDisconnect(struct usb_interface *interface)
     kfree(macp);
     macp = NULL;
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0))
     usb_set_intfdata(interface, NULL);
-#endif
 }
 
 static struct usb_driver zd1221_driver = {
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0))
-    #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,15))
-	.owner        = THIS_MODULE,
-	#endif
-#endif
 	.name         = driver_name,
 	.probe        = zfLnxProbe,
 	.disconnect   = zfLnxDisconnect,

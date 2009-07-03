Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbZGCFx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbZGCFx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 01:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbZGCFxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 01:53:19 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34701 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbZGCFxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 01:53:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sS+r+Oivko0LejWu2miX4Y+X1cEGXofylimU9O7zY7YjkqaHk0/HtAazCNqf3/7MKT
         CrufL5ifG199O+VwCRdtcR9idKcCJMbjQysIIl+n/8gIZHcmQwwopsOx4bKAJJ8IIAjI
         ruwwKw9sZtCZEGZErxbb7HpvpEo4bc23N/qkI=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       forest@alittletooquiet.net
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] Staging: vt6656: remove dependency on kernel version
Date: Fri,  3 Jul 2009 09:52:59 +0400
Message-Id: <1246600379-9409-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/vt6656/bssdb.c      |    9 --
 drivers/staging/vt6656/device.h     |    5 -
 drivers/staging/vt6656/device_cfg.h |    4 -
 drivers/staging/vt6656/dpc.c        |   15 ---
 drivers/staging/vt6656/iwctl.c      |   56 ---------
 drivers/staging/vt6656/kcompat.h    |  232 -----------------------------------
 drivers/staging/vt6656/main_usb.c   |  111 -----------------
 drivers/staging/vt6656/usbpipe.c    |  132 --------------------
 drivers/staging/vt6656/wcmd.c       |    5 -
 drivers/staging/vt6656/wmgr.c       |   15 ---
 10 files changed, 0 insertions(+), 584 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 563fddc..58348cf 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -1300,12 +1300,7 @@ if((pMgmt->eCurrState!=WMAC_STATE_ASSOC) &&
              wpahdr->req_ie_len = 0;
              skb_put(pDevice->skb, sizeof(viawget_wpa_header));
              pDevice->skb->dev = pDevice->wpadev;
-//2008-4-3 modify by Chester for wpa
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
              pDevice->skb->mac_header = pDevice->skb->data;
-#else
-            pDevice->skb->mac.raw = pDevice->skb->data;
-#endif
              pDevice->skb->pkt_type = PACKET_HOST;
              pDevice->skb->protocol = htons(ETH_P_802_2);
              memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
@@ -1345,11 +1340,7 @@ DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bIsRoaming %d, !\n", pDevice->bIsRoaming );
              wpahdr->req_ie_len = 0;
              skb_put(pDevice->skb, sizeof(viawget_wpa_header));
              pDevice->skb->dev = pDevice->wpadev;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
                 pDevice->skb->mac_header = pDevice->skb->data;
-#else
-                pDevice->skb->mac.raw = pDevice->skb->data;
-#endif
              pDevice->skb->pkt_type = PACKET_HOST;
              pDevice->skb->protocol = htons(ETH_P_802_2);
              memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 143aa76..91e2f8f 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -57,11 +57,6 @@
 #include <linux/sched.h>
 #include <linux/if.h>
 #include <linux/rtnetlink.h>//James
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18)
-#include <linux/config.h>
-#endif
-
 #include <linux/proc_fs.h>
 #include <linux/inetdevice.h>
 #include <linux/reboot.h>
diff --git a/drivers/staging/vt6656/device_cfg.h b/drivers/staging/vt6656/device_cfg.h
index f272c98..e8acc90 100644
--- a/drivers/staging/vt6656/device_cfg.h
+++ b/drivers/staging/vt6656/device_cfg.h
@@ -27,10 +27,6 @@
 #ifndef __DEVICE_CONFIG_H
 #define __DEVICE_CONFIG_H
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18)
-#include <linux/config.h>
-#endif
-
 #include <linux/types.h>
 
 #if !defined(__TTYPE_H__)
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 702304b..a90d092 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -674,12 +674,7 @@ RXbBulkInProcessData (
 	            skb->data += 8;
 	            skb->tail += 8;
                 skb_put(skb, FrameSize);
-//2008-4-3 modify by Chester for wpa
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
 	            skb->mac_header = skb->data;
-#else
-                    skb->mac.raw = skb->data;
-#endif
 	            skb->pkt_type = PACKET_OTHERHOST;
     	        skb->protocol = htons(ETH_P_802_2);
 	            memset(skb->cb, 0, sizeof(skb->cb));
@@ -836,12 +831,7 @@ RXbBulkInProcessData (
             skb->data +=  (cbIVOffset + 8);
             skb->tail +=  (cbIVOffset + 8);
             skb_put(skb, FrameSize);
-//2008-4-3 modify by Chester for wpa
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
             skb->mac_header = skb->data;
-#else
-           skb->mac.raw = skb->data;
-#endif
             skb->pkt_type = PACKET_OTHERHOST;
             skb->protocol = htons(ETH_P_802_2);
             memset(skb->cb, 0, sizeof(skb->cb));
@@ -961,12 +951,7 @@ RXbBulkInProcessData (
                      wpahdr->req_ie_len = 0;
                      skb_put(pDevice->skb, sizeof(viawget_wpa_header));
                      pDevice->skb->dev = pDevice->wpadev;
-//2008-4-3 modify by Chester for wpa
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
                    pDevice->skb->mac_header = pDevice->skb->data;
-#else
-                   pDevice->skb->mac.raw = pDevice->skb->data;
-#endif
                      pDevice->skb->pkt_type = PACKET_HOST;
                      pDevice->skb->protocol = htons(ETH_P_802_2);
                      memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index e6f8c18..7b42a1a 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -337,22 +337,14 @@ int iwctl_giwscan(struct net_device *dev,
 		    iwe.cmd = SIOCGIWAP;
 		    iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
 			memcpy(iwe.u.ap_addr.sa_data, pBSS->abyBSSID, WLAN_BSSID_LEN);
-			#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)   //mike add
                            current_ev = iwe_stream_add_event(info,current_ev,end_buf, &iwe, IW_EV_ADDR_LEN);
-			#else
-			current_ev = iwe_stream_add_event(current_ev,end_buf, &iwe, IW_EV_ADDR_LEN);
-			#endif
                  //ADD ssid
 	             memset(&iwe, 0, sizeof(iwe));
                       iwe.cmd = SIOCGIWESSID;
                       pItemSSID = (PWLAN_IE_SSID)pBSS->abySSID;
                        iwe.u.data.length = pItemSSID->len;
                        iwe.u.data.flags = 1;
-		  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)   //mike add
                       current_ev = iwe_stream_add_point(info,current_ev,end_buf, &iwe, pItemSSID->abySSID);
-		  #else
-       		    current_ev = iwe_stream_add_point(current_ev,end_buf, &iwe, pItemSSID->abySSID);
-		  #endif
 		//ADD mode
 		    memset(&iwe, 0, sizeof(iwe));
 		    iwe.cmd = SIOCGIWMODE;
@@ -363,11 +355,7 @@ int iwctl_giwscan(struct net_device *dev,
                 iwe.u.mode = IW_MODE_ADHOC;
 		    }
 	        iwe.len = IW_EV_UINT_LEN;
-		 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)   //mike add
                       current_ev = iwe_stream_add_event(info,current_ev, end_buf, &iwe,  IW_EV_UINT_LEN);
-		 #else
-		    current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,  IW_EV_UINT_LEN);
-		 #endif
            //ADD frequency
             pSuppRates = (PWLAN_IE_SUPP_RATES)pBSS->abySuppRates;
             pExtSuppRates = (PWLAN_IE_SUPP_RATES)pBSS->abyExtSuppRates;
@@ -376,11 +364,7 @@ int iwctl_giwscan(struct net_device *dev,
            	iwe.u.freq.m = pBSS->uChannel;
            	iwe.u.freq.e = 0;
            	iwe.u.freq.i = 0;
-	     #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)   //mike add
                   current_ev = iwe_stream_add_event(info,current_ev,end_buf, &iwe, IW_EV_FREQ_LEN);
-	     #else
-           	current_ev = iwe_stream_add_event(current_ev,end_buf, &iwe, IW_EV_FREQ_LEN);
-	     #endif
             //2008-0409-04, <Add> by Einsn Liu
 			{
 			int f = (int)pBSS->uChannel - 1;
@@ -388,11 +372,7 @@ int iwctl_giwscan(struct net_device *dev,
 			iwe.u.freq.m = frequency_list[f] * 100000;
 			iwe.u.freq.e = 1;
 			}
-	     #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)   //mike add
                   current_ev = iwe_stream_add_event(info,current_ev,end_buf, &iwe, IW_EV_FREQ_LEN);
-	     #else
-           	current_ev = iwe_stream_add_event(current_ev,end_buf, &iwe, IW_EV_FREQ_LEN);
-	     #endif
        		//ADD quality
             memset(&iwe, 0, sizeof(iwe));
 	        iwe.cmd = IWEVQUAL;
@@ -442,11 +422,7 @@ int iwctl_giwscan(struct net_device *dev,
 	        iwe.u.qual.qual = 0;
 		}
 */
-            #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)   //mike add
                  current_ev = iwe_stream_add_event(info,current_ev, end_buf, &iwe, IW_EV_QUAL_LEN);
-	   #else
-	        current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe, IW_EV_QUAL_LEN);
-	   #endif
        	//ADD encryption
             memset(&iwe, 0, sizeof(iwe));
             iwe.cmd = SIOCGIWENCODE;
@@ -456,11 +432,7 @@ int iwctl_giwscan(struct net_device *dev,
             }else {
                 iwe.u.data.flags = IW_ENCODE_DISABLED;
             }
-	#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)   //mike add
             current_ev = iwe_stream_add_point(info,current_ev,end_buf, &iwe, pItemSSID->abySSID);
-	#else
-            current_ev = iwe_stream_add_point(current_ev,end_buf, &iwe, pItemSSID->abySSID);
-	#endif
 
             memset(&iwe, 0, sizeof(iwe));
             iwe.cmd = SIOCGIWRATE;
@@ -472,22 +444,14 @@ int iwctl_giwscan(struct net_device *dev,
 			        break;
 		        // Bit rate given in 500 kb/s units (+ 0x80)
 		        iwe.u.bitrate.value = ((pSuppRates->abyRates[kk] & 0x7f) * 500000);
-		     #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)   //mike add
                           current_val = iwe_stream_add_value(info,current_ev, current_val, end_buf, &iwe, IW_EV_PARAM_LEN);
-		     #else
-		        current_val = iwe_stream_add_value(current_ev, current_val, end_buf, &iwe, IW_EV_PARAM_LEN);
-		     #endif
 	        }
        		for (kk = 0 ; kk < 8 ; kk++) {
 		        if (pExtSuppRates->abyRates[kk] == 0)
 			        break;
 		        // Bit rate given in 500 kb/s units (+ 0x80)
 		        iwe.u.bitrate.value = ((pExtSuppRates->abyRates[kk] & 0x7f) * 500000);
-		    #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)   //mike add
                          current_val = iwe_stream_add_value(info,current_ev, current_val, end_buf, &iwe, IW_EV_PARAM_LEN);
-		    #else
-		        current_val = iwe_stream_add_value(current_ev, current_val, end_buf, &iwe, IW_EV_PARAM_LEN);
-		   #endif
 	        }
 
 	        if((current_val - current_ev) > IW_EV_LCP_LEN)
@@ -498,33 +462,21 @@ int iwctl_giwscan(struct net_device *dev,
             iwe.cmd = IWEVCUSTOM;
             sprintf(buf, "bcn_int=%d", pBSS->wBeaconInterval);
             iwe.u.data.length = strlen(buf);
-     #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)   //mike add
              current_ev = iwe_stream_add_point(info,current_ev, end_buf, &iwe, buf);
-    #else
-            current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe, buf);
-    #endif
 
 #if WIRELESS_EXT > 17
             if ((pBSS->wWPALen > 0) && (pBSS->wWPALen <= MAX_WPA_IE_LEN)) {
                 memset(&iwe, 0, sizeof(iwe));
                 iwe.cmd = IWEVGENIE;
                 iwe.u.data.length = pBSS->wWPALen;
-	    #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)   //mike add
                 current_ev = iwe_stream_add_point(info,current_ev, end_buf, &iwe, pBSS->byWPAIE);
-	   #else
-                current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe, pBSS->byWPAIE);
-	   #endif
             }
 
             if ((pBSS->wRSNLen > 0) && (pBSS->wRSNLen <= MAX_WPA_IE_LEN)) {
                 memset(&iwe, 0, sizeof(iwe));
                 iwe.cmd = IWEVGENIE;
                 iwe.u.data.length = pBSS->wRSNLen;
-	   #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)   //mike add
                 current_ev = iwe_stream_add_point(info,current_ev, end_buf, &iwe, pBSS->byRSNIE);
-	   #else
-                current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe, pBSS->byRSNIE);
-	   #endif
             }
 
 #else // WIRELESS_EXT > 17
@@ -537,11 +489,7 @@ int iwctl_giwscan(struct net_device *dev,
 			        p += sprintf(p, "%02x", pBSS->byWPAIE[ii]);
 		        }
 		        iwe.u.data.length = strlen(buf);
-		     #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)   //mike add
                           current_ev = iwe_stream_add_point(info,current_ev, end_buf, &iwe, buf);
-		     #else
-		        current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe, buf);
-		     #endif
 		    }
 
 
@@ -554,11 +502,7 @@ int iwctl_giwscan(struct net_device *dev,
 			        p += sprintf(p, "%02x", pBSS->byRSNIE[ii]);
 		        }
 		        iwe.u.data.length = strlen(buf);
-		     #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)   //mike add
                           current_ev = iwe_stream_add_point(info,current_ev, end_buf, &iwe, buf);
-		     #else
-		        current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe, buf);
-		     #endif
 		    }
 #endif
 #endif
diff --git a/drivers/staging/vt6656/kcompat.h b/drivers/staging/vt6656/kcompat.h
index 370483d..3dc209c 100644
--- a/drivers/staging/vt6656/kcompat.h
+++ b/drivers/staging/vt6656/kcompat.h
@@ -70,246 +70,14 @@ typedef void irqreturn_t;
 
 #endif
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-
 #define vntwusb_submit_urb(val) usb_submit_urb(val, GFP_ATOMIC)
 #define vntwusb_alloc_urb(val)  usb_alloc_urb(val, GFP_ATOMIC)
-#else
-#define vntwusb_alloc_urb(val)  usb_alloc_urb(val)
-#define vntwusb_submit_urb(val) usb_submit_urb(val)
-
-#endif
-
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,10)
 
 #define vntwusb_unlink_urb(val) usb_kill_urb(val)
 
-#else
-#define vntwusb_unlink_urb(val) usb_unlink_urb(val)
-
-#endif
-
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,2,18)
-
-typedef unsigned long dma_addr_t;
-typedef struct wait_queue *wait_queue_head_t;
-#define init_waitqueue_head(x)                  *(x)=NULL
-#define set_current_state(status)       { current->state = (status); mb(); }
-
-#ifdef MODULE
-
-#define module_init(fn) int  init_module   (void) { return fn(); }
-#define module_exit(fn) void cleanup_module(void) { return fn(); }
-
-#else /* MODULE */
-
-#define module_init(fn) int  e100_probe    (void) { return fn(); }
-#define module_exit(fn)  /* NOTHING */
-
-#endif /* MODULE */
-
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,2,18) */
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0)
-
-#ifdef MODVERSIONS
-#include <linux/modversions.h>
-#endif
-
-#include <linux/types.h>
-#include <linux/pci.h>
-#include <linux/slab.h>
-#include <asm/io.h>
-
-#define pci_resource_start(dev, bar)                            \
-    (((dev)->base_address[(bar)] & PCI_BASE_ADDRESS_SPACE_IO) ? \
-    ((dev)->base_address[(bar)] & PCI_BASE_ADDRESS_IO_MASK) :   \
-    ((dev)->base_address[(bar)] & PCI_BASE_ADDRESS_MEM_MASK))
-
-static inline int pci_enable_device(struct pci_dev *dev) { return 0; }
-#define __constant_cpu_to_le32 cpu_to_le32
-#define __constant_cpu_to_le16 cpu_to_le16
-
-#define PCI_DMA_TODEVICE   1
-#define PCI_DMA_FROMDEVICE 2
-
-extern inline void *pci_alloc_consistent (struct pci_dev *dev,
-                                          size_t size,
-                                          dma_addr_t *dma_handle) {
-    void *vaddr = kmalloc(size, GFP_ATOMIC);
-    if(vaddr != NULL) {
-        *dma_handle = virt_to_bus(vaddr);
-    }
-    return vaddr;
-}
-
-#define pci_dma_sync_single(dev,dma_handle,size,direction)   do{} while(0)
-#define pci_dma_supported(dev, addr_mask)                    (1)
-#define pci_free_consistent(dev, size, cpu_addr, dma_handle) kfree(cpu_addr)
-#define pci_map_single(dev, addr, size, direction)           virt_to_bus(addr)
-#define pci_unmap_single(dev, dma_handle, size, direction)   do{} while(0)
-
-
-#define spin_lock_bh            spin_lock_irq
-#define spin_unlock_bh          spin_unlock_irq
-#define del_timer_sync(timer)   del_timer(timer)
-#define net_device              device
-
-#define netif_start_queue(dev)   ( clear_bit(0, &(dev)->tbusy))
-#define netif_stop_queue(dev)    (   set_bit(0, &(dev)->tbusy))
-#define netif_wake_queue(dev)    { clear_bit(0, &(dev)->tbusy); \
-                                   mark_bh(NET_BH); }
-#define netif_running(dev)       (  test_bit(0, &(dev)->start))
-#define netif_queue_stopped(dev) (  test_bit(0, &(dev)->tbusy))
-
-#define netif_device_attach(dev) \
-    do{ (dev)->start = 1; netif_start_queue(dev); } while (0)
-#define netif_device_detach(dev) \
-    do{ (dev)->start = 0; netif_stop_queue(dev); } while (0)
-
-#define dev_kfree_skb_irq(skb) dev_kfree_skb(skb)
-
-#define netif_carrier_on(dev)  do {} while (0)
-#define netif_carrier_off(dev) do {} while (0)
-
-
-#define PCI_ANY_ID (~0U)
-
-struct pci_device_id {
-    unsigned int vendor, device;
-    unsigned int subvendor, subdevice;
-    unsigned int class, classmask;
-    unsigned long driver_data;
-};
-
-#define MODULE_DEVICE_TABLE(bus, dev_table)
-#define PCI_MAX_NUM_NICS 256
-
-struct pci_driver {
-    char *name;
-    struct pci_device_id *id_table;
-    int (*probe)(struct pci_dev *dev, const struct pci_device_id *id);
-    void (*remove)(struct pci_dev *dev);
-    void (*suspend)(struct pci_dev *dev);
-    void (*resume)(struct pci_dev *dev);
-    struct pci_dev *pcimap[PCI_MAX_NUM_NICS];
-};
-
-static inline int pci_module_init(struct pci_driver *drv)
-{
-    struct pci_dev *pdev;
-    struct pci_device_id *pcid;
-    uint16_t subvendor, subdevice;
-    int board_count = 0;
-
-    /* walk the global pci device list looking for matches */
-    for (pdev = pci_devices; pdev && (board_count < PCI_MAX_NUM_NICS); pdev = pdev->next) {
-
-        pcid = &drv->id_table[0];
-        pci_read_config_word(pdev, PCI_SUBSYSTEM_VENDOR_ID, &subvendor);
-        pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &subdevice);
-
-        while (pcid->vendor != 0) {
-            if (((pcid->vendor == pdev->vendor) || (pcid->vendor == PCI_ANY_ID)) &&
-                ((pcid->device == pdev->device) || (pcid->device == PCI_ANY_ID)) &&
-                ((pcid->subvendor == subvendor) || (pcid->subvendor == PCI_ANY_ID)) &&
-                ((pcid->subdevice == subdevice) || (pcid->subdevice == PCI_ANY_ID))) {
-
-                if (drv->probe(pdev, pcid) == 0) {
-                    drv->pcimap[board_count] = pdev;
-                    board_count++;
-                }
-                break;
-            }
-            pcid++;
-        }
-    }
-
-    if (board_count < PCI_MAX_NUM_NICS) {
-        drv->pcimap[board_count] = NULL;
-    }
-
-    return (board_count > 0) ? 0 : -ENODEV;
-}
-
-static inline void pci_unregister_driver(struct pci_driver *drv)
-{
-    int i;
-
-    for (i = 0; i < PCI_MAX_NUM_NICS; i++) {
-        if (!drv->pcimap[i])
-            break;
-
-        drv->remove(drv->pcimap[i]);
-    }
-}
-
-
-#define pci_set_drvdata(pcid, data)
-
-#define pci_get_drvdata(pcid) ({                            \
-    PSDevice pInfo;                                         \
-    for (pInfo = pDevice_Infos;                             \
-        pInfo; pInfo = pInfo->next) {                       \
-        if (pInfo->pcid == pcid)                            \
-            break;                                          \
-    }                                                       \
-    pInfo; })
-
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0) */
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,5)
-
-#define skb_linearize(skb, gfp_mask) ({     \
-    struct sk_buff *tmp_skb;                \
-    tmp_skb = skb;                          \
-    skb = skb_copy(tmp_skb, gfp_mask);      \
-    dev_kfree_skb_irq(tmp_skb); })
-
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,4,5) */
-
 #ifndef MODULE_LICESEN
 #define MODULE_LICESEN(x)
 #endif
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,6)
-
-#include <linux/types.h>
-#include <linux/pci.h>
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,2)
-static inline int pci_set_power_state(struct pci_dev* pcid, int state) { return 0; }
-#endif
-
-#define PMCSR       0xe0
-#define PM_ENABLE_BIT   0x0100
-#define PM_CLEAR_BIT    0x8000
-#define PM_STATE_MASK   0xFFFC
-#define PM_STATE_D1 0x0001
-
-static inline int
-pci_enable_wake(struct pci_dev *dev, u32 state, int enable)
-{
-    u16 p_state;
-
-    pci_read_config_word(dev, PMCSR, &p_state);
-    pci_write_config_word(dev, PMCSR, p_state | PM_CLEAR_BIT);
-
-    if (enable == 0) {
-        p_state &= ~PM_ENABLE_BIT;
-    } else {
-        p_state |= PM_ENABLE_BIT;
-    }
-    p_state &= PM_STATE_MASK;
-    p_state |= state;
-
-    pci_write_config_word(dev, PMCSR, p_state);
-
-    return 0;
-}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,4,6) */
-
 #endif
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 722b739..f94bdff 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -150,19 +150,11 @@ MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION(DEVICE_FULL_DRV_NAM);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,15)
 #define DEVICE_PARAM(N,D) \
         static int N[MAX_UINTS]=OPTION_DEFAULT;\
         module_param_array(N, int, NULL, 0);\
         MODULE_PARM_DESC(N, D);
 
-#else
-#define DEVICE_PARAM(N,D) \
-        static const int N[MAX_UINTS]=OPTION_DEFAULT;\
-        MODULE_PARM(N, "1-" __MODULE_STRING(MAX_UINTS) "i");\
-        MODULE_PARM_DESC(N, D);
-#endif
-
 #define RX_DESC_MIN0     16
 #define RX_DESC_MAX0     128
 #define RX_DESC_DEF0     64
@@ -331,19 +323,12 @@ struct iw_request_info {};
 
 
 /*---------------------  Static Functions  --------------------------*/
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-
 static int vntwusb_found1(struct usb_interface *intf, const struct usb_device_id *id);
 static void vntwusb_disconnect(struct usb_interface *intf);
 #ifdef CONFIG_PM	/* Minimal support for suspend and resume */
 static int vntwusb_suspend(struct usb_interface *intf, pm_message_t message);
 static int vntwusb_resume(struct usb_interface *intf);
 #endif
-#else
-
-static void* vntwusb_found1(struct usb_device *udev, UINT interface, const struct usb_device_id *id);
-static void vntwusb_disconnect(struct usb_device *udev, void *ptr);
-#endif
 static struct net_device_stats *device_get_stats(struct net_device *dev);
 static int  device_open(struct net_device *dev);
 static int  device_xmit(struct sk_buff *skb, struct net_device *dev);
@@ -370,10 +355,7 @@ static int Config_FileGetParameter(UCHAR *string, UCHAR *dest,UCHAR *source);
 //2008-0714<Add>by Mike Liu
 static BOOL device_release_WPADEV(PSDevice pDevice);
 
-//2007-1107-01<Add>by MikeLiu
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
 static void usb_device_reset(PSDevice pDevice);
-#endif
 
 
 
@@ -778,12 +760,7 @@ static BOOL device_release_WPADEV(PSDevice pDevice)
                  wpahdr->req_ie_len = 0;
                  skb_put(pDevice->skb, sizeof(viawget_wpa_header));
                  pDevice->skb->dev = pDevice->wpadev;
-//2008-4-3 modify by Chester for wpa
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
                  pDevice->skb->mac_header = pDevice->skb->data;
-#else
-                 pDevice->skb->mac.raw = pDevice->skb->data;
-#endif
                  pDevice->skb->pkt_type = PACKET_HOST;
                  pDevice->skb->protocol = htons(ETH_P_802_2);
                  memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
@@ -848,23 +825,12 @@ static const struct net_device_ops device_netdev_ops = {
 };
 
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-
 static int
 vntwusb_found1(struct usb_interface *intf, const struct usb_device_id *id)
-#else
-
-static void *
-vntwusb_found1(struct usb_device *udev, UINT interface, const struct usb_device_id *id)
-#endif
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23)
    BYTE            fake_mac[U_ETHER_ADDR_LEN] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x01};//fake MAC address
-#endif
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	struct usb_device *udev = interface_to_usbdev(intf);
     int         rc = 0;
-#endif
     struct net_device *netdev = NULL;
     PSDevice    pDevice = NULL;
 
@@ -872,16 +838,9 @@ vntwusb_found1(struct usb_device *udev, UINT interface, const struct usb_device_
     printk(KERN_NOTICE "%s Ver. %s\n",DEVICE_FULL_DRV_NAM, DEVICE_VERSION);
     printk(KERN_NOTICE "Copyright (c) 2004 VIA Networking Technologies, Inc.\n");
 
-//2008-0922-01<Add>by MikeLiu, add usb counter.
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
   udev = usb_get_dev(udev);
-#endif
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     netdev = alloc_etherdev(sizeof(DEVICE_INFO));
-#else
-    netdev = init_etherdev(netdev, 0);
-#endif
 
     if (netdev == NULL) {
         printk(KERN_ERR DEVICE_NAME ": allocate net device failed \n");
@@ -895,11 +854,6 @@ vntwusb_found1(struct usb_device *udev, UINT interface, const struct usb_device_
     pDevice->dev = netdev;
     pDevice->usb = udev;
 
-    // Chain it all together
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24)
-    SET_MODULE_OWNER(netdev);
-#endif
-
     // Set initial settings
     device_set_options(pDevice);
     spin_lock_init(&pDevice->lock);
@@ -912,9 +866,6 @@ vntwusb_found1(struct usb_device *udev, UINT interface, const struct usb_device_
 #ifdef WIRELESS_EXT
 
 //2007-0508-01<Add>by MikeLiu
-  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	netdev->get_wireless_stats = iwctl_get_wireless_stats;
-  #endif
 
 #if WIRELESS_EXT > 12
 	netdev->wireless_handlers = (struct iw_handler_def *)&iwctl_handler_def;
@@ -922,17 +873,11 @@ vntwusb_found1(struct usb_device *udev, UINT interface, const struct usb_device_
 #endif /* WIRELESS_EXT > 12 */
 #endif /* WIRELESS_EXT */
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-
    //2008-0623-01<Remark>by MikeLiu
   //2007-0821-01<Add>by MikeLiu
-  // #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
          usb_set_intfdata(intf, pDevice);
 	SET_NETDEV_DEV(netdev, &intf->dev);
-   //#endif
-   #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23)
     memcpy(pDevice->dev->dev_addr, fake_mac, U_ETHER_ADDR_LEN); //use fake mac address
-   #endif
     rc = register_netdev(netdev);
     if (rc != 0) {
         printk(KERN_ERR DEVICE_NAME " Failed to register netdev\n");
@@ -956,10 +901,7 @@ vntwusb_found1(struct usb_device *udev, UINT interface, const struct usb_device_
         kfree(pDevice);
    }
 
-//2007-1107-03<Add>by MikeLiu
-   #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
          usb_device_reset(pDevice);
-   #endif
 
 #ifdef SndEvt_ToAPI
 {
@@ -972,21 +914,13 @@ vntwusb_found1(struct usb_device *udev, UINT interface, const struct usb_device_
 #endif
 
 	return 0;
-#else
-    return pDevice;
-#endif
 
 
 err_nomem:
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-
  //2008-0922-01<Add>by MikeLiu, decrease usb counter.
     usb_put_dev(udev);
 
     return -ENOMEM;
-#else
-    return NULL;
-#endif
 }
 
 
@@ -1032,7 +966,6 @@ static VOID device_free_rx_bufs(PSDevice pDevice) {
 }
 
 //2007-1107-02<Add>by MikeLiu
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
 static void usb_device_reset(PSDevice pDevice)
 {
  int status;
@@ -1041,7 +974,6 @@ static void usb_device_reset(PSDevice pDevice)
             printk("usb_device_reset fail status=%d\n",status);
 	return ;
 }
-#endif
 
 static VOID device_free_int_bufs(PSDevice pDevice) {
 
@@ -1269,11 +1201,7 @@ static int  device_open(struct net_device *dev) {
     tasklet_init(&pDevice->ReadWorkItem, (void *)RXvWorkItem, (unsigned long)pDevice);
     tasklet_init(&pDevice->EventWorkItem, (void *)INTvWorkItem, (unsigned long)pDevice);
     add_timer(&(pDevice->sMgmtObj.sTimerSecondCallback));
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     pDevice->int_interval = 100;  //Max 100 microframes.
-#else
-    pDevice->int_interval = 0x10; //16 microframes interval(~2ms) for usb 2.0
-#endif
     pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 
     pDevice->bIsRxWorkItemQueued = TRUE;
@@ -1354,9 +1282,7 @@ static int  device_close(struct net_device *dev) {
     PSDevice    pDevice=(PSDevice) netdev_priv(dev);
     PSMgmtObject     pMgmt = &(pDevice->sMgmtObj);
 
-   #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
         int uu;
-   #endif
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_close1 \n");
     if (pDevice == NULL)
@@ -1381,8 +1307,6 @@ static int  device_close(struct net_device *dev) {
 //2008-0714-01<Add>by MikeLiu
 device_release_WPADEV(pDevice);
 
- //2007-0821-01<Add>by MikeLiu
-   #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
         memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
         pMgmt->bShareKeyAlgorithm = FALSE;
         pDevice->bEncryptionEnable = FALSE;
@@ -1391,7 +1315,6 @@ device_release_WPADEV(pDevice);
             for(uu=0;uu<MAX_KEY_TABLE;uu++)
                 MACvDisableKeyEntry(pDevice,uu);
             spin_unlock_irq(&pDevice->lock);
-   #endif
 
     if ((pDevice->flags & DEVICE_FLAGS_UNPLUG) == FALSE) {
         MACbShutdown(pDevice);
@@ -1444,22 +1367,12 @@ device_release_WPADEV(pDevice);
     return 0;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 
 static void vntwusb_disconnect(struct usb_interface *intf)
 
-#else
-
-static void vntwusb_disconnect(struct usb_device *udev, void *ptr)
-#endif
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 
 	PSDevice  pDevice = usb_get_intfdata(intf);
-#else
-	PSDevice  pDevice = (PSDevice)ptr;
-#endif
-
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_disconnect1.. \n");
     if (pDevice == NULL)
@@ -1477,14 +1390,10 @@ static void vntwusb_disconnect(struct usb_device *udev, void *ptr)
 //2008-0714-01<Add>by MikeLiu
 device_release_WPADEV(pDevice);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-
 	usb_set_intfdata(intf, NULL);
 //2008-0922-01<Add>by MikeLiu, decrease usb counter.
      usb_put_dev(interface_to_usbdev(intf));
 
-#endif
-
     pDevice->flags |= DEVICE_FLAGS_UNPLUG;
     if (pDevice->dev != NULL) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "unregister_netdev..\n");
@@ -1495,11 +1404,7 @@ device_release_WPADEV(pDevice);
    if(wpa_set_wpadev(pDevice, 0)!=0)
      printk("unregister wpadev fail?\n");
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         free_netdev(pDevice->dev);
-#else
-	    kfree(pDevice->dev);
-#endif
     }
 
 	kfree(pDevice);
@@ -2360,12 +2265,7 @@ static int ethtool_ioctl(struct net_device *dev, void *useraddr)
 MODULE_DEVICE_TABLE(usb, vntwusb_table);
 
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-
 static struct usb_driver vntwusb_driver = {
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,15)
-	    .owner =	THIS_MODULE,
-#endif
 	    .name =		DEVICE_NAME,
 	    .probe =	vntwusb_found1,
 	    .disconnect =	vntwusb_disconnect,
@@ -2379,17 +2279,6 @@ static struct usb_driver vntwusb_driver = {
 #endif
 };
 
-#else
-
-static struct usb_driver vntwusb_driver = {
-	    name:   DEVICE_NAME,
-	    probe:  vntwusb_found1,
-	    disconnect: vntwusb_disconnect,
-	    id_table:   vntwusb_table,
-};
-
-#endif
-
 static int __init vntwusb_init_module(void)
 {
     printk(KERN_NOTICE DEVICE_FULL_DRV_NAM " " DEVICE_VERSION);
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 625ffb6..97efd87 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -86,49 +86,6 @@ static int          msglevel                =MSG_LEVEL_INFO;
 /*---------------------  Static Variables  --------------------------*/
 
 /*---------------------  Static Functions  --------------------------*/
-//2007-0508-02<Add>by MikeLiu
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))&&(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20))
-
-static
-VOID
-s_nsInterruptUsbIoCompleteRead(
-    IN struct urb *urb,
-    IN struct pt_regs *regs
-    );
-
-
-static
-VOID
-s_nsBulkInUsbIoCompleteRead(
-    IN struct urb *urb,
-    IN struct pt_regs *regs
-    );
-
-
-static
-VOID
-s_nsBulkOutIoCompleteWrite(
-    IN struct urb *urb,
-    IN struct pt_regs *regs
-    );
-
-
-static
-VOID
-s_nsControlInUsbIoCompleteRead(
-    IN struct urb *urb,
-    IN struct pt_regs *regs
-    );
-
-static
-VOID
-s_nsControlInUsbIoCompleteWrite(
-    IN struct urb *urb,
-    IN struct pt_regs *regs
-    );
-
-#else
-
 static
 VOID
 s_nsInterruptUsbIoCompleteRead(
@@ -162,9 +119,6 @@ s_nsControlInUsbIoCompleteWrite(
     IN struct urb *urb
     );
 
-#endif
-
-
 /*---------------------  Export Variables  --------------------------*/
 
 /*---------------------  Export Functions  --------------------------*/
@@ -338,23 +292,11 @@ PIPEnsControlIn(
     return ntStatus;
 }
 
-//2007-0508-03<Add>by MikeLiu
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))&&(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20))
-
-static
-VOID
-s_nsControlInUsbIoCompleteWrite(
-    IN struct urb *urb,
-    IN struct pt_regs *regs
-    )
-#else
-
 static
 VOID
 s_nsControlInUsbIoCompleteWrite(
     IN struct urb *urb
     )
-#endif
 {
     PSDevice        pDevice;
 
@@ -391,23 +333,11 @@ s_nsControlInUsbIoCompleteWrite(
  * Return Value: STATUS_INSUFFICIENT_RESOURCES or result of IoCallDriver
  *
  */
-
-//2007-0508-04<Add>by MikeLiu
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))&&(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20))
-static
-VOID
-s_nsControlInUsbIoCompleteRead(
-    IN struct urb *urb,
-    IN struct pt_regs *regs
-    )
-#else
-
 static
 VOID
 s_nsControlInUsbIoCompleteRead(
     IN struct urb *urb
     )
-#endif
 {
     PSDevice        pDevice;
 
@@ -488,10 +418,7 @@ PIPEnsInterruptRead(
 	                 );
 #else
 
-//2008-0526-01<Add>by MikeLiu
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23)
     pDevice->pInterruptURB->interval = pDevice->int_interval;
-#endif
 
 usb_fill_bulk_urb(pDevice->pInterruptURB,
 		pDevice->usb,
@@ -503,19 +430,10 @@ usb_fill_bulk_urb(pDevice->pInterruptURB,
 #endif
 #endif
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	if ((ntStatus = vntwusb_submit_urb(pDevice->pInterruptURB)) != 0) {
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Submit int URB failed %d\n", ntStatus);
     }
 
-#else
-    if (pDevice->bEventAvailable == FALSE) {
-	    if ((ntStatus = vntwusb_submit_urb(pDevice->pInterruptURB)) != 0) {
-	        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Submit int URB failed %d\n", ntStatus);
-        }
-    }
-#endif
-
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"<----s_nsStartInterruptUsbRead Return(%x)\n",ntStatus);
     return ntStatus;
 }
@@ -535,23 +453,12 @@ usb_fill_bulk_urb(pDevice->pInterruptURB,
  * Return Value: STATUS_INSUFFICIENT_RESOURCES or result of IoCallDriver
  *
  */
-//2007-0508-05<Add>by MikeLiu
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))&&(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20))
-static
-VOID
-s_nsInterruptUsbIoCompleteRead(
-    IN struct urb *urb,
-    IN struct pt_regs *regs
-    )
-#else
-
 static
 VOID
 s_nsInterruptUsbIoCompleteRead(
     IN struct urb *urb
     )
 
-#endif
 {
     PSDevice        pDevice;
     NTSTATUS        ntStatus;
@@ -603,18 +510,9 @@ s_nsInterruptUsbIoCompleteRead(
 
     if (pDevice->fKillEventPollingThread != TRUE) {
    #if 0               //reserve int URB submit
-    #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	if ((ntStatus = vntwusb_submit_urb(urb)) != 0) {
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Re-Submit int URB failed %d\n", ntStatus);
     }
-
-    #else
-    if (pDevice->bEventAvailable == FALSE) {
-	    if ((ntStatus = vntwusb_submit_urb(urb)) != 0) {
-	        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Re-Submit int URB failed %d\n", ntStatus);
-        }
-    }
-    #endif
    #else                                                                                     //replace int URB submit by bulk transfer
     #ifdef Safe_Close
        usb_fill_bulk_urb(pDevice->pInterruptURB,
@@ -625,18 +523,10 @@ s_nsInterruptUsbIoCompleteRead(
 		     s_nsInterruptUsbIoCompleteRead,
 		     pDevice);
 
-     #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	if ((ntStatus = vntwusb_submit_urb(pDevice->pInterruptURB)) != 0) {
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Submit int URB failed %d\n", ntStatus);
            }
 
-     #else
-         if (pDevice->bEventAvailable == FALSE) {
-	    if ((ntStatus = vntwusb_submit_urb(pDevice->pInterruptURB)) != 0) {
-	        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Submit int URB failed %d\n", ntStatus);
-               }
-           }
-      #endif
     #else
         tasklet_schedule(&pDevice->EventWorkItem);
     #endif
@@ -725,23 +615,12 @@ PIPEnsBulkInUsbRead(
  * Return Value: STATUS_INSUFFICIENT_RESOURCES or result of IoCallDriver
  *
  */
-//2007-0508-06<Add>by MikeLiu
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))&&(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20))
-static
-VOID
-s_nsBulkInUsbIoCompleteRead(
-    IN struct urb *urb,
-    IN struct pt_regs *regs
-    )
-#else
-
 static
 VOID
 s_nsBulkInUsbIoCompleteRead(
     IN struct urb *urb
     )
 
-#endif
 {
     PRCB    pRCB = (PRCB)urb->context;
     PSDevice pDevice = (PSDevice)pRCB->pDevice;
@@ -895,22 +774,11 @@ PIPEnsSendBulkOut(
  *               (IofCompleteRequest) to stop working on the irp.
  *
  */
-//2007-0508-07<Add>by MikeLiu
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))&&(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20))
-static
-VOID
-s_nsBulkOutIoCompleteWrite(
-    IN struct urb *urb,
-    IN struct pt_regs *regs
-    )
-#else
-
 static
 VOID
 s_nsBulkOutIoCompleteWrite(
     IN struct urb *urb
     )
-#endif
 {
     PSDevice            pDevice;
     NTSTATUS            status;
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 7c0829e..80d7ca7 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -524,12 +524,7 @@ vRunCommand(
                     (pMgmt->uScanChannel < CB_MAX_CHANNEL_24G)) {
                     s_vProbeChannel(pDevice);
                     spin_unlock_irq(&pDevice->lock);
-		//2008-0526-02<Add>by MikeLiu
-                  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23)
 		     vCommandTimerWait((HANDLE)pDevice, 100);
-                  #else
-                    vCommandTimerWait((HANDLE)pDevice, WCMD_ACTIVE_SCAN_TIME);
-		#endif
                     return;
                 } else {
                     spin_unlock_irq(&pDevice->lock);
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 89eb965..5879e48 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -1053,12 +1053,7 @@ s_vMgrRxAssocResponse(
                        );
                 skb_put(pDevice->skb, sizeof(viawget_wpa_header) + wpahdr->resp_ie_len + wpahdr->req_ie_len);
                 pDevice->skb->dev = pDevice->wpadev;
-//2008-4-3 modify by Chester for wpa
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
                 pDevice->skb->mac_header = pDevice->skb->data;
-#else
-                pDevice->skb->mac.raw = pDevice->skb->data;
-#endif
                 pDevice->skb->pkt_type = PACKET_HOST;
                 pDevice->skb->protocol = htons(ETH_P_802_2);
                 memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
@@ -1697,12 +1692,7 @@ s_vMgrRxDisassociation(
              wpahdr->req_ie_len = 0;
              skb_put(pDevice->skb, sizeof(viawget_wpa_header));
              pDevice->skb->dev = pDevice->wpadev;
-//2008-4-3 modify by Chester for wpa
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
              pDevice->skb->mac_header = pDevice->skb->data;
-#else
-            pDevice->skb->mac.raw = pDevice->skb->data;
-#endif
              pDevice->skb->pkt_type = PACKET_HOST;
              pDevice->skb->protocol = htons(ETH_P_802_2);
              memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
@@ -1805,12 +1795,7 @@ s_vMgrRxDeauthentication(
                  wpahdr->req_ie_len = 0;
                  skb_put(pDevice->skb, sizeof(viawget_wpa_header));
                  pDevice->skb->dev = pDevice->wpadev;
-//2008-4-3 modify by Chester for wpa
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
                  pDevice->skb->mac_header = pDevice->skb->data;
-#else
-                 pDevice->skb->mac.raw = pDevice->skb->data;
-#endif
                  pDevice->skb->pkt_type = PACKET_HOST;
                  pDevice->skb->protocol = htons(ETH_P_802_2);
                  memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
-- 
1.6.3.3


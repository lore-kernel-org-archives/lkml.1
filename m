Return-Path: <linux-kernel-owner+w=401wt.eu-S1765525AbZDHN7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765525AbZDHN7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758926AbZDHN7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:59:16 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55737 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757806AbZDHN7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:59:14 -0400
X-Sasl-enc: VIcTRA3MEODG5+v0jltL4FJBMXA3Rqh/dZQV3vEeaMat 1239199153
Message-ID: <49DCADAE.7050302@fastmail.fm>
Date: Wed, 08 Apr 2009 14:59:10 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 50/56] drivers/staging: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-43-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-44-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-45-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-46-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-47-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-48-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080509q5c8a62e8t7a41302a0b2ac383@mail.gmail.com>
In-Reply-To: <36ca99e90904080509q5c8a62e8t7a41302a0b2ac383@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed patch

Thanks,

Jack

--

drivers/staging: Remove void casts

From: Jack Stone <jwjstone@fastmail.fm>

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---

 drivers/staging/altpciechdma/altpciechdma.c |    4 ++--
 drivers/staging/epl/EplApiLinuxKernel.c     |    8 ++------
 drivers/staging/et131x/et1310_rx.c          |    4 ++--
 drivers/staging/rtl8187se/r8180_core.c      |   13 ++++++-------
 drivers/staging/slicoss/slicoss.c           |    3 +--
 5 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/altpciechdma/altpciechdma.c
b/drivers/staging/altpciechdma/altpciechdma.c
index 5869e14..f613a1d 100644
--- a/drivers/staging/altpciechdma/altpciechdma.c
+++ b/drivers/staging/altpciechdma/altpciechdma.c
@@ -535,7 +535,7 @@ static int __devinit dma_test(struct ape_dev *ape,
struct pci_dev *dev)
 
     /* allocate and map coherently-cached memory for a DMA-able buffer */
     /* @see Documentation/PCI/PCI-DMA-mapping.txt, near line 318 */
-    buffer_virt = (u8 *)pci_alloc_consistent(dev, PAGE_SIZE * 4,
&buffer_bus);
+    buffer_virt = pci_alloc_consistent(dev, PAGE_SIZE * 4, &buffer_bus);
     if (!buffer_virt) {
         printk(KERN_DEBUG "Could not allocate coherent DMA buffer.\n");
         goto fail;
@@ -793,7 +793,7 @@ static int __devinit probe(struct pci_dev *dev,
const struct pci_device_id *id)
 
     /* allocate and map coherently-cached memory for a descriptor table */
     /* @see LDD3 page 446 */
-    ape->table_virt = (struct ape_chdma_table *)pci_alloc_consistent(dev,
+    ape->table_virt = pci_alloc_consistent(dev,
         APE_CHDMA_TABLE_SIZE, &ape->table_bus);
     /* could not allocate table? */
     if (!ape->table_virt) {
diff --git a/drivers/staging/epl/EplApiLinuxKernel.c
b/drivers/staging/epl/EplApiLinuxKernel.c
index cb3e275..4c5dfcd 100644
--- a/drivers/staging/epl/EplApiLinuxKernel.c
+++ b/drivers/staging/epl/EplApiLinuxKernel.c
@@ -655,9 +655,7 @@ static int EplLinIoctl(struct inode
*pDeviceFile_p,    // information about the dev
                 goto Exit;
             }
 
-            pBufHeader =
-                (tEplLinSdoBufHeader *)
-                vmalloc(sizeof(tEplLinSdoBufHeader) +
+            pBufHeader = vmalloc(sizeof(tEplLinSdoBufHeader) +
                     SdoObject.m_uiSize);
             if (pBufHeader == NULL) {    // no memory available
                 iRet = -ENOMEM;
@@ -751,9 +749,7 @@ static int EplLinIoctl(struct inode
*pDeviceFile_p,    // information about the dev
                 goto Exit;
             }
 
-            pBufHeader =
-                (tEplLinSdoBufHeader *)
-                vmalloc(sizeof(tEplLinSdoBufHeader) +
+            pBufHeader = vmalloc(sizeof(tEplLinSdoBufHeader) +
                     SdoObject.m_uiSize);
             if (pBufHeader == NULL) {    // no memory available
                 iRet = -ENOMEM;
diff --git a/drivers/staging/et131x/et1310_rx.c
b/drivers/staging/et131x/et1310_rx.c
index 8dc559a..a3810f5 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -610,8 +610,8 @@ int et131x_init_recv(struct et131x_adapter *adapter)
 
     /* Setup each RFD */
     for (RfdCount = 0; RfdCount < rx_ring->NumRfd; RfdCount++) {
-        pMpRfd = (MP_RFD *) kmem_cache_alloc(rx_ring->RecvLookaside,
-                             GFP_ATOMIC | GFP_DMA);
+        pMpRfd = kmem_cache_alloc(rx_ring->RecvLookaside,
+                     GFP_ATOMIC | GFP_DMA);
 
         if (!pMpRfd) {
             DBG_ERROR(et131x_dbginfo,
diff --git a/drivers/staging/rtl8187se/r8180_core.c
b/drivers/staging/rtl8187se/r8180_core.c
index 6ecd12d..4f35f6d 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1691,7 +1691,7 @@ int alloc_tx_beacon_desc_ring(struct net_device
*dev, int count)
     u32 *tmp;
     struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 
-    priv->txbeaconring = (u32*)pci_alloc_consistent(priv->pdev,
+    priv->txbeaconring = pci_alloc_consistent(priv->pdev,
                       sizeof(u32)*8*count,
                       &priv->txbeaconringdma);
     if (!priv->txbeaconring) return -1;
@@ -1727,8 +1727,7 @@ short alloc_tx_desc_ring(struct net_device *dev,
int bufsize, int count,
         DMESGE ("TX buffer allocation too large");
         return 0;
     }
-    desc = (u32*)pci_alloc_consistent(pdev,
-                      sizeof(u32)*8*count+256, &dma_desc);
+    desc = pci_alloc_consistent(pdev, sizeof(u32)*8*count+256, &dma_desc);
     if(desc==NULL) return -1;
     if(dma_desc & 0xff){
 
@@ -1751,7 +1750,7 @@ short alloc_tx_desc_ring(struct net_device *dev,
int bufsize, int count,
     tmp=desc;
     for (i=0;i<count;i++)
     {
-        buf = (void*)pci_alloc_consistent(pdev,bufsize,&dma_tmp);
+        buf = pci_alloc_consistent(pdev,bufsize,&dma_tmp);
         if (buf == NULL) return -ENOMEM;
 
         switch(addr) {
@@ -1975,8 +1974,8 @@ short alloc_rx_desc_ring(struct net_device *dev,
u16 bufsize, int count)
         return -1;
     }
 
-    desc =
(u32*)pci_alloc_consistent(pdev,sizeof(u32)*rx_desc_size*count+256,
-                      &dma_desc);
+    desc = pci_alloc_consistent(pdev,sizeof(u32)*rx_desc_size*count+256,
+                   &dma_desc);
 
     if(dma_desc & 0xff){
 
@@ -2017,7 +2016,7 @@ short alloc_rx_desc_ring(struct net_device *dev,
u16 bufsize, int count)
         for(j=0;j<bufsize;j++) ((u8*)buf)[i] = 0;
 #endif
 
-        //buf = (void*)pci_alloc_consistent(pdev,bufsize,&dma_tmp);
+        //buf = pci_alloc_consistent(pdev,bufsize,&dma_tmp);
         if(-1 == buffer_add(&(priv->rxbuffer), buf,dma_tmp,
                &(priv->rxbufferhead))){
                DMESGE("Unable to allocate mem RX buf");
diff --git a/drivers/staging/slicoss/slicoss.c
b/drivers/staging/slicoss/slicoss.c
index 9481563..746034c 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -333,8 +333,7 @@ static void slic_init_adapter(struct net_device *netdev,
         pslic_handle->next = adapter->pfree_slic_handles;
         adapter->pfree_slic_handles = pslic_handle;
     }
-    adapter->pshmem = (struct slic_shmem *)
-                    pci_alloc_consistent(adapter->pcidev,
+    adapter->pshmem = pci_alloc_consistent(adapter->pcidev,
                     sizeof(struct slic_shmem),
                     &adapter->
                     phys_shmem);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1765781AbZDHNzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765781AbZDHNzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbZDHNzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:55:22 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33327 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756899AbZDHNzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:55:21 -0400
X-Sasl-enc: ChnwCiwZPqlGUr58XLZtJrNw3puXIRXFsYJZE191QD8x 1239198919
Message-ID: <49DCACC5.1090208@fastmail.fm>
Date: Wed, 08 Apr 2009 14:55:17 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 22/56] message/fusion: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080443m2c50be7dp588dab68e89dadc7@mail.gmail.com>
In-Reply-To: <36ca99e90904080443m2c50be7dp588dab68e89dadc7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed patch

Thanks,

Jack

--

message/fusion: Remove void casts

From: Jack Stone <jwjstone@fastmail.fm>

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---

 drivers/message/fusion/mptbase.c |    6 +++---
 drivers/message/fusion/mptctl.c  |    6 +++---
 drivers/message/fusion/mptfc.c   |    7 +++----
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c
b/drivers/message/fusion/mptbase.c
index d0d126c..656f15f 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -4666,7 +4666,7 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
 
     if (hdr.PageLength > 0) {
         data_sz = hdr.PageLength * 4;
-        ppage0_alloc = (LANPage0_t *) pci_alloc_consistent(ioc->pcidev,
data_sz, &page0_dma);
+        ppage0_alloc = pci_alloc_consistent(ioc->pcidev, data_sz,
&page0_dma);
         rc = -ENOMEM;
         if (ppage0_alloc) {
             memset((u8 *)ppage0_alloc, 0, data_sz);
@@ -4712,7 +4712,7 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
 
     data_sz = hdr.PageLength * 4;
     rc = -ENOMEM;
-    ppage1_alloc = (LANPage1_t *) pci_alloc_consistent(ioc->pcidev,
data_sz, &page1_dma);
+    ppage1_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page1_dma);
     if (ppage1_alloc) {
         memset((u8 *)ppage1_alloc, 0, data_sz);
         cfg.physAddr = page1_dma;
@@ -4986,7 +4986,7 @@ GetIoUnitPage2(MPT_ADAPTER *ioc)
     /* Read the config page */
     data_sz = hdr.PageLength * 4;
     rc = -ENOMEM;
-    ppage_alloc = (IOUnitPage2_t *) pci_alloc_consistent(ioc->pcidev,
data_sz, &page_dma);
+    ppage_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
     if (ppage_alloc) {
         memset((u8 *)ppage_alloc, 0, data_sz);
         cfg.physAddr = page_dma;
diff --git a/drivers/message/fusion/mptctl.c
b/drivers/message/fusion/mptctl.c
index c638171..7893a2c 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -2603,7 +2603,7 @@ mptctl_hp_targetinfo(unsigned long arg)
        /* Get the data transfer speeds
         */
     data_sz = ioc->spi_data.sdp0length * 4;
-    pg0_alloc = (SCSIDevicePage0_t *) pci_alloc_consistent(ioc->pcidev,
data_sz, &page_dma);
+    pg0_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
     if (pg0_alloc) {
         hdr.PageVersion = ioc->spi_data.sdp0version;
         hdr.PageLength = data_sz;
@@ -2667,8 +2667,8 @@ mptctl_hp_targetinfo(unsigned long arg)
         /* Issue the second config page request */
         cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
         data_sz = (int) cfg.cfghdr.hdr->PageLength * 4;
-        pg3_alloc = (SCSIDevicePage3_t *) pci_alloc_consistent(
-                            ioc->pcidev, data_sz, &page_dma);
+        pg3_alloc = pci_alloc_consistent(ioc->pcidev, data_sz,
+                &page_dma);
         if (pg3_alloc) {
             cfg.physAddr = page_dma;
             cfg.pageAddr = (karg.hdr.channel << 8) | karg.hdr.id;
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index c3c24fd..baee13b 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -766,7 +766,7 @@ mptfc_GetFcPortPage0(MPT_ADAPTER *ioc, int portnum)
 
     data_sz = hdr.PageLength * 4;
     rc = -ENOMEM;
-    ppage0_alloc = (FCPortPage0_t *) pci_alloc_consistent(ioc->pcidev,
data_sz, &page0_dma);
+    ppage0_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
     if (ppage0_alloc) {
 
  try_again:
@@ -907,9 +907,8 @@ start_over:
         if (data_sz < sizeof(FCPortPage1_t))
             data_sz = sizeof(FCPortPage1_t);
 
-        page1_alloc = (FCPortPage1_t *) pci_alloc_consistent(ioc->pcidev,
-                        data_sz,
-                        &page1_dma);
+        page1_alloc = pci_alloc_consistent(ioc->pcidev, data_sz,
+                &page1_dma);
         if (!page1_alloc)
             return -ENOMEM;
     }

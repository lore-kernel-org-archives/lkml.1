Return-Path: <linux-kernel-owner+w=401wt.eu-S932520AbZDHLe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbZDHLe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764626AbZDHL10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:27:26 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38804 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764107AbZDHL1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:27:22 -0400
X-Sasl-enc: hnmwy0wmbAFsrdPPhbpW825SiKccC7TFAOWFlvqoc3Bg 1239190041
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 22/56] message/fusion: Remove void casts
Date: Wed,  8 Apr 2009 12:21:54 +0100
Message-Id: <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 drivers/message/fusion/mptbase.c |    6 +++---
 drivers/message/fusion/mptctl.c  |    4 ++--
 drivers/message/fusion/mptfc.c   |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index d0d126c..656f15f 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -4666,7 +4666,7 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
 
 	if (hdr.PageLength > 0) {
 		data_sz = hdr.PageLength * 4;
-		ppage0_alloc = (LANPage0_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
+		ppage0_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
 		rc = -ENOMEM;
 		if (ppage0_alloc) {
 			memset((u8 *)ppage0_alloc, 0, data_sz);
@@ -4712,7 +4712,7 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
 
 	data_sz = hdr.PageLength * 4;
 	rc = -ENOMEM;
-	ppage1_alloc = (LANPage1_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page1_dma);
+	ppage1_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page1_dma);
 	if (ppage1_alloc) {
 		memset((u8 *)ppage1_alloc, 0, data_sz);
 		cfg.physAddr = page1_dma;
@@ -4986,7 +4986,7 @@ GetIoUnitPage2(MPT_ADAPTER *ioc)
 	/* Read the config page */
 	data_sz = hdr.PageLength * 4;
 	rc = -ENOMEM;
-	ppage_alloc = (IOUnitPage2_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
+	ppage_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
 	if (ppage_alloc) {
 		memset((u8 *)ppage_alloc, 0, data_sz);
 		cfg.physAddr = page_dma;
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index c638171..fbcd791 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -2603,7 +2603,7 @@ mptctl_hp_targetinfo(unsigned long arg)
        /* Get the data transfer speeds
         */
 	data_sz = ioc->spi_data.sdp0length * 4;
-	pg0_alloc = (SCSIDevicePage0_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
+	pg0_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
 	if (pg0_alloc) {
 		hdr.PageVersion = ioc->spi_data.sdp0version;
 		hdr.PageLength = data_sz;
@@ -2667,7 +2667,7 @@ mptctl_hp_targetinfo(unsigned long arg)
 		/* Issue the second config page request */
 		cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 		data_sz = (int) cfg.cfghdr.hdr->PageLength * 4;
-		pg3_alloc = (SCSIDevicePage3_t *) pci_alloc_consistent(
+		pg3_alloc = pci_alloc_consistent(
 							ioc->pcidev, data_sz, &page_dma);
 		if (pg3_alloc) {
 			cfg.physAddr = page_dma;
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index c3c24fd..d22acfd 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -766,7 +766,7 @@ mptfc_GetFcPortPage0(MPT_ADAPTER *ioc, int portnum)
 
 	data_sz = hdr.PageLength * 4;
 	rc = -ENOMEM;
-	ppage0_alloc = (FCPortPage0_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
+	ppage0_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
 	if (ppage0_alloc) {
 
  try_again:
@@ -907,7 +907,7 @@ start_over:
 		if (data_sz < sizeof(FCPortPage1_t))
 			data_sz = sizeof(FCPortPage1_t);
 
-		page1_alloc = (FCPortPage1_t *) pci_alloc_consistent(ioc->pcidev,
+		page1_alloc = pci_alloc_consistent(ioc->pcidev,
 						data_sz,
 						&page1_dma);
 		if (!page1_alloc)
-- 
1.5.4.3


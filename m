Return-Path: <linux-kernel-owner+w=401wt.eu-S1764040AbYBTAka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764040AbYBTAka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYBTAkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:40:21 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:37272 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbYBTAkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:40:20 -0500
Date: Wed, 20 Feb 2008 02:39:43 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sathya Prakash <sathya.prakash@lsi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] message/fusion/mptbase.c: fix use-after-free's
Message-ID: <20080220003943.GZ31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two use-after-free's introduced by
commit e78d5b8f1e73ab82f3fd041d05824cfee7d83a2c and spotted by the 
Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/message/fusion/mptbase.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

901baeee449285d231921d0812b64b0f14d794b8 diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index bfda731..0c303c8 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1481,15 +1481,15 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ioc->bars = pci_select_bars(pdev, IORESOURCE_MEM);
 	if (pci_enable_device_mem(pdev)) {
-		kfree(ioc);
 		printk(MYIOC_s_ERR_FMT "pci_enable_device_mem() "
 		       "failed\n", ioc->name);
+		kfree(ioc);
 		return r;
 	}
 	if (pci_request_selected_regions(pdev, ioc->bars, "mpt")) {
-		kfree(ioc);
 		printk(MYIOC_s_ERR_FMT "pci_request_selected_regions() with "
 		       "MEM failed\n", ioc->name);
+		kfree(ioc);
 		return r;
 	}
 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbYJJXBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbYJJXBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 19:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760940AbYJJW6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 18:58:40 -0400
Received: from kroah.org ([198.145.64.141]:54704 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752975AbYJJW6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 18:58:04 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Lior Dotan <liodot@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/23] Staging: SLICOSS: Call pci_release_regions at driver exit
Date: Fri, 10 Oct 2008 15:42:46 -0700
Message-Id: <1223678567-30143-22-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081010224130.GA30117@kroah.com>
References: <20081010224130.GA30117@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lior Dotan <liodot@gmail.com>

slic_entry_probe() calls pci_request_regions() but there's no matching
pci_release_regions() at driver's exit or if slic_entry_probe() fails.

Signed-off-by: Lior Dotan <liodot@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/slicoss/slicoss.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index c129e83..b61ac4b 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -520,6 +520,7 @@ err_out_free_mmio_region:
 	release_mem_region(mmio_start, mmio_len);
 
 err_out_exit_slic_probe:
+	pci_release_regions(pcidev);
 	DBG_ERROR("%s EXIT jiffies[%lx] cpu %d\n", __func__, jiffies,
 		  smp_processor_id());
 
@@ -649,6 +650,7 @@ static void __devexit slic_entry_remove(struct pci_dev *pcidev)
 	}
 	DBG_MSG("slicoss: %s deallocate device\n", __func__);
 	kfree(dev);
+	pci_release_regions(pcidev);
 	DBG_MSG("slicoss: %s EXIT\n", __func__);
 }
 
-- 
1.6.0.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbZAKPZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbZAKPZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 10:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZAKPZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 10:25:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53925 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbZAKPZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 10:25:46 -0500
Date: Sun, 11 Jan 2009 07:25:31 -0800
From: Dirk Hohndel <hohndel@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>, "'Ingo Molnar'" <mingo@elte.hu>
Cc: "Zhao, Yu" <yu.zhao@intel.com>,
       "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'Jesse Barnes'" <jbarnes@virtuousgeek.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>
Subject: [Resend][PATCH] Prevent oops at boot with VT-d
Message-ID: <20090111072531.4cd8ec44@infradead.org>
In-Reply-To: <20090109085807.2144c7d4@infradead.org>
References: <20090108120538.0176d348@infradead.org>
	<20090108214116.GB20506@colo.lackof.org>
	<715D42877B251141A38726ABF5CABF2C018E8FEA77@pdsmsx503.ccr.corp.intel.com>
	<20090108180515.2f279671@infradead.org>
	<20090108205222.2c89dcde@infradead.org>
	<715D42877B251141A38726ABF5CABF2C018E8FECAA@pdsmsx503.ccr.corp.intel.com>
	<20090109070805.525c0de9@infradead.org>
	<49677856.90807@intel.com>
	<20090109083435.2ac20fd5@infradead.org>
	<49677F2B.9000508@intel.com>
	<20090109085807.2144c7d4@infradead.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <hohndel@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This wasn't included in 2.6.29-rc1

With some broken BIOSs when VT-d is enabled, the data structures are
filled incorrectly. This can cause a NULL pointer dereference in very
early boot. 


Signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>
Acked-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/intel-iommu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 235fb7a..3dfecb2 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -438,7 +438,8 @@ static struct intel_iommu *device_to_iommu(u8 bus, u8 devfn)
                        continue;
 
                for (i = 0; i < drhd->devices_cnt; i++)
-                       if (drhd->devices[i]->bus->number == bus &&
+                       if (drhd->devices[i] &&
+                           drhd->devices[i]->bus->number == bus &&
                            drhd->devices[i]->devfn == devfn)
                                return drhd->iommu;
 
-- 
1.6.0.6
-- 
Dirk Hohndel
Intel Open Source Technology Center

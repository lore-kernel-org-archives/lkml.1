Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbZAIQ6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbZAIQ6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZAIQ6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:58:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54069 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZAIQ6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:58:15 -0500
Date: Fri, 9 Jan 2009 08:58:07 -0800
From: Dirk Hohndel <hohndel@infradead.org>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: "Han, Weidong" <weidong.han@intel.com>,
       "'Grant Grundler'" <grundler@parisc-linux.org>,
       "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'Jesse Barnes'" <jbarnes@virtuousgeek.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Arjan van de Ven'" <arjan@infradead.org>
Subject: [PATCH] Prevent oops at boot with VT-d
Message-ID: <20090109085807.2144c7d4@infradead.org>
In-Reply-To: <49677F2B.9000508@intel.com>
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


Resending with appropriate Subject

Signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>
Acked-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/intel-iommu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 235fb7a..3dfecb2 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -438,7 +438,8 @@ static struct intel_iommu *device_to_iommu(u8 bus,
u8 devfn) continue;
 
 		for (i = 0; i < drhd->devices_cnt; i++)
-			if (drhd->devices[i]->bus->number == bus &&
+			if (drhd->devices[i] &&
+			    drhd->devices[i]->bus->number == bus &&
 			    drhd->devices[i]->devfn == devfn)
 				return drhd->iommu;
 
-- 
1.6.0.6

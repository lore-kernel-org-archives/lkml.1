Return-Path: <linux-kernel-owner+w=401wt.eu-S934487AbZLGUJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934487AbZLGUJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758872AbZLGUJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:09:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:12527 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758861AbZLGUJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:09:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,356,1257148800"; 
   d="scan'208";a="520598136"
From: "Tung, Chien Tin" <chien.tin.tung@intel.com>
To: Julia Lawall <julia@diku.dk>
CC: "Latif, Faisal" <faisal.latif@intel.com>,
       Roland Dreier <rolandd@cisco.com>, "Hefty, Sean" <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Mon, 7 Dec 2009 13:09:32 -0700
Subject: RE: [PATCH 3/5] drivers/infiniband: correct size computation
Thread-Topic: [PATCH 3/5] drivers/infiniband: correct size computation
Thread-Index: Acp3d43yESnDgPY5Rgqg7GQ8MDbT3wAAL1gA
Message-ID: <603F8A3875DCE940BA37B49D0A6EA0AE3CE373A4@azsmsx501.amr.corp.intel.com>
References: <Pine.LNX.4.64.0912061015540.20858@ask.diku.dk>
 <603F8A3875DCE940BA37B49D0A6EA0AE3CE36BF4@azsmsx501.amr.corp.intel.com>
 <Pine.LNX.4.64.0912071720520.15109@ask.diku.dk>
 <603F8A3875DCE940BA37B49D0A6EA0AE3CE36C9F@azsmsx501.amr.corp.intel.com>
 <Pine.LNX.4.64.0912072056160.1202@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0912072056160.1202@ask.diku.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Julia Lawall <julia@diku.dk>
>
>The size argument to ioremap_nocache should be the size of desired
>information, not the pointer to it.
>
>The semantic match that finds this problem is as follows:
>(http://coccinelle.lip6.fr/)
>
>// <smpl>
>@expression@
>expression *x;
>@@
>
>x =
> <+...
>*sizeof(x)
>...+>// </smpl>
>
>Signed-off-by: Julia Lawall <julia@diku.dk>
>
>---
> drivers/infiniband/hw/nes/nes.c     |    3 ++-
> 1 files changed, 2 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
>index cbde0cf..95db98f 100644
>--- a/drivers/infiniband/hw/nes/nes.c
>+++ b/drivers/infiniband/hw/nes/nes.c
>@@ -521,7 +521,8 @@ static int __devinit nes_probe(struct pci_dev *pcidev, const struct pci_device_i
> 	spin_lock_init(&nesdev->indexed_regs_lock);
>
> 	/* Remap the PCI registers in adapter BAR0 to kernel VA space */
>-	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0), sizeof(mmio_regs));
>+	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0),
>+				    pci_resource_len(pcidev, BAR_0));
> 	if (mmio_regs == NULL) {
> 		printk(KERN_ERR PFX "Unable to remap BAR0\n");
> 		ret = -EIO;

Acked-by: Chien Tung <chien.tin.tung@intel.com>

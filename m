Return-Path: <linux-kernel-owner+w=401wt.eu-S935030AbZLGQRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935030AbZLGQRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757323AbZLGQRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:17:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:14766 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbZLGQRK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:17:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,356,1257148800"; 
   d="scan'208";a="576377830"
From: "Tung, Chien Tin" <chien.tin.tung@intel.com>
To: Julia Lawall <julia@diku.dk>, "Latif, Faisal" <faisal.latif@intel.com>,
       Roland Dreier <rolandd@cisco.com>, "Hefty, Sean" <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Mon, 7 Dec 2009 09:17:14 -0700
Subject: RE: [PATCH 3/5] drivers/infiniband: correct size computation
Thread-Topic: [PATCH 3/5] drivers/infiniband: correct size computation
Thread-Index: Acp2VMUUUKuvJEelTd+HKk+9yXR6mABAxgQw
Message-ID: <603F8A3875DCE940BA37B49D0A6EA0AE3CE36BF4@azsmsx501.amr.corp.intel.com>
References: <Pine.LNX.4.64.0912061015540.20858@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0912061015540.20858@ask.diku.dk>
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

Thanks for pointing out the bug.  

> 	/* Remap the PCI registers in adapter BAR0 to kernel VA space */
>-	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0), sizeof(mmio_regs));
>+	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0),
>+				    sizeof(*mmio_regs));
> 	if (mmio_regs == NULL) {
> 		printk(KERN_ERR PFX "Unable to remap BAR0\n");
> 		ret = -EIO;

mmio_regs is initialized to NULL at the top of the function so *mmio_regs wouldn't be
a good idea.  Instead of sizeof(*mmio_regs) use pci_resource_len(pcidev, BAR_0).  If
you can recreate the patch with this change I will ack it.

Thanks,


Chien



Return-Path: <linux-kernel-owner+w=401wt.eu-S935315AbZLGQWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935315AbZLGQWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934757AbZLGQWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:22:13 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:42816 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496AbZLGQWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:22:11 -0500
Date: Mon, 7 Dec 2009 17:22:16 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "Tung, Chien Tin" <chien.tin.tung@intel.com>
Cc: "Latif, Faisal" <faisal.latif@intel.com>,
       Roland Dreier <rolandd@cisco.com>, "Hefty, Sean" <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH 3/5] drivers/infiniband: correct size computation
In-Reply-To: <603F8A3875DCE940BA37B49D0A6EA0AE3CE36BF4@azsmsx501.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0912071720520.15109@ask.diku.dk>
References: <Pine.LNX.4.64.0912061015540.20858@ask.diku.dk>
 <603F8A3875DCE940BA37B49D0A6EA0AE3CE36BF4@azsmsx501.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Tung, Chien Tin wrote:

> Thanks for pointing out the bug.  
> 
> > 	/* Remap the PCI registers in adapter BAR0 to kernel VA space */
> >-	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0), sizeof(mmio_regs));
> >+	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0),
> >+				    sizeof(*mmio_regs));
> > 	if (mmio_regs == NULL) {
> > 		printk(KERN_ERR PFX "Unable to remap BAR0\n");
> > 		ret = -EIO;
> 
> mmio_regs is initialized to NULL at the top of the function so 
> *mmio_regs wouldn't be a good idea.  Instead of sizeof(*mmio_regs) use 
> pci_resource_len(pcidev, BAR_0).  If you can recreate the patch with 
> this change I will ack it.

When you say that it isn't a good idea, do you mean that the result is 
wrong, or that it looks odd?  I didn't think sizeof looked at the value, 
but only at the type?

julia

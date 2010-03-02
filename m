Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab0CBJNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 04:13:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:18648 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab0CBJN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 04:13:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,565,1262592000"; 
   d="scan'208";a="777157812"
Subject: Re: [PATCH 2/2] ACPI, APEI, PCIE AER, use general HEST table
 parsing in AER firmware_first setup
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>
In-Reply-To: <4B8CC7BD.5020206@jp.fujitsu.com>
References: <1267494902-7193-1-git-send-email-ying.huang@intel.com>
	 <1267494902-7193-2-git-send-email-ying.huang@intel.com>
	 <4B8CC7BD.5020206@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Mar 2010 17:13:27 +0800
Message-ID: <1267521207.1640.130.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 16:09 +0800, Hidetoshi Seto wrote:
> (2010/03/02 10:55), Huang Ying wrote:
> > ... The firmware_first setup code is moved from PCI core to
> > AER driver too, because it is only AER related.
> (snip)
> > diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
> > index c843a79..cc527c1 100644
> > --- a/drivers/pci/pcie/aer/aerdrv_core.c
> > +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> > @@ -858,6 +858,8 @@ void aer_delete_rootport(struct aer_rpc *rpc)
> >   */
> >  int aer_init(struct pcie_device *dev)
> >  {
> > +	aer_set_firmware_first(dev);
> > +
> >  	if (dev->port->aer_firmware_first) {
> >  		dev_printk(KERN_DEBUG, &dev->device,
> >  			   "PCIe errors handled by platform firmware.\n");
> > diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> > index 2a94309..ccfaf19 100644
> (snip)
> > @@ -935,7 +928,6 @@ int pci_setup_device(struct pci_dev *dev)
> >  	dev->multifunction = !!(hdr_type & 0x80);
> >  	dev->error_state = pci_channel_io_normal;
> >  	set_pcie_port_type(dev);
> > -	set_pci_aer_firmware_first(dev);
> >  
> >  	list_for_each_entry(slot, &dev->bus->slots, list)
> >  		if (PCI_SLOT(dev->devfn) == slot->number)
> 
> The aer_init() will be called for root ports, but not for end point
> devices or so on.  So please remain the firmware_first setup code in
> PCI core.  Otherwise endpoint drivers will get success on call of
> pci_enable_pcie_error_reporting() regardless of the firmware first.

Or we can call firmware_first setup code in
pci_enable_pcie_error_reporting(), because

1. I think AER related code should be put in drivers/pci/pcie/aer
instead of PCI core or drivers/acpi, if it is possible.

2. pci_setup_device is called so early, so that it is hard to do some
HEST related initialization (such as checking bad format) before it.

Best Regards,
Huang Ying



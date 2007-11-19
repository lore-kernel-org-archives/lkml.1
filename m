Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbXKSR5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbXKSR5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 12:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbXKSR5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 12:57:11 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:29203 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbXKSR5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 12:57:09 -0500
Date: Mon, 19 Nov 2007 10:57:07 -0700
From: Alex Chiang <achiang@hp.com>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       gregkh@suse.de, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       kaneshige.kenji@jp.fujitsu.com, pcihpd-discuss@lists.sourceforge.net,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v3] Physical PCI slot objects
Message-ID: <20071119175707.GH7392@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
	gregkh@suse.de, lenb@kernel.org, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	kaneshige.kenji@jp.fujitsu.com, pcihpd-discuss@lists.sourceforge.net,
	linux-acpi@vger.kernel.org
References: <20071117182954.GA25003@ldl.fc.hp.com> <20071119094307.517411a2@appleyard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119094307.517411a2@appleyard>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Kristen Carlson Accardi <kristen.c.accardi@intel.com>:
> On Sat, 17 Nov 2007 11:29:54 -0700
> Alex Chiang <achiang@hp.com> wrote:
> 
> > I have done quite a bit more testing, and verified that this
> > series plays nicely with acpiphp during all stages of the series.
> > Notably, you can modprobe/rmmod acpiphp repeatedly no matter
> > where you are in the series, and no matter whether you have
> > CONFIG_ACPI_PCI_SLOT turned on. The correct entries in
> > /sys/bus/pci/slots/ will appear and disappear, and we correctly
> > register/deregister ACPI slots with the pci_hp core. 
> 
> How does this patch play with non-acpi based hotplug such as the pciehp
> driver 

Not well. :(

pciehp: HPC vendor_id 103c device_id 403b ss_vid 0 ss_did 0
pciehp: pci_hp_register failed with error -17
pciehp: pciehp: slot initialization failed
pciehp: HPC vendor_id 111d device_id 801c ss_vid 0 ss_did 0
pciehp: Can't get irq 0 for the hotplug controller
pciehp: HPC vendor_id 111d device_id 801c ss_vid 0 ss_did 0
pciehp: Can't get irq 0 for the hotplug controller
pciehp: HPC vendor_id 103c device_id 403b ss_vid 0 ss_did 0
pciehp: pci_hp_register failed with error -17
pciehp: pciehp: slot initialization failed

I'll take a look at this today. Thanks for pointing it out.

> or the shpchp driver for example?

This one, I'm not sure on, as I don't have any shpc hardware.
I'll do my best by just looking at the code, but maybe if someone
out there has that hardware, they could let me know what breaks?

Thanks.

/ac


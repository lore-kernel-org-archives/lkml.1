Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbYFYF2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbYFYF2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 01:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYFYF2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 01:28:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:65491 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbYFYF2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 01:28:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,700,1204531200"; 
   d="scan'208";a="581678115"
Subject: Re: [PATCH 2/2] acpi based pci gap caluculation v2
From: Zhao Yakui <yakui.zhao@intel.com>
To: Alok kataria <alokkataria1@gmail.com>
Cc: akataria@vmware.com, lenb@kernel.org, Ingo Molnar <mingo@elte.hu>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <35f686220806242117p4a442982hb459a6b76312f391@mail.gmail.com>
References: <1214333326.27577.28.camel@promb-2n-dhcp368.eng.vmware.com>
	 <1214362159.9800.28.camel@yakui_zhao.sh.intel.com>
	 <35f686220806242117p4a442982hb459a6b76312f391@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 25 Jun 2008 13:39:25 +0800
Message-Id: <1214372365.9800.42.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-24 at 21:17 -0700, Alok kataria wrote:
> On Tue, Jun 24, 2008 at 7:49 PM, Zhao Yakui <yakui.zhao@intel.com> wrote:
> > On Tue, 2008-06-24 at 11:48 -0700, Alok Kataria wrote:
> >> Evaluates the _CRS object under PCI0 looking for producer resources.
> >> Then searches the e820 memory space for a gap within these producer resources.
> >>
> >> Allows us to find a gap for the unclaimed pci resources or MMIO resources
> >> for hotplug devices within the BIOS allowed pci regions.
> >>
> > It seems reasonable.
> > But if the resource obtained from the PCI0 _CRS method is incorrect, we
> > will get the incorrect pci_mem_start.
> 
> Hi Yakui,
> 
> What do you mean by the PCI0 _CRS being incorrect ? Why would the BIOS
> give a incorrect _CRS object ?
> Also we don't just take the value given from the _CRS method, we still
> read the e820_map to search for an unallocated resource. So even if
> (by chance) the _CRS method returns incorrect value we would still
> figure out if there is a collision with an already allocated resource.
In the patch the address obtained from the _CRS object will be passed
into the function of e820_search_gap. In such case maybe we will get the
pci_mem_start different with the e820_setup_gap. 

> >
> > At the same time after the patch is applied, pci_mem_start will be
> > parsed in two different ways.
> 
> Yes pci_mem_start would be initialized in 2 different ways but we
> still have to parse the e820_map the old way because there could be
> systems without ACPI.
> 
> > If the result is different, maybe the
> > incorrect pci_mem_start will be used.
> 
> Yeah, The result is different in my case. Though my BIOS reserves
> hotpluggable memory region, kernel doesn't respect that right now and
> just parses the e820_map to calculate the gap and pci_mem_start value.
> I have explained the problem in this mail.
> 
> http://marc.info/?l=linux-acpi&m=121391675711763&w=2
> 
> Maybe nobody has seen this problem yet, because there are no systems
> out there with less than 4GB memory to start with and which allow
> memory hotplug.
> 
> But still i don't understand what do you mean by, we can get incorrect
> pci_mem_start, in which case ?

In the function of setup_arch the pci_mem_start will be parsed by
searching the e820 table.  After the patch is applied, we will parse the
pci_mem_start again in the function of pci_acpi_scan_init and it will
override the value parsed in the function of setup_arch. If the
pci_mem_start is incorrect in the second case, maybe it will have side
effect.

Thanks.
   Yakui.

> Thanks,
> Alok
> >
> > Best regards.
> >  Yakui
> >>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >


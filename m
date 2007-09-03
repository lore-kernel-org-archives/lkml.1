Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbXICQsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbXICQsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 12:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXICQsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 12:48:18 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:59015 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbXICQsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 12:48:17 -0400
Date: Mon, 3 Sep 2007 09:48:15 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Robert Richter <robert.richter@amd.com>
cc: Andi Kleen <ak@suse.de>, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/5] x86: Set PCI config space size to extended for AMD
 Barcelona
In-Reply-To: <20070903081736.805623000@amd.com>
Message-ID: <Pine.LNX.4.64.0709030930150.3502@twinlark.arctic.org>
References: <20070903081736.288288000@amd.com> <20070903081736.805623000@amd.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

it's so very unfortunate the PCI standard has no feature bit to indicate 
the presence of ECS.

FWIW in my testing on a range of machines spanning 7 or 8 years i could 
read config space reg 256... and get 0xffffffff when the device didn't 
support ECS, and get valid data when the device did support ECS... granted 
there may be some system out there which behaves really badly when you do 
this.

perhaps someone could write a userspace program and test that concept on a 
far wider range of machines.

-dean

On Mon, 3 Sep 2007, Robert Richter wrote:

> This patch sets the config space size for AMD Barcelona PCI devices to
> 4096.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> 
> ---
>  arch/i386/pci/fixup.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> Index: linux-2.6/arch/i386/pci/fixup.c
> ===================================================================
> --- linux-2.6.orig/arch/i386/pci/fixup.c
> +++ linux-2.6/arch/i386/pci/fixup.c
> @@ -8,6 +8,7 @@
>  #include <linux/init.h>
>  #include "pci.h"
>  
> +#define PCI_CFG_SPACE_EXP_SIZE	4096
>  
>  static void __devinit pci_fixup_i450nx(struct pci_dev *d)
>  {
> @@ -444,3 +445,16 @@ static void __devinit pci_siemens_interr
>  }
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SIEMENS, 0x0015,
>  			  pci_siemens_interrupt_controller);
> +
> +/*
> + * Extend size of PCI configuration space for AMD CPUs
> + */
> +static void __devinit pci_ext_cfg_space_access(struct pci_dev *dev)
> +{
> +	dev->cfg_size = PCI_CFG_SPACE_EXP_SIZE;
> +}
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_FAM10H_HT,   pci_ext_cfg_space_access);
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_FAM10H_MAP,  pci_ext_cfg_space_access);
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_FAM10H_DRAM, pci_ext_cfg_space_access);
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_FAM10H_MISC, pci_ext_cfg_space_access);
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_FAM10H_LINK, pci_ext_cfg_space_access);
> 
> -- 
> AMD Saxony, Dresden, Germany
> Operating System Research Center
> email: robert.richter@amd.com
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

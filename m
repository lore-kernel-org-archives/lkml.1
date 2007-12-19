Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbXLSXPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbXLSXPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 18:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbXLSXPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 18:15:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34927 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909AbXLSXP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 18:15:29 -0500
Date: Wed, 19 Dec 2007 15:04:47 -0800
From: Greg KH <gregkh@suse.de>
To: tcamuso@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       prarit@redhat.com
Subject: Re: [PATCH 1/5]PCI: x86 MMCONFIG: introduce PCI_USING_MMCONF
Message-ID: <20071219230447.GA24219@suse.de>
References: <20071219221746.20362.39243.sendpatchset@dhcp83-188.boston.redhat.com> <20071219221751.20362.23451.sendpatchset@dhcp83-188.boston.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219221751.20362.23451.sendpatchset@dhcp83-188.boston.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 05:17:51PM -0500, tcamuso@redhat.com wrote:
> commit d1f2a573ca7083d237cfc354f42e089de9fa0f0b
> Author: Tony Camuso <tony.camuso@hp.com>
> Date:   Wed Dec 19 15:33:53 2007 -0500
> 
>     Introduces a flag bit to arch/x86/pci/pci.h to indicate that
>     MMCONFIG is the system-wide default PCI config access mechanisim.
>     
>     Function pci_mmcfg_init() in arch/x86/pci/mmconfig-shared.c sets
>     the bit in the pci_probe mask when MMCONFIG has been successfully
>     initialized for the platform.
>     
>     Signed-off-by: Tony Camuso tony.camuso@hp.com
> 
> diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
> index 4df637e..fc0f866 100644
> --- a/arch/x86/pci/mmconfig-shared.c
> +++ b/arch/x86/pci/mmconfig-shared.c
> @@ -274,7 +274,8 @@ void __init pci_mmcfg_init(int type)
>  			unreachable_devices();
>  		if (known_bridge)
>  			pci_mmcfg_insert_resources(IORESOURCE_BUSY);
> -		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
> +		pci_probe = pci_probe & ~PCI_PROBE_MASK;
> +		pci_probe = pci_probe | PCI_PROBE_MMCONF | PCI_USING_MMCONF;
>  	} else {
>  		/*
>  		 * Signal not to attempt to insert mmcfg resources because
> diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
> index ac56d39..53f4051 100644
> --- a/arch/x86/pci/pci.h
> +++ b/arch/x86/pci/pci.h
> @@ -28,6 +28,7 @@
>  #define PCI_ASSIGN_ALL_BUSSES	0x4000
>  #define PCI_CAN_SKIP_ISA_ALIGN	0x8000
>  #define PCI_USE__CRS		0x10000
> +#define PCI_USING_MMCONF	0x20000
>  
>  extern unsigned int pci_probe;
>  extern unsigned long pirq_table_addr;
> @@ -39,6 +40,8 @@ enum pci_bf_sort_state {
>  	pci_dmi_bf,
>  };
>  
> +extern struct pci_ops pci_legacy_ops; 	/* direct.c */

This isn't needed in this patch at all, and might make the compiler
confused if you were to build with only this patch present :(

thanks,

greg k-h

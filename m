Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbXLSXQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbXLSXQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 18:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbXLSXPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 18:15:43 -0500
Received: from ns.suse.de ([195.135.220.2]:35382 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757289AbXLSXPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 18:15:41 -0500
Date: Wed, 19 Dec 2007 15:14:22 -0800
From: Greg KH <gregkh@suse.de>
To: tcamuso@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       prarit@redhat.com
Subject: Re: [PATCH 4/5]PCI: x86 MMCONFIG: introduce pcibios_fix_bus_scan()
Message-ID: <20071219231422.GD24219@suse.de>
References: <20071219221746.20362.39243.sendpatchset@dhcp83-188.boston.redhat.com> <20071219221806.20362.25964.sendpatchset@dhcp83-188.boston.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219221806.20362.25964.sendpatchset@dhcp83-188.boston.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 05:18:06PM -0500, tcamuso@redhat.com wrote:
> commit ab28e1157e970f711c8451b66b3f940ec092db9d
> Author: Tony Camuso <tony.camuso@hp.com>
> Date:   Wed Dec 19 15:51:48 2007 -0500
> 
>     Introduces the x86 arch-specific routine that will determine whether
>     a device responds correctly to MMCONFIG accesses. This routine is
>     given the generic name pcibios_fix_bus_scan_quirk()
>     
>     The comment at the top of the routine explains its logic.
>     
>     Signed-off-by: Tony Camuso tony.camuso@hp.com
> 
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index 8627463..9b1742d 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -525,3 +525,64 @@ struct pci_bus *pci_scan_bus_with_sysdata(int busno)
>  
>  	return bus;
>  }
> +
> +/**
> + * This routine traps devices not correctly responding to MMCONFIG access.
> + * For each device on the current bus, compare a mmconf read of the
> + * vendor/device dword with a legacy PCI config read. If they're not the same,
> + * the bus serving this device must use legacy PCI config accesses instead of
> + * mmconf, as must all buses descending from this bus.
> + */

Don't user kerneldoc comments for functions that are not really in
kerneldoc format.  Just a simple /* at the start will be fine, otherwise
the tools get confused.

So what happens today with these "broken" devices?  Does simply reading
the vendor id not work properly?  What specific hardware does not work
today that this is trying to fix?

I think this patch set needs a bit of reworking at the very least...

thanks,

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZA0ApT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZA0ApT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 19:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZA0ApF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 19:45:05 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:58074 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbZA0ApE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 19:45:04 -0500
Message-ID: <497E5904.9030407@oracle.com>
Date: Mon, 26 Jan 2009 16:44:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       kristen.c.accardi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pcie hotplug: Change link order of pciehp
References: <20090127003743.GA27711@srcf.ucam.org>
In-Reply-To: <20090127003743.GA27711@srcf.ucam.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.497E5907.0259:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> Some hardware exposes PCIE slots in such a way that they can be claimed by
> either the acpiphp or pciehp driver. pciehp is the preferred driver if the
> firmware allows the OS to claim control via the _OSC method so should be
> loaded first - if it fails to bind (either due to a missing _OSC method or
> the firmware refusing to hand off control) then we can fall back to acpiphp or
> a vendor-specific driver.
> 
> This patch simply changes the link order to ensure that pciehp will be
> initialised before acpiphp if both are statically built into the kernel.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Hi,
I'd prefer to have a comment in the Makefile (not just in git)
that link order is important for those 2 drivers and why.

We do that in several other similar situations and I believe that
having it in the Makefile is preferable.

> --- 
> 
> diff --git a/drivers/pci/hotplug/Makefile b/drivers/pci/hotplug/Makefile
> index e31fb91..a024b44 100644
> --- a/drivers/pci/hotplug/Makefile
> +++ b/drivers/pci/hotplug/Makefile
> @@ -5,11 +5,11 @@
>  obj-$(CONFIG_HOTPLUG_PCI)		+= pci_hotplug.o
>  obj-$(CONFIG_HOTPLUG_PCI_COMPAQ)	+= cpqphp.o
>  obj-$(CONFIG_HOTPLUG_PCI_IBM)		+= ibmphp.o
> +obj-$(CONFIG_HOTPLUG_PCI_PCIE)		+= pciehp.o
>  obj-$(CONFIG_HOTPLUG_PCI_ACPI)		+= acpiphp.o
>  obj-$(CONFIG_HOTPLUG_PCI_ACPI_IBM)	+= acpiphp_ibm.o
>  obj-$(CONFIG_HOTPLUG_PCI_CPCI_ZT5550)	+= cpcihp_zt5550.o
>  obj-$(CONFIG_HOTPLUG_PCI_CPCI_GENERIC)	+= cpcihp_generic.o
> -obj-$(CONFIG_HOTPLUG_PCI_PCIE)		+= pciehp.o
>  obj-$(CONFIG_HOTPLUG_PCI_SHPC)		+= shpchp.o
>  obj-$(CONFIG_HOTPLUG_PCI_RPA)		+= rpaphp.o
>  obj-$(CONFIG_HOTPLUG_PCI_RPA_DLPAR)	+= rpadlpar_io.o
> 


-- 
~Randy

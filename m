Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbZD3AG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbZD3AG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbZD3AGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:06:15 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39303 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbZD3AGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:06:14 -0400
Date: Wed, 29 Apr 2009 17:06:11 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Gary Hade <garyhade@us.ibm.com>,
       Alex Chiang <achiang@hp.com>, linux-acpi@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] x86/pci: do assign root bus res if _CRS is used
Message-ID: <20090430000611.GA22030@us.ibm.com>
References: <49ED22EC.2040204@kernel.org> <200904271344.04099.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904271344.04099.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 01:44:01PM -0600, Bjorn Helgaas wrote:
> On Monday 20 April 2009 07:35:40 pm Yinghai Lu wrote:
> > it wil be overwriten later if _CRS is used, so don't bother to set it.
> > 
> > [ Impact: cleanup ]
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > 
> > ---
> >  arch/x86/pci/amd_bus.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > Index: linux-2.6/arch/x86/pci/amd_bus.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/pci/amd_bus.c
> > +++ linux-2.6/arch/x86/pci/amd_bus.c
> > @@ -100,6 +100,10 @@ void x86_pci_root_bus_res_quirks(struct
> >  	int j;
> >  	struct pci_root_info *info;
> >  
> > +	/* don't go for it if _CRS is used */
> > +	if (pci_probe & PCI_USE__CRS)
> > +		return;
> > +
> >  	/* if only one root bus, don't need to anything */
> >  	if (pci_root_num < 2)
> >  		return;
> 
> This isn't a comment on this patch per se.
> 
> I am concerned about the fact that "pci=use_crs" is not the default.
> >From the changelog of 62f420f8282, it sounds like you have to boot an
> IBM x3850 with "pci=use_crs" to make hot-plug work, even though ACPI
> tells us everything we need to know.  That's backwards.
> 
> We shouldn't need an option to tell Linux that the firmware is
> trustworthy.  We should have an option to *ignore* it for the times
> when we trip over something broken and haven't figured out a way to
> work around it yet.

Sorry, I am behind on my email and just noticed this.

When I posted the patches to add "pci=use_crs" it was only
needed to enable PCI hotplug on a subset of our systems.
At that time it was not apparent that others were interested. 
I was also concerned that real or anticipated breakage on
on other systems might delay or prevent acceptance.

As long as there is an option to disable it I am also in 
favor of trying to make it the default.

Thanks!

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc


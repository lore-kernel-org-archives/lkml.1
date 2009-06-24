Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbZFXQNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbZFXQNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZFXQNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:13:13 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41416 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbZFXQNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:13:13 -0400
Date: Wed, 24 Jun 2009 09:13:06 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Gary Hade <garyhade@us.ibm.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
Message-ID: <20090624161306.GC7239@us.ibm.com>
References: <4A418254.9050607@lwfinger.net> <1245845787.3093.3.camel@localhost.localdomain> <4A423686.8050905@lwfinger.net> <alpine.LFD.2.00.0906241715500.2767@localhost.localdomain> <1245859068.3216.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245859068.3216.5.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 09:27:48PM +0530, Jaswinder Singh Rajput wrote:
> On Wed, 2009-06-24 at 17:19 +0200, Thomas Gleixner wrote:
> > Larry,
> > 
> > On Wed, 24 Jun 2009, Larry Finger wrote:
> > > For the record, the printout from the patch results in the following:
> > > 
> > > PCI: Failed to allocate 0xd0000-0xd3fff from PCI mem for PCI Bus 0000:00
> > > PCI: Failed to allocate 0xec000-0xeffff from PCI mem for PCI Bus
> > > 0000:00 due to _CRS returning more than 13 resource descriptors
> > > PCI: Failed to allocate 0xf0000-0xfffff from PCI mem for PCI Bus
> > > 0000:00 due to _CRS returning more than 13 resource descriptors
> > > PCI: Failed to allocate 0xc0000000-0xfebfffff from PCI mem for PCI Bus
> > > 0000:00 due to _CRS returning more than 13 resource descriptors
> > 
> > can you please the patch below instead of the other one ?
> > 
> > Thanks,
> > 
> > 	tglx
> > ---
> > diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> > index 16c3fda..39a0cce 100644
> > --- a/arch/x86/pci/acpi.c
> > +++ b/arch/x86/pci/acpi.c
> > @@ -99,7 +99,6 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
> >  			"%d resource descriptors\n", (unsigned long) res->start,
> >  			(unsigned long) res->end, root->name, info->name,
> >  			max_root_bus_resources);
> > -		info->res_num++;
> >  		return AE_OK;
> >  	}
> >  
> 
> This fails and system does not boot, I already tested this patch 8 hours
> ago.

I think the resource array needs to be larger.  Can you try
the below patch?

Gary

--- linux-2.6.30-rc8/include/linux/pci.h.ORIG	2009-06-24 09:03:41.000000000 -0700
+++ linux-2.6.30-rc8/include/linux/pci.h	2009-06-24 09:06:50.000000000 -0700
@@ -319,7 +319,7 @@ static inline void pci_add_saved_cap(str
 }
 
 #ifndef PCI_BUS_NUM_RESOURCES
-#define PCI_BUS_NUM_RESOURCES	16
+#define PCI_BUS_NUM_RESOURCES	20
 #endif
 
 #define PCI_REGION_FLAG_MASK	0x0fU	/* These bits of resource flags tell us the PCI region flags */

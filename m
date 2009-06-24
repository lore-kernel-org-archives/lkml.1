Return-Path: <linux-kernel-owner+w=401wt.eu-S1758663AbZFXS26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663AbZFXS26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZFXS2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:28:50 -0400
Received: from outbound-mail-21.bluehost.com ([69.89.21.16]:33356 "HELO
	outbound-mail-21.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752051AbZFXS2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:28:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=DCTybd3qCwtpSee7fwHLxX0iNP6zHKZnjo/Max8o3hZeLbMJ8OoqhYpUCr92jHFCiaGOv1Dj4hZJvH8FvY22R+1FHOfOUmIAHGDhfQRlbv7w1koewYNIfhlOy0L3yVZy;
Date: Wed, 24 Jun 2009 11:28:49 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Gary Hade <garyhade@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
Message-ID: <20090624112849.55b38fff@jbarnes-g45>
In-Reply-To: <20090624175513.GE7239@us.ibm.com>
References: <4A418254.9050607@lwfinger.net>
	<1245845787.3093.3.camel@localhost.localdomain>
	<4A423686.8050905@lwfinger.net>
	<alpine.LFD.2.00.0906241715500.2767@localhost.localdomain>
	<1245859068.3216.5.camel@localhost.localdomain>
	<20090624161306.GC7239@us.ibm.com>
	<1245861219.3216.15.camel@localhost.localdomain>
	<20090624094411.08fc66e6@jbarnes-g45>
	<20090624175513.GE7239@us.ibm.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 10:55:13 -0700
Gary Hade <garyhade@us.ibm.com> wrote:

> On Wed, Jun 24, 2009 at 09:44:11AM -0700, Jesse Barnes wrote:
> > On Wed, 24 Jun 2009 22:03:39 +0530
> > Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > On Wed, 2009-06-24 at 09:13 -0700, Gary Hade wrote:
> > > > On Wed, Jun 24, 2009 at 09:27:48PM +0530, Jaswinder Singh Rajput
> > > > wrote:
> > > > > On Wed, 2009-06-24 at 17:19 +0200, Thomas Gleixner wrote:
> > > > > > Larry,
> > > > > > 
> > > > > > On Wed, 24 Jun 2009, Larry Finger wrote:
> > > > > > > For the record, the printout from the patch results in the
> > > > > > > following:
> > > > > > > 
> > > > > > > PCI: Failed to allocate 0xd0000-0xd3fff from PCI mem for
> > > > > > > PCI Bus 0000:00 PCI: Failed to allocate 0xec000-0xeffff
> > > > > > > from PCI mem for PCI Bus 0000:00 due to _CRS returning
> > > > > > > more than 13 resource descriptors PCI: Failed to allocate
> > > > > > > 0xf0000-0xfffff from PCI mem for PCI Bus 0000:00 due to
> > > > > > > _CRS returning more than 13 resource descriptors PCI:
> > > > > > > Failed to allocate 0xc0000000-0xfebfffff from PCI mem for
> > > > > > > PCI Bus 0000:00 due to _CRS returning more than 13
> > > > > > > resource descriptors
> > > > > > 
> > > > > > can you please the patch below instead of the other one ?
> > > > > > 
> > > > > > Thanks,
> > > > > > 
> > > > > > 	tglx
> > > > > > ---
> > > > > > diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> > > > > > index 16c3fda..39a0cce 100644
> > > > > > --- a/arch/x86/pci/acpi.c
> > > > > > +++ b/arch/x86/pci/acpi.c
> > > > > > @@ -99,7 +99,6 @@ setup_resource(struct acpi_resource
> > > > > > *acpi_res, void *data) "%d resource descriptors\n",
> > > > > > (unsigned long) res->start, (unsigned long) res->end,
> > > > > > root->name, info->name, max_root_bus_resources);
> > > > > > -		info->res_num++;
> > > > > >  		return AE_OK;
> > > > > >  	}
> > > > > >  
> > > > > 
> > > > > This fails and system does not boot, I already tested this
> > > > > patch 8 hours ago.
> > > > 
> > > > I think the resource array needs to be larger.  Can you try
> > > > the below patch?
> > > > 
> > > > Gary
> > > > 
> > > > --- linux-2.6.30-rc8/include/linux/pci.h.ORIG	2009-06-24
> > > > 09:03:41.000000000 -0700 +++
> > > > linux-2.6.30-rc8/include/linux/pci.h	2009-06-24
> > > > 09:06:50.000000000 -0700 @@ -319,7 +319,7 @@ static inline void
> > > > pci_add_saved_cap(str } 
> > > >  #ifndef PCI_BUS_NUM_RESOURCES
> > > > -#define PCI_BUS_NUM_RESOURCES	16
> > > > +#define PCI_BUS_NUM_RESOURCES	20
> > > >  #endif
> > > >  
> > > >  #define PCI_REGION_FLAG_MASK	0x0fU	/* These bits
> > > > of resource flags tell us the PCI region flags */
> > > 
> > > 
> > > Larry already suggested PCI_BUS_NUM_RESOURCES to 24 in his patch
> > > (check first reply from him).
> > > 
> > > Then what is the point of removing last 3 and then adding 3 or
> > > more resources, so patch f9cde5f lost its purpose, best case will
> > > be to revert f9cde5f as it also removed :
> > > 
> > > if (info->res_num >= PCI_BUS_NUM_RESOURCES)
> > >                 return AE_OK;
> > > 
> > > which is required in any case.
> > 
> > Yeah, I missed that too...  Gary how do you feel about that as the
> > real fix?  Would it be safe to make this a fairly high value like
> > 64?  Or should we try to do something more flexible...
> 
> Sorry I missed the 16->24 change and other good information
> in Larry's earlier message.  There were 17 occurrences of the
> "PCI: transparent bridge..." message that Larry added which 
> indicates that _CRS returned 17 resources.  This is 4 more
> than the current 13 maximum which explains the problem. 
> I believe Larry's 8 slot increase (16->24) in the array size
> provided 4 slots beyond what is needed for Larry's box but
> an even higher ceiling would certainly feel more comfortable.
> I was thinking 32 but 64 would be better if there aren't any
> downsides elsewhere of making the array that big.

Just chatting with Len about this; apparently the PNPACPI layer ran
into something similar awhile back, and they had to go to a variable
sized list of resources, due to weird machines with huge numbers of
resources.  Matthew says he's got an idea about how to fix this up; if
that doesn't work out I'll see about making the bus resource array into
a list instead.

-- 
Jesse Barnes, Intel Open Source Technology Center

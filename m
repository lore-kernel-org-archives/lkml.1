Return-Path: <linux-kernel-owner+w=401wt.eu-S1760952AbZFXQoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbZFXQoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbZFXQoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:44:12 -0400
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:52602 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753969AbZFXQoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:44:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=A2P5A1sAulFu/1WzD2lUS27yIfh972xCRaKPL6fabK15Bhkx693bAoGC0iTm+Lxzc+igyMcYQTaVD8/gxQScZeRUec6eLy3JsNPpkY9z5bO4f1ixuDwsjwCGLFe8osLS;
Date: Wed, 24 Jun 2009 09:44:11 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Gary Hade <garyhade@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
Message-ID: <20090624094411.08fc66e6@jbarnes-g45>
In-Reply-To: <1245861219.3216.15.camel@localhost.localdomain>
References: <4A418254.9050607@lwfinger.net>
	<1245845787.3093.3.camel@localhost.localdomain>
	<4A423686.8050905@lwfinger.net>
	<alpine.LFD.2.00.0906241715500.2767@localhost.localdomain>
	<1245859068.3216.5.camel@localhost.localdomain>
	<20090624161306.GC7239@us.ibm.com>
	<1245861219.3216.15.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 22:03:39 +0530
Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Wed, 2009-06-24 at 09:13 -0700, Gary Hade wrote:
> > On Wed, Jun 24, 2009 at 09:27:48PM +0530, Jaswinder Singh Rajput
> > wrote:
> > > On Wed, 2009-06-24 at 17:19 +0200, Thomas Gleixner wrote:
> > > > Larry,
> > > > 
> > > > On Wed, 24 Jun 2009, Larry Finger wrote:
> > > > > For the record, the printout from the patch results in the
> > > > > following:
> > > > > 
> > > > > PCI: Failed to allocate 0xd0000-0xd3fff from PCI mem for PCI
> > > > > Bus 0000:00 PCI: Failed to allocate 0xec000-0xeffff from PCI
> > > > > mem for PCI Bus 0000:00 due to _CRS returning more than 13
> > > > > resource descriptors PCI: Failed to allocate 0xf0000-0xfffff
> > > > > from PCI mem for PCI Bus 0000:00 due to _CRS returning more
> > > > > than 13 resource descriptors PCI: Failed to allocate
> > > > > 0xc0000000-0xfebfffff from PCI mem for PCI Bus 0000:00 due to
> > > > > _CRS returning more than 13 resource descriptors
> > > > 
> > > > can you please the patch below instead of the other one ?
> > > > 
> > > > Thanks,
> > > > 
> > > > 	tglx
> > > > ---
> > > > diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> > > > index 16c3fda..39a0cce 100644
> > > > --- a/arch/x86/pci/acpi.c
> > > > +++ b/arch/x86/pci/acpi.c
> > > > @@ -99,7 +99,6 @@ setup_resource(struct acpi_resource
> > > > *acpi_res, void *data) "%d resource descriptors\n", (unsigned
> > > > long) res->start, (unsigned long) res->end, root->name,
> > > > info->name, max_root_bus_resources);
> > > > -		info->res_num++;
> > > >  		return AE_OK;
> > > >  	}
> > > >  
> > > 
> > > This fails and system does not boot, I already tested this patch
> > > 8 hours ago.
> > 
> > I think the resource array needs to be larger.  Can you try
> > the below patch?
> > 
> > Gary
> > 
> > --- linux-2.6.30-rc8/include/linux/pci.h.ORIG	2009-06-24
> > 09:03:41.000000000 -0700 +++
> > linux-2.6.30-rc8/include/linux/pci.h	2009-06-24
> > 09:06:50.000000000 -0700 @@ -319,7 +319,7 @@ static inline void
> > pci_add_saved_cap(str } 
> >  #ifndef PCI_BUS_NUM_RESOURCES
> > -#define PCI_BUS_NUM_RESOURCES	16
> > +#define PCI_BUS_NUM_RESOURCES	20
> >  #endif
> >  
> >  #define PCI_REGION_FLAG_MASK	0x0fU	/* These bits of
> > resource flags tell us the PCI region flags */
> 
> 
> Larry already suggested PCI_BUS_NUM_RESOURCES to 24 in his patch
> (check first reply from him).
> 
> Then what is the point of removing last 3 and then adding 3 or more
> resources, so patch f9cde5f lost its purpose, best case will be to
> revert f9cde5f as it also removed :
> 
> if (info->res_num >= PCI_BUS_NUM_RESOURCES)
>                 return AE_OK;
> 
> which is required in any case.

Yeah, I missed that too...  Gary how do you feel about that as the real
fix?  Would it be safe to make this a fairly high value like 64?  Or
should we try to do something more flexible...

-- 
Jesse Barnes, Intel Open Source Technology Center

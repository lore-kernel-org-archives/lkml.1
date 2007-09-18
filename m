Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbXIRTOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbXIRTOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbXIRTOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:14:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:32869 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbXIRTOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:14:22 -0400
Date: Tue, 18 Sep 2007 12:17:40 -0700
From: Greg KH <greg@kroah.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1
Message-ID: <20070918191740.GC11083@kroah.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46EF96CC.1080807@linux.vnet.ibm.com> <20070918022739.f25c2846.akpm@linux-foundation.org> <alpine.LFD.0.999.0709181504030.21091@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709181504030.21091@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 03:04:48PM +0530, Satyam Sharma wrote:
> 
> 
> On Tue, 18 Sep 2007, Andrew Morton wrote:
> 
> > On Tue, 18 Sep 2007 14:43:48 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> > 
> > > Andrew Morton wrote:
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/
> > > >
> > > > 2.6.23-rc6-mm1 is a 29MB diff against 2.6.23-rc6.
> > > >
> > > >   
> > > <snip>
> > > 
> > > Hi Andrew,
> > > 
> > > The 2.6.23-rc6-mm1build fails at
> > > 
> > >   CC      drivers/pci/hotplug/rpadlpar_core.o
> > >   CC      drivers/pci/hotplug/rpadlpar_sysfs.o
> > > drivers/pci/hotplug/rpadlpar_sysfs.c:132: error: unknown field `name' specified in initializer
> > > drivers/pci/hotplug/rpadlpar_sysfs.c: In function `dlpar_sysfs_init':
> > > drivers/pci/hotplug/rpadlpar_sysfs.c:142: error: structure has no member named `name'
> > > make[3]: *** [drivers/pci/hotplug/rpadlpar_sysfs.o] Error 1
> > > make[2]: *** [drivers/pci/hotplug] Error 2
> > > make[1]: *** [drivers/pci] Error 2
> > > make: *** [drivers] Error 2
> > > 
> > 
> > Probably this:
> > 
> > --- a/drivers/pci/hotplug/rpadlpar_sysfs.c~a
> > +++ a/drivers/pci/hotplug/rpadlpar_sysfs.c
> > @@ -129,8 +129,7 @@ struct kobj_type ktype_dlpar_io = {
> >  };
> >  
> >  struct kset dlpar_io_kset = {
> > -	.kobj = {.name = DLPAR_KOBJ_NAME,
> > -		 .ktype = &ktype_dlpar_io,
> > +	.kobj = {.ktype = &ktype_dlpar_io,
> >  		 .parent = &pci_hotplug_slots_subsys.kobj},
> >  	.ktype = &ktype_dlpar_io,
> >  };
> > _
> > 
> > But I'm fed up with fixing that patch.  It's Greg's turn.
> 
> But wait ... isn't that a statically-allocated kobject, which were
> supposed to be "naughty" in the first place?

Yes it is, if you want to dynamically create it, please do.  But there's
a lot of these in the kernel and I didn't want to break _all_ of them at
once, it's a multiple-stage set of patches to get us there (this name
array change is just the first in the set of these steps...)

thanks,

greg k-h

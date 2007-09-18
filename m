Return-Path: <linux-kernel-owner+w=401wt.eu-S932200AbXIRQ70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbXIRQ70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 12:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759527AbXIRQ7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 12:59:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42743 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759627AbXIRQ7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 12:59:10 -0400
Date: Tue, 18 Sep 2007 09:53:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>, linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1
Message-Id: <20070918095323.bae6c278.akpm@linux-foundation.org>
In-Reply-To: <46EFBF9E.6060208@linux.vnet.ibm.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<46EF96CC.1080807@linux.vnet.ibm.com>
	<20070918093444.GB973@shadowen.org>
	<1190109772.6403.79.camel@localhost.localdomain>
	<46EFBF9E.6060208@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 17:37:58 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Benjamin Herrenschmidt wrote:
> > On Tue, 2007-09-18 at 10:34 +0100, Andy Whitcroft wrote:
> >   
> >> On Tue, Sep 18, 2007 at 02:43:48PM +0530, Kamalesh Babulal wrote:
> >>     
> >>> Andrew Morton wrote:
> >>>       
> >>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/
> >>>>
> >>>> 2.6.23-rc6-mm1 is a 29MB diff against 2.6.23-rc6.
> >>>>
> >>>>  
> >>>>         
> >>> <snip>
> >>>
> >>> Hi Andrew,
> >>>
> >>> The 2.6.23-rc6-mm1build fails at
> >>>
> >>>  CC      drivers/pci/hotplug/rpadlpar_core.o
> >>>  CC      drivers/pci/hotplug/rpadlpar_sysfs.o
> >>> drivers/pci/hotplug/rpadlpar_sysfs.c:132: error: unknown field `name' 
> >>> specified in initializer
> >>> drivers/pci/hotplug/rpadlpar_sysfs.c: In function `dlpar_sysfs_init':
> >>> drivers/pci/hotplug/rpadlpar_sysfs.c:142: error: structure has no member 
> >>> named `name'
> >>> make[3]: *** [drivers/pci/hotplug/rpadlpar_sysfs.o] Error 1
> >>> make[2]: *** [drivers/pci/hotplug] Error 2
> >>> make[1]: *** [drivers/pci] Error 2
> >>> make: *** [drivers] Error 2
> >>>       
> >> This seems to be occuring across a number of the powerpc systems we test
> >> with.  That driver is a power dynamic lpar IO partitioning driver.
> >>
> >> Relevant Cc: added.
> >>     
> >
> > That's because somebody is breaking sysfs/kobject interfaces without
> > fixing all users :-) (Fair enough... it's just that we need to make sure
> > whoever takes care of that driver nowadays is aware of the breakage).
> >
> > Ben.
> >   
> Hi Andrew,
> 
> Using the kobject_set_name function to set the kobject k_name.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> ---
> --- linux-2.6.23-rc6/drivers/pci/hotplug/rpadlpar_sysfs.c       
> 2007-09-18 14:56:05.000000000 +0530
> +++ linux-2.6.23-rc6/drivers/pci/hotplug/~rpadlpar_sysfs.c      
> 2007-09-18 16:51:55.000000000 +0530
> @@ -129,17 +129,17 @@ struct kobj_type ktype_dlpar_io = {
>  };
>  
>  struct kset dlpar_io_kset = {
> -       .kobj = {.name = DLPAR_KOBJ_NAME,
> -                .ktype = &ktype_dlpar_io,
> -                .parent = &pci_hotplug_slots_subsys.kobj},
> +        .kobj = {.ktype = &ktype_dlpar_io,
> +                 .parent = &pci_hotplug_slots_subsys.kobj},
>         .ktype = &ktype_dlpar_io,
>  };
>  
>  int dlpar_sysfs_init(void)
>  {
> +       kobject_set_name(&dlpar_io_kset.kobj, DLPAR_KOBJ_NAME);
>         if (kset_register(&dlpar_io_kset)) {
>                 printk(KERN_ERR "rpadlpar_io: cannot register kset for 
> %s\n",
> -                               dlpar_io_kset.kobj.name);
> +                               dlpar_io_kset.kobj.k_name);
>                 return -EINVAL;
>         }
> 

Thanks.

Your email client replaces tabs with spaces, and is performing wordwrapping.

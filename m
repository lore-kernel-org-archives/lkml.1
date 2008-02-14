Return-Path: <linux-kernel-owner+w=401wt.eu-S1765132AbYBNK2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765132AbYBNK2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 05:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYBNK23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 05:28:29 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:61064 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbYBNK21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 05:28:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sAHXJcuIQz+m/R8n02oqf+7Rni7XcQlLHcDN+TRC8+wKAqAZ+T3iemGtEmL8FpDVfwEloeldSD/YPhdL8xht/zbzYD3R7Up+qzX1Wu965W1zm1H1iX3JAPDZUwTo4snc6RAIthIl1LDwk7lzqSvvDKbPyZk68QXdWiCSdRzv584=
Message-ID: <86802c440802140228q5f6a606cyee01c711fd349571@mail.gmail.com>
Date: Thu, 14 Feb 2008 02:28:26 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.26-git0: IDE oops during boot
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Nish Aravamudan" <nish.aravamudan@gmail.com>,
       "Pavel Machek" <pavel@ucw.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       ananth@in.ibm.com, "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <47B40DF2.10009@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080206105334.GA3664@elf.ucw.cz>
	 <200802112035.39462.bzolnier@gmail.com>
	 <47B16113.1060807@linux.vnet.ibm.com>
	 <200802140000.10639.bzolnier@gmail.com>
	 <47B40DF2.10009@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 1:46 AM, Kamalesh Babulal
<kamalesh@linux.vnet.ibm.com> wrote:
>
> Bartlomiej Zolnierkiewicz wrote:
>  > Hi,
>  >
>  > On Tuesday 12 February 2008, Kamalesh Babulal wrote:
>  >> Bartlomiej Zolnierkiewicz wrote:
>  >>> Hi,
>  >>>
>  >>> On Monday 11 February 2008, Kamalesh Babulal wrote:
>  >>>> Nish Aravamudan wrote:
>  >>>>> On 2/7/08, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
>  >>>>>> On Thursday 07 February 2008, Kamalesh Babulal wrote:
>  >>>>>>> Bartlomiej Zolnierkiewicz wrote:
>  >>>>>>>> Hi,
>  >>>>>>>>
>  >>>>>>>> On Wednesday 06 February 2008, Pavel Machek wrote:
>  >>>>>>>>> On Wed 2008-02-06 11:53:34, Pavel Machek wrote:
>  >>>>>>>>>> Hi!
>  >>>>>>>>>>
>  >>>>>>>>>> Trying to boot 2.6.25-git0 (few days old), I get
>  >>>>>>>>>>
>  >>>>>>>>>> BUG: unable to handle kernel paging request at ffff..ffb0
>  >>>>>>>>>> IP at init_irq+0x42e
>  >>>>>>>> init_irq? hmm...
>  >>>>>>>>
>  >>>>>>>>>> Call trace:
>  >>>>>>>>>> ide_device_add_all
>  >>>>>>>> this comes from ide-generic
>  >>>>>>>> (Generic IDE host driver)
>  >>>>>>>>
>  >>>>>>>>>> ide_generic_init
>  >>>>>>>>>> kernel_init
>  >>>>>>>>>> child_rip
>  >>>>>>>>>> vgacon_cursor
>  >>>>>>>>>> kernel_init
>  >>>>>>>>>> child_rip
>  >>>>>>>>>>
>  >>>>>>>>>> Excerpt from config:
>  >>>>>>>>>>
>  >>>>>>>>>> CONFIG_IDE=y
>  >>>>>>>>>> CONFIG_BLK_DEV_IDE=y
>  >>>>>>>>> Disabling CONFIG_IDE made my machine boot, as it was using libata
>  >>>>>>>>> anyway.
>  >>>>>>>> Kamalesh/Pavel:
>  >>>>>>>>
>  >>>>>>>> Could you try latest git and see if the OOPS is still there?
>  >>>>>>>>
>  >>>>>>>> [ Yeah, I'm unable to reproduce it. :( ]
>  >>>>>>>>
>  >>>>>>>> Thanks,
>  >>>>>>>> Bart
>  >>>>>>> Hi Bart,
>  >>>>>>>
>  >>>>>>> The panic is reproducible with the 2.6.24-git16 kernel, the call trace is
>  >>>>>>> similar to the previous one
>  >>>>>> Thanks, I again reviewed ide-probe.c changes but nothing seems wrong...
>  >>>>>>
>  >>>>>> Could you please bisect it down to the guilty commit?
>  >>>>> Kamalesh, were you able to bisect this down? I just got hit by the
>  >>>>> same panic on a 4-way x86_64, with 2.6.24-git22.
>  >>>>>
>  >>>>> Thanks,
>  >>>>> Nish
>  >>>> Hi Nish,
>  >>>>
>  >>>> I tried bisecting and the guilty patch seems to be
>  >>>>
>  >>>> 36501650ec45b1db308c3b51886044863be2d762 is first bad commit
>  >>>> commit 36501650ec45b1db308c3b51886044863be2d762
>  >>>> Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>  >>>> Date:   Fri Feb 1 23:09:31 2008 +0100
>  >>>>
>  >>>>     ide: keep pointer to struct device instead of struct pci_dev in ide_hwif_t
>  >>>>
>  >>>>
>  >>>> the gdb output, also points to the changes made by the guilty patch
>  >>>>
>  >>>> (gdb) p ide_device_add_all
>  >>>> $1 = {int (u8 *, const struct ide_port_info *)} 0xffffffff804176ac <ide_device_add_all>
>  >>>> (gdb) p/x 0xffffffff804176ac+0xb60
>  >>>> $2 = 0xffffffff8041820c
>  >>>> (gdb) l *0xffffffff8041820c
>  >>>> 0xffffffff8041820c is in ide_device_add_all (drivers/ide/ide-probe.c:1249).
>  >>>> 1244                    goto out;
>  >>>> 1245            }
>  >>>> 1246
>  >>>> 1247            sg_init_table(hwif->sg_table, hwif->sg_max_nents);
>  >>>> 1248
>  >>>> 1249            if (init_irq(hwif) == 0)
>  >>>> 1250                    goto done;
>  >>>> 1251
>  >>>> 1252            old_irq = hwif->irq;
>  >>>> 1253            /*
>  >>>> (gdb)
>  >>>>
>  >>>>
>  >>>> (gdb) p init_irq
>  >>>> $1 = {int (ide_hwif_t *)} 0xffffffff8041721f <init_irq>
>  >>>> (gdb) p/x 0xffffffff8041721f+0x1a4
>  >>>> $2 = 0xffffffff804173c3
>  >>>> (gdb) l *0xffffffff804173c3
>  >>>> 0xffffffff804173c3 is in init_irq (include/asm/pci.h:101).
>  >>>> 96      /* Returns the node based on pci bus */
>  >>>> 97      static inline int __pcibus_to_node(struct pci_bus *bus)
>  >>>> 98      {
>  >>>> 99              struct pci_sysdata *sd = bus->sysdata;
>  >>>> 100
>  >>>> 101             return sd->node;
>  >>>> 102     }
>  >>>> 103
>  >>>> 104     static inline cpumask_t __pcibus_to_cpumask(struct pci_bus *bus)
>  >>>> 105     {
>  >>>> (gdb)
>  >>> Thanks for the detailed analysis and sorry for the bug.
>  >>>
>  >>> I think that this may has been just fixed by Andi's recent hwif_to_node()
>  >>> fix (patch below, it is in Linus' tree already), could please verify this?
>  >>>
>  >>> commit 1f07e988290fc45932f5028c9e2a862c37a57336
>  >>> Author: Andi Kleen <andi@firstfloor.org>
>  >>> Date:   Mon Feb 11 01:35:20 2008 +0100
>  >>>
>  >>>     Prevent IDE boot ops on NUMA system
>  >>>
>  >>>     Without this patch a Opteron test system here oopses at boot with
>  >>>     current git.
>  >>>
>  >>>     Calling to_pci_dev() on a NULL pointer gives a negative value so the
>  >>>     following NULL pointer check never triggers and then an illegal address
>  >>>     is referenced.  Check the unadjusted original device pointer for NULL
>  >>>     instead.
>  >>>
>  >>>     Signed-off-by: Andi Kleen <ak@suse.de>
>  >>>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>  >>>
>  >>> diff --git a/include/linux/ide.h b/include/linux/ide.h
>  >>> index 23fad89..a3b69c1 100644
>  >>> --- a/include/linux/ide.h
>  >>> +++ b/include/linux/ide.h
>  >>> @@ -1295,7 +1295,7 @@ static inline void ide_dump_identify(u8 *id)
>  >>>  static inline int hwif_to_node(ide_hwif_t *hwif)
>  >>>  {
>  >>>     struct pci_dev *dev = to_pci_dev(hwif->dev);
>  >>> -   return dev ? pcibus_to_node(dev->bus) : -1;
>  >>> +   return hwif->dev ? pcibus_to_node(dev->bus) : -1;
>  >>>  }
>  >>>
>  >>>  static inline ide_drive_t *ide_get_paired_drive(ide_drive_t *drive)
>  >> Hi Bart,
>  >> Thanks !! the patch solves the kernel panic but when after applying the patch,kernel is not
>  >> able to mount the filesystem and panics, am i not sure what is likely causing the panic.
>  >
>  > Is
>  >
>  > - the commit 36501650ec45b1db308c3b51886044863be2d762 with Andi's fix applied
>  >
>  > or
>  >
>  > - the commit f6fb786d6dcdd7d730e4fba620b071796f487e1b
>  >   (the one before commit 36501650ec45b1db308c3b51886044863be2d762)
>  >
>  > working for you?
>
>  No, the commit before the commit 36501650ec45b1db308c3b51886044863be2d762 did not either work, i
>  get the same kernel panic.
>
>
>  >
>  >> Creating root device.
>  >> Mounting root filesystem.
>  >> mount: could not  find filesystem
>  >> Kernel panic - not syncing: Attempted to kill init!
>  >
>  > Is IDE actually used for the boot device?
>  >
>  > [ Please send a dmesg output from the working system. ]

it seems you have enclosure connected.

please check if you enable the SES in .config.

if so, please try

http://lkml.org/lkml/2008/2/13/673

YH

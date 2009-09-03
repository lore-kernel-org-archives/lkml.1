Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbZICXvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbZICXvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 19:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756574AbZICXvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 19:51:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61391 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593AbZICXvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 19:51:46 -0400
From: Christian =?utf-8?q?Kr=C3=A4mer?= <christian@kraemer-eu.de>
Organization: Privat
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Date: Fri, 4 Sep 2009 01:49:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-pcmcia@lists.infradead.org, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org
References: <200909021856.29565.christian@kraemer-eu.de> <200909031927.19590.elendil@planet.nl> <20090903193709.GA11097@pengutronix.de>
In-Reply-To: <20090903193709.GA11097@pengutronix.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200909040149.45066.christian@kraemer-eu.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+qONBF5fo52CvLkfZGyQnQ8amxhBiX3i0Z+ht
 E1ZTWNkIa+NE0JXEvQU3D0yojxEWMi+cVi03fue12ERRt+V+01
 WkSvlxzsxatZL2/jpRd3NYUw29+YPfL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 September 2009 21:37:09 Wolfram Sang wrote:
> > Original message with lspci and dmesg output for .24 is at:
> > http://lkml.org/lkml/2009/9/2/199
>
> For a start:
>
> That line
>
> pcmcia: Detected deprecated PCMCIA ioctl usage from process: hwsetup.
>
> has not much to do with pcmcia_cs. It is just that hwsetup uses a
> deprecated interface (new one is sysfs). Is this message still showing up
> with the newer gentoo-version? I seem to recall that hwsetup got fixed
> meanwhile, but I may be wrong here.

As I said, I don't know very much about hwsetup, but It seems that it only 
detects the hardware and loads the modules for it. It does the right thing 
here: loading the yenta_socket module.

>
> What about these lines?
>
> PCI: Probing PCI hardware
> sysfs: duplicate filename 'bridge' can not be created
> WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> Pid: 1, comm: swapper Not tainted 2.6.24-gentoo-r7 #1
>  [<c0187ceb>] sysfs_add_one+0x54/0xb8
>  [<c01888da>] sysfs_create_link+0xaf/0xfd
>  [<c02c8020>] pci_bus_add_devices+0xba/0xff
>  [<c037ac1d>] pcibios_scan_root+0x25/0x80
>  [<c011ab3d>] printk+0x1b/0x1f
>  [<c052822f>] pci_legacy_init+0x53/0xe1
>  [<c0505769>] kernel_init+0x154/0x2b6
>  [<c0102546>] ret_from_fork+0x6/0x20
>  [<c0505615>] kernel_init+0x0/0x2b6
>  [<c0505615>] kernel_init+0x0/0x2b6
>  [<c0103877>] kernel_thread_helper+0x7/0x10
>  =======================
> pci 0000:00:02.0: Error creating sysfs bridge symlink, continuing...
> sysfs: duplicate filename 'bridge' can not be created
> WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> Pid: 1, comm: swapper Not tainted 2.6.24-gentoo-r7 #1
>  [<c0187ceb>] sysfs_add_one+0x54/0xb8
>  [<c01888da>] sysfs_create_link+0xaf/0xfd
>  [<c02c8020>] pci_bus_add_devices+0xba/0xff
>  [<c052822f>] pci_legacy_init+0x53/0xe1
>  [<c0505769>] kernel_init+0x154/0x2b6
>  [<c0102546>] ret_from_fork+0x6/0x20
>  [<c0505615>] kernel_init+0x0/0x2b6
>  [<c0505615>] kernel_init+0x0/0x2b6
>  [<c0103877>] kernel_thread_helper+0x7/0x10
>  =======================
> pci 0000:00:02.1: Error creating sysfs bridge symlink, cobeholdenntinuing...
>
> Do they still show up with the latest kernel? Is this a known problem with
> this laptop?

I have also installed a gentoo-system with a new (2.6.30) kernel and there was 
the same problem at all (but I don't know the exacly dmsg output). But as I 
said already, it would be no problem to install any specific kernel and I'am 
also able to patch it if necessary if there is a litte chance to get it 
working.

The only thing that I know at the moment is, that with 2.6.30 the problem at 
all is the same (kernel displays that a card is inserted, but it wont apear 
in lspci without the -H1 parameter) ans also, that the gentoo init-scripts of 
an installed system won't use hwsetup. In the installed system I loaded the 
yenta_socket module manually via modprobe.

For this laptop at all there are a lot of problems with newer linux kernels. 
Some people got it working with serveral hacks in the config file of the 
pcmcia_cs suite, but all those tips only fit with pcmcia_cs and so to the 
2.4 kernel. If you're interessted in those sources, i could search the URLs
again in my browser history.

Maybe it also relevant what I read on a german bsd-board. In FreeBSD 4.10 it 
worked perfectly on this laptop, but since 4.11 the slots won't get an 
interrupt assigned. I don't now very much about hardware and driver 
development, but I'am sure that it has to do something with the assigned 
ressources (and maybe with the interrupt).

Today I found also a patch for another thinkpad with a hardware bug: the irq 
pins are not connected. Maybe that's the thing, reffered on the irq 
difference betwenn lspci with and without the -H1 paramtert; with -H1 it 
shows irq 255 instead of 11 which the kernel assign. I'dont know witch role 
irqs play in detection of hardware, but this could be an interesting track.

Here is the URL I found those patch: 
http://www.thinkwiki.org/wiki/760ed_yenta_patch

I'll try this patch tomorrow with the current 2.6.30 kernel, and if it 
couldn't be applied, I try it with the 2.6.15.1 version the patch was 
designed for.


> So much for a glimpse, maybe I'll have a bit more time tomorrow...
>
> Regards,
>
>    Wolfram

It would be very beholden, when you have a look, a hint or something else at 
could solve this problem.

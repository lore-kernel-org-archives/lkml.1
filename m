Return-Path: <linux-kernel-owner+w=401wt.eu-S964873AbXBLQXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964873AbXBLQXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964878AbXBLQXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:23:41 -0500
Received: from violet.upc.es ([147.83.2.51]:48063 "EHLO violet.upc.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964873AbXBLQXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:23:39 -0500
From: Leopold Palomo-Avellaneda <lepalom@wol.es>
To: Jean Delvare <jdelvare@suse.de>
Subject: Re: Sata_via problems in a Vintage2-AE1
Date: Mon, 12 Feb 2007 17:23:16 +0100
User-Agent: KMail/1.9.5
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jgarzik@pobox.com>
References: <200702090010.06897.lepalom@wol.es> <45CDDA86.2000607@gmail.com> <200702121011.49818.jdelvare@suse.de>
In-Reply-To: <200702121011.49818.jdelvare@suse.de>
MIME-Version: 1.0
Message-Id: <200702121723.17999.lepalom@wol.es>
X-MIMETrack: Itemize by SMTP Server on Ackerman/UPC(Release 5.0.12  |February 13, 2003) at
 12/02/2007 17:23:20,
	Serialize by Router on Ackerman/UPC(Release 5.0.12  |February 13, 2003) at
 12/02/2007 17:23:21,
	Serialize complete at 12/02/2007 17:23:21
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
  charset="iso-8859-13"
Content-Disposition: inline
X-Mail-Scanned: Criba 2.0 + Clamd
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.0.2 (violet.upc.es [147.83.2.51]); Mon, 12 Feb 2007 17:23:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A Dilluns 12 Febrer 2007 10:11, Jean Delvare va escriure:
> Le Samedi 10 Février 2007 15:45, Tejun Heo a écrit :
> > [cc'ing Alan and Jean, Hi!]
> >
> > Leopold Palomo Avellaneda wrote:
> > > A Divendres 09 Febrer 2007 18:13, Leopold Palomo Avellaneda va escriure:
> > >> A Divendres 09 Febrer 2007 10:46, Tejun Heo va escriure:
> > >>> Leopold Palomo Avellaneda wrote:
> > >>>> Dear people,
> > >>>>
> > >>>> I have a barebone Asus Vintage2-AE1 [1]. This box has a mobo Asus
> > >>>> A8V-MQ. The board has:
> > >>>> - the Socket 939 for AMD Athlon 64FX/Athlon 64.
> > >>>> - North Bridge: VIA K8M800
> > >>>> - South Bridge: VIA VT8251
> > >>>> - VIA Graphics Integrated
> > >>>> - IDE 2 x UltraDMA 133
> > >>>> - 4 x Serial ATA
> > >>>> ...
> > >>>>
> > >>>> I'm using the bios version 0206. The 0210 doesn't show me the vga
> > >>>> card, so I don't have graphics mode. I think that is a buggy bios.
>
> Did you report the problem to Asus? They should fix it. Maybe this new BIOS
> actually fixes some other problems you have.

no. It's on the todo list. However I'm a bit afraid because I'm not using 
the "official" system so probably they will say that "we do not support ..."

> > >>>> The bios is configured with vt8251 in AHCI mode and bios boot up
> > >>>> activated, so the hd is recognized in the beginning. I don't have
> > >>>> any raid, only one hd. The hd is a Maxtor 6V250F0.
> > >>>>
> > >>>> I'm using a debian etch but the i386 version. The only way that I
> > >>>> can use the hd is using a 2.6.16 standard kernel with the
> > >>>> modifications explained in this page [2]. Basically you have to use
> > >>>> their ahci.c and sata_via.c. The modifications are small from the
> > >>>> original code from Mr Jeff Garzik.
> > >>>>
> > >>>> I have tried to use the 2.6.18 and 2.6.20rc6 and the result is the
> > >>>> same. The kernel boots, but when arrives at the ata3,
> > >>>>
> > >>>> scsi2 : ahci
> > >>>> ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> > >>>> ata3.00: qc timeout (cmd 0xec)
> > >>>> ata3.00: failed to IDENTIFY (I/O error, err_mask=0x104)
> > >>>> .... repeated some times ...
> > >>>> scsi3 : ahci
> > >>>> ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> > >>>> scsi4 : ahci
> > >>>> ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> > >>>> scsi5 : ahci
> > >>>> ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> > >>>> Done.
> > >>>> Begin: Mounting root file system... ...
> > >>>> Begin: Running /scripts/local-top
> > >>>> ide0: I/O resource 0x3F6-0x3F6 not free.
> > >>>> ide0: ports already in use, skipping probe.
> > >>>> ide1: I/O resource 0x376-0x376 not free.
> > >>>> ide1: ports already in use, skipping probe.
> > >>>> Done.
> > >>>> Begin: Waiting for root file system ...
> > >>>
> > >>> It might be VIA IRQ quirk problem.
> > >>>
> > >>> 1. Does giving 'irqpoll' parameter to kernel make any difference?
> > >>
> > >> yes. Now it boots. However I'm having a lot of messages:
> > >> APIC error on CPU0
> > >> and I begin to have problems with the network card.
> > >>
> > >>> 2. Can you give a shot at 2.6.20?
> > >>
> > >> yes, I'm doing it now.
> > >>
> > >> Thank's a lot. But, why with irqpoll works and without no?
> > >
> > > well, I summarize.
> > >
> > > With the default options of the kernel I cannot boot in this device
> > > with any kernel. Only with 2.6.20 and the irqpoll or the 2.6.16
> > > modified files I can boot.
> > >
> > > I have a lot of APIC error on CPU0.
>
> Maybe try booting with noapic and/or nolapic and see if it helps. That's
> probably just a workaround and not the right solution though.

No. Booting with noapic doesn't resolve the problem. But now it's a minor 
problem.

> > It seems one of via pci routing quirk problem.  Can you give a shot at
> > 'acpi=off' or 'acpi=noirq' without 'irqpoll'?
> >
> > I dunno much about what's going on there.  Alan, Jean, any ideas?
>
> I've read the whole thread, the source code (quickly) and the patches to
> ahci.c and sata_via.c, and here are some comments:
>
> It looks like support for the VT8251 was added to the ahci driver in kernel
> 2.6.18, and was then updated in 2.6.20. The code is different from the
> patch Leopold is using with 2.6.16. As I am not an expert in this area, I
> can't tell whether both versions are equivalent or not, but I'd guess so.

Probably are equivalent but maybe "the experts"  don't think the same.

> On the other hand, I do not see VT8251 support in the sata_via driver in
> the kernel, so I'm not surprised that it doesn't work properly for Leopold.

Well in http://via8251.la-evento.com/index.html 

<off topic>
please tell me that I'm not violating any rule about the linux-kernel list 
putting this link :-S
</off topic>

claims that the VT8251 are supported in 2.6.20. As always you nned to see the 
official place .... :-(
  
> But again I am no expert in the area, so maybe the sata_via driver in the
> kernel is supposed to work for VT8251-based systems. Jeff (cc'd) should
> know better.


> I also see that there were many changes to these drivers post-2.6.20, so
> maybe Leopold could give a try to Linus' latest kernel (2.6.20-git6 as I
> speak) and see if there are any improvements.

Ok, I need some more time to test this.

> As for the VIA IRQ quirks, the version we have in 2.6.20 does not handle
> the VIA chips more recent than the VT8237A. If the VT8251 needs it, then we
> have to add it. Alan?
>
> *If* the VT8251 needs the VIA IRQ quirk, then the attached patch may help.
> Leopold, can you give it a try?

Well, making your patch to the vanilla 2.6.20 the result is the same. The box 
doesn't boot. Always the same problem ....

Thank's for all,

Regards,

Leo 

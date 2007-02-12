Return-Path: <linux-kernel-owner+w=401wt.eu-S964801AbXBLJQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801AbXBLJQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964802AbXBLJQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:16:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964801AbXBLJQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:16:27 -0500
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Tejun Heo <htejun@gmail.com>
Subject: Re: Sata_via problems in a Vintage2-AE1
Date: Mon, 12 Feb 2007 10:11:49 +0100
User-Agent: KMail/1.9.1
Cc: Leopold Palomo Avellaneda <lepalom@wol.es>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jgarzik@pobox.com>
References: <200702090010.06897.lepalom@wol.es> <200702092109.25029.lepalom@wol.es> <45CDDA86.2000607@gmail.com>
In-Reply-To: <45CDDA86.2000607@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_V9C0FPOjoOokmzp"
Message-Id: <200702121011.49818.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_V9C0FPOjoOokmzp
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le Samedi 10 F=E9vrier 2007 15:45, Tejun Heo a =E9crit=A0:
> [cc'ing Alan and Jean, Hi!]
>
> Leopold Palomo Avellaneda wrote:
> > A Divendres 09 Febrer 2007 18:13, Leopold Palomo Avellaneda va escriure:
> >> A Divendres 09 Febrer 2007 10:46, Tejun Heo va escriure:
> >>> Leopold Palomo Avellaneda wrote:
> >>>> Dear people,
> >>>>
> >>>> I have a barebone Asus Vintage2-AE1 [1]. This box has a mobo Asus
> >>>> A8V-MQ. The board has:
> >>>> - the Socket 939 for AMD Athlon 64FX/Athlon 64.
> >>>> - North Bridge: VIA K8M800
> >>>> - South Bridge: VIA VT8251
> >>>> - VIA Graphics Integrated
> >>>> - IDE 2 x UltraDMA 133
> >>>> - 4 x Serial ATA
> >>>> ...
> >>>>
> >>>> I'm using the bios version 0206. The 0210 doesn't show me the vga
> >>>> card, so I don't have graphics mode. I think that is a buggy bios.

Did you report the problem to Asus? They should fix it. Maybe this new BIOS=
=20
actually fixes some other problems you have.

> >>>> The bios is configured with vt8251 in AHCI mode and bios boot up
> >>>> activated, so the hd is recognized in the beginning. I don't have any
> >>>> raid, only one hd. The hd is a Maxtor 6V250F0.
> >>>>
> >>>> I'm using a debian etch but the i386 version. The only way that I can
> >>>> use the hd is using a 2.6.16 standard kernel with the modifications
> >>>> explained in this page [2]. Basically you have to use their ahci.c a=
nd
> >>>> sata_via.c. The modifications are small from the original code from =
Mr
> >>>> Jeff Garzik.
> >>>>
> >>>> I have tried to use the 2.6.18 and 2.6.20rc6 and the result is the
> >>>> same. The kernel boots, but when arrives at the ata3,
> >>>>
> >>>> scsi2 : ahci
> >>>> ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> >>>> ata3.00: qc timeout (cmd 0xec)
> >>>> ata3.00: failed to IDENTIFY (I/O error, err_mask=3D0x104)
> >>>> .... repeated some times ...
> >>>> scsi3 : ahci
> >>>> ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> >>>> scsi4 : ahci
> >>>> ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> >>>> scsi5 : ahci
> >>>> ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> >>>> Done.
> >>>> Begin: Mounting root file system... ...
> >>>> Begin: Running /scripts/local-top
> >>>> ide0: I/O resource 0x3F6-0x3F6 not free.
> >>>> ide0: ports already in use, skipping probe.
> >>>> ide1: I/O resource 0x376-0x376 not free.
> >>>> ide1: ports already in use, skipping probe.
> >>>> Done.
> >>>> Begin: Waiting for root file system ...
> >>>
> >>> It might be VIA IRQ quirk problem.
> >>>
> >>> 1. Does giving 'irqpoll' parameter to kernel make any difference?
> >>
> >> yes. Now it boots. However I'm having a lot of messages:
> >> APIC error on CPU0
> >> and I begin to have problems with the network card.
> >>
> >>> 2. Can you give a shot at 2.6.20?
> >>
> >> yes, I'm doing it now.
> >>
> >> Thank's a lot. But, why with irqpoll works and without no?
> >
> > well, I summarize.
> >
> > With the default options of the kernel I cannot boot in this device with
> > any kernel. Only with 2.6.20 and the irqpoll or the 2.6.16 modified fil=
es
> > I can boot.
> >
> > I have a lot of APIC error on CPU0.

Maybe try booting with noapic and/or nolapic and see if it helps. That's=20
probably just a workaround and not the right solution though.

> It seems one of via pci routing quirk problem.  Can you give a shot at
> 'acpi=3Doff' or 'acpi=3Dnoirq' without 'irqpoll'?
>
> I dunno much about what's going on there.  Alan, Jean, any ideas?

I've read the whole thread, the source code (quickly) and the patches to=20
ahci.c and sata_via.c, and here are some comments:

It looks like support for the VT8251 was added to the ahci driver in kernel=
=20
2.6.18, and was then updated in 2.6.20. The code is different from the=20
patch Leopold is using with 2.6.16. As I am not an expert in this area, I=20
can't tell whether both versions are equivalent or not, but I'd guess so.

On the other hand, I do not see VT8251 support in the sata_via driver in th=
e=20
kernel, so I'm not surprised that it doesn't work properly for Leopold. But=
=20
again I am no expert in the area, so maybe the sata_via driver in the kerne=
l=20
is supposed to work for VT8251-based systems. Jeff (cc'd) should know bette=
r.

I also see that there were many changes to these drivers post-2.6.20, so ma=
ybe=20
Leopold could give a try to Linus' latest kernel (2.6.20-git6 as I speak) a=
nd=20
see if there are any improvements.

As for the VIA IRQ quirks, the version we have in 2.6.20 does not handle th=
e=20
VIA chips more recent than the VT8237A. If the VT8251 needs it, then we hav=
e=20
to add it. Alan?

*If* the VT8251 needs the VIA IRQ quirk, then the attached patch may help.=
=20
Leopold, can you give it a try?

=2D-=20
Jean Delvare
Suse L3

--Boundary-00=_V9C0FPOjoOokmzp
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="pci-via-irq-quirk-for-VT8251.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="pci-via-irq-quirk-for-VT8251.patch"

Enable the VIA IRQ quirk on the VT8237S and VT8251 south bridges.
Needs testing.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
---
 drivers/pci/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-2.6.20.orig/drivers/pci/quirks.c
+++ linux-2.6.20/drivers/pci/quirks.c
@@ -666,12 +666,14 @@ static void quirk_via_bridge(struct pci_
 		   that single device. */
 		via_vlink_dev_lo = PCI_SLOT(dev->devfn);
 		via_vlink_dev_hi = PCI_SLOT(dev->devfn);
 		break;
 	case PCI_DEVICE_ID_VIA_8237:
 	case PCI_DEVICE_ID_VIA_8237A:
+	case PCI_DEVICE_ID_VIA_8237S:
+	case PCI_DEVICE_ID_VIA_8251:
 		via_vlink_dev_lo = 15;
 		break;
 	case PCI_DEVICE_ID_VIA_8235:
 		via_vlink_dev_lo = 16;
 		break;
 	case PCI_DEVICE_ID_VIA_8231:
@@ -687,12 +689,14 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_V
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8233_0,	quirk_via_bridge);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8233A,	quirk_via_bridge);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8233C_0,	quirk_via_bridge);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8235,		quirk_via_bridge);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8237,		quirk_via_bridge);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8237A,	quirk_via_bridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8237S,	quirk_via_bridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8251,		quirk_via_bridge);
 
 /**
  *	quirk_via_vlink		-	VIA VLink IRQ number update
  *	@dev: PCI device
  *
  *	If the device we are dealing with is on a PIC IRQ we need to

--Boundary-00=_V9C0FPOjoOokmzp--

Return-Path: <linux-kernel-owner+w=401wt.eu-S932341AbXBSPRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbXBSPRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 10:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932332AbXBSPRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 10:17:08 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:55366 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932341AbXBSPRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 10:17:07 -0500
Date: Mon, 19 Feb 2007 10:17:05 -0500
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PCI riser cards and PCI irq routing, etc
Message-ID: <20070219151705.GQ7582@csclub.uwaterloo.ca>
References: <45D85DA1.7090502@xs4all.nl> <20070218155445.GV7584@csclub.uwaterloo.ca> <45D87BA2.9020001@xs4all.nl> <20070218193901.GN7582@csclub.uwaterloo.ca> <45D921E0.2040608@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D921E0.2040608@xs4all.nl>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 05:04:48AM +0100, Udo van den Heuvel wrote:
> lspci and interrupts at the bottom. yes, we have apic.

Well you could always try to just change the setting to see if you find
one where the interrupts are happy.  If you change the setting by one at
a time, you should only have to try 4 positions to get one that works
since that is how many interrupts PCI has.

> The EN12000 is equipped with a PCI riser like the one here:
> http://www.tranquilpc-shop.co.uk/acatalog/info%5f2%2ehtml
> Please also see
> http://www.tranquilpc-shop.co.uk/acatalog/PCI_Risers.html and
> http://www.tranquilpc.co.uk/support/Files/TPC014/Tranquil%20Riser.pdf
> for info about how the riser works.
> 
> > I guess it is possible the card does something weird and the IRQs for
> > both cards have to actually be the same.  If that is the case you could
> > make the kernel change the IRQ assigned to the second card before
> > loading the driver.  Or you could do it from the boot loader or
> > something (The system I work with has a stupid bios that doesn't have a
> > clue about bridges, so we added IRQ fixup code to grub to deal with all
> > PCI bridges before booting the system).
> 
> Ah, this sounds interesting.
> Any pointers about hwo to do this?

Well reasonably you shouldn't have to.

> I will give the change a try.
> 
> The info:
> 
> 00:00.0 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
> Host Bridge
> 00:00.1 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
> Host Bridge
> 00:00.2 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
> Host Bridge
> 00:00.3 Host bridge: VIA Technologies, Inc. PT890 Host Bridge
> 00:00.4 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
> Host Bridge
> 00:00.7 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
> Host Bridge
> 00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge
> 00:0d.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host
> Controller (rev 80)
> 00:0e.0 Ethernet controller: VIA Technologies, Inc. VT6120/VT6121/VT6122
> Gigabit Ethernet Adapter (rev 11)
> 00:0f.0 IDE interface: VIA Technologies, Inc. VIA VT6420 SATA RAID
> Controller (rev 80)
> 00:0f.1 IDE interface: VIA Technologies, Inc.
> VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
> 00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 81)
> 00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 81)
> 00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 81)
> 00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86)
> 00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge
> [KT600/K8T800/K8T890 South]
> 00:11.5 Multimedia audio controller: VIA Technologies, Inc.
> VT8233/A/8235/8237 AC97 Audio Controller (rev 60)
> 00:13.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
> 00:14.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
> 01:00.0 VGA compatible controller: VIA Technologies, Inc. UniChrome Pro
> IGP (rev 01)

You need lspci -v to get interrupt information.

>           CPU0
>   0:   15939569   IO-APIC-edge      timer
>   1:         36   IO-APIC-edge      i8042
>   8:          1   IO-APIC-edge      rtc
>   9:          0   IO-APIC-fasteoi   acpi
>  12:        222   IO-APIC-edge      i8042
>  14:     570999   IO-APIC-edge      ide0
>  16:    3166202   IO-APIC-fasteoi   saa7146 (0), via@pci:0000:01:00.0
>  17:    2619374   IO-APIC-fasteoi   eth0
>  18:     402194   IO-APIC-fasteoi   libata
>  19:          0   IO-APIC-fasteoi   uhci_hcd:usb1, uhci_hcd:usb2,
> uhci_hcd:usb3, ehci_hcd:usb4
>  20:          2   IO-APIC-fasteoi   saa7146 (1), ohci1394
>  21:    2768193   IO-APIC-fasteoi   VIA8237
> NMI:          0
> LOC:   15938827
> ERR:          0
> MIS:          0

That unfortunately only shows interrupts in use by active drivers.

--
Len Sorensen

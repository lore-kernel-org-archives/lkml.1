Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbXBSEEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbXBSEEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 23:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXBSEEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 23:04:55 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1704 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbXBSEEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 23:04:54 -0500
Message-ID: <45D921E0.2040608@xs4all.nl>
Date: Mon, 19 Feb 2007 05:04:48 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <20070218155445.GV7584@csclub.uwaterloo.ca> <45D87BA2.9020001@xs4all.nl> <20070218193901.GN7582@csclub.uwaterloo.ca>
In-Reply-To: <20070218193901.GN7582@csclub.uwaterloo.ca>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Sun, Feb 18, 2007 at 05:15:30PM +0100, Udo van den Heuvel wrote:
>> FYI: My situation is a VIA Epia EN12000 with a TranquilPC dual PCI riser
>> where only the Device Number can be changed.
>> The kernel sees the two DVB cards in there as:
>>
>> saa7146: register extension 'budget_av'.
>> ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 16 (level, low) -> IRQ 16
>> saa7146: found saa7146 @ mem f8c3e000 (revision 1, irq 16) (0x153b,0x1157).
>> saa7146 (0): dma buffer size 192512
>> DVB: registering new adapter (Terratec Cinergy 1200 DVB-T).
>> adapter failed MAC signature check
>> encoded MAC from EEPROM was
>> ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
>> KNC1-0: MAC addr = 00:0a:ac:01:d6:87
>> DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
>> budget-av: ci interface initialised.
>> ACPI: PCI Interrupt 0000:00:14.0[A] -> GSI 17 (level, low) -> IRQ 20
>> saa7146: found saa7146 @ mem f8cb2000 (revision 1, irq 20) (0x153b,0x1155).
>> saa7146 (1): dma buffer size 192512
>> DVB: registering new adapter (TerraTec Cinergy 1200 DVB-S).
>> adapter failed MAC signature check
>> encoded MAC from EEPROM was
>> ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
>> sd 0:0:0:0: Attached scsi generic sg0 type 0
>> KNC1-1: MAC addr = 00:0a:ac:12:93:8d
>> DVB: registering frontend 1 (ST STV0299 DVB-S)...
>> budget-av: ci interface initialised.
> 
> Well it says they are slot 13 and 14.  What other pci devices are
> present in the system and what irq's are they using?  

lspci and interrupts at the bottom. yes, we have apic.

>> So IRQ 16 and 20. But when using the stock 2.6.20 kernel there is no
>> communication with the DVB-T card (the frontend), so there is no
>> /dev/dvb/* entry. This points to an IRQ problem.
> 
> Any documentation on that riser card?

The EN12000 is equipped with a PCI riser like the one here:
http://www.tranquilpc-shop.co.uk/acatalog/info%5f2%2ehtml
Please also see
http://www.tranquilpc-shop.co.uk/acatalog/PCI_Risers.html and
http://www.tranquilpc.co.uk/support/Files/TPC014/Tranquil%20Riser.pdf
for info about how the riser works.

> I guess it is possible the card does something weird and the IRQs for
> both cards have to actually be the same.  If that is the case you could
> make the kernel change the IRQ assigned to the second card before
> loading the driver.  Or you could do it from the boot loader or
> something (The system I work with has a stupid bios that doesn't have a
> clue about bridges, so we added IRQ fixup code to grub to deal with all
> PCI bridges before booting the system).

Ah, this sounds interesting.
Any pointers about hwo to do this?

>> I set the BIOS for 'PnP OS installed'. Should I change that?
(....)
> It might actually work better if you change that, although it may also
> just make no difference.

I will give the change a try.

The info:

00:00.0 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
Host Bridge
00:00.1 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
Host Bridge
00:00.2 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
Host Bridge
00:00.3 Host bridge: VIA Technologies, Inc. PT890 Host Bridge
00:00.4 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
Host Bridge
00:00.7 Host bridge: VIA Technologies, Inc. CN700/VN800/P4M800CE/Pro
Host Bridge
00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge
00:0d.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host
Controller (rev 80)
00:0e.0 Ethernet controller: VIA Technologies, Inc. VT6120/VT6121/VT6122
Gigabit Ethernet Adapter (rev 11)
00:0f.0 IDE interface: VIA Technologies, Inc. VIA VT6420 SATA RAID
Controller (rev 80)
00:0f.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81)
00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81)
00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 81)
00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge
[KT600/K8T800/K8T890 South]
00:11.5 Multimedia audio controller: VIA Technologies, Inc.
VT8233/A/8235/8237 AC97 Audio Controller (rev 60)
00:13.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
00:14.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
01:00.0 VGA compatible controller: VIA Technologies, Inc. UniChrome Pro
IGP (rev 01)

          CPU0
  0:   15939569   IO-APIC-edge      timer
  1:         36   IO-APIC-edge      i8042
  8:          1   IO-APIC-edge      rtc
  9:          0   IO-APIC-fasteoi   acpi
 12:        222   IO-APIC-edge      i8042
 14:     570999   IO-APIC-edge      ide0
 16:    3166202   IO-APIC-fasteoi   saa7146 (0), via@pci:0000:01:00.0
 17:    2619374   IO-APIC-fasteoi   eth0
 18:     402194   IO-APIC-fasteoi   libata
 19:          0   IO-APIC-fasteoi   uhci_hcd:usb1, uhci_hcd:usb2,
uhci_hcd:usb3, ehci_hcd:usb4
 20:          2   IO-APIC-fasteoi   saa7146 (1), ohci1394
 21:    2768193   IO-APIC-fasteoi   VIA8237
NMI:          0
LOC:   15938827
ERR:          0
MIS:          0

Kind regards,
Udo

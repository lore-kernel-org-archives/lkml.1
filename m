Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbYBIUGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbYBIUGf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 15:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbYBIUG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 15:06:28 -0500
Received: from vms046pub.verizon.net ([206.46.252.46]:58303 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbYBIUG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 15:06:27 -0500
Date: Sat, 09 Feb 2008 15:05:31 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
In-reply-to: <200802091911.25730.prakash@punnoor.de>
To: Prakash Punnoor <prakash@punnoor.de>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       lenb@kernel.org, linux-kernel@vger.kernel.org
Message-id: <200802091505.31567.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20080207195519.GA21772@basil.nowhere.org>
 <200802091302.51863.gene.heskett@gmail.com>
 <200802091911.25730.prakash@punnoor.de>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 February 2008, Prakash Punnoor wrote:
>On the day of Saturday 09 February 2008 Gene Heskett hast written:
>> This has killed me both at boot time twice, once before NASH was running,
>> and several times when uptimes were a day plus, but has never reappeared
>> since the first time I used the acpi_user_timer_override argument, and
>> this includes several boots without it including 2 complete, 2 or 3 minute
>> power downs.
>
>Are you saying that on your nforce2 you need the override
>(acpi_use_timer_override) to have a stable system? Because that would be in
>contrast to all previous findings regarding nforce2. Could you provide
>
>cat /proc/interrupts
>lspci
>lspci -n

Currently booted with it, uptime 38 hours, only diff visible is in dmesg as 
has been posted here in another thread.

[root@coyote ~]# cat /proc/interrupts
           CPU0
  0:        869    XT-PIC-XT        timer
  1:         18   IO-APIC-edge      i8042
  3:          1   IO-APIC-edge
  4:          3   IO-APIC-edge
  6:          6   IO-APIC-edge      floppy
  8:          1   IO-APIC-edge      rtc
  9:          0   IO-APIC-fasteoi   acpi
 10:          0   IO-APIC-edge      MPU401 UART
 14:    2331370   IO-APIC-edge      libata
 15:    1492330   IO-APIC-edge      libata
 16:   23369893   IO-APIC-fasteoi   ehci_hcd:usb1, eth0
 17:      62319   IO-APIC-fasteoi   ohci_hcd:usb2, NVidia nForce2
 18:         35   IO-APIC-fasteoi   ohci_hcd:usb3
 19:     443715   IO-APIC-fasteoi   sata_sil
 20:    8421481   IO-APIC-fasteoi   firewire_ohci, nvidia
 21:          0   IO-APIC-fasteoi   cx88[0], cx88[0]
 22:      79353   IO-APIC-fasteoi   EMU10K1
NMI:          0   Non-maskable interrupts
LOC:   44806761   Local timer interrupts
RES:          0   Rescheduling interrupts
CAL:          0   function call interrupts
TLB:          0   TLB shootdowns
TRM:          0   Thermal event interrupts
SPU:          0   Spurious interrupts
ERR:          0
MIS:          0

[root@coyote ~]# lspci
00:00.0 Host bridge: nVidia Corporation nForce2 IGP2 (rev c1)
00:00.1 RAM memory: nVidia Corporation nForce2 Memory Controller 1 (rev c1)
00:00.2 RAM memory: nVidia Corporation nForce2 Memory Controller 4 (rev c1)
00:00.3 RAM memory: nVidia Corporation nForce2 Memory Controller 3 (rev c1)
00:00.4 RAM memory: nVidia Corporation nForce2 Memory Controller 2 (rev c1)
00:00.5 RAM memory: nVidia Corporation nForce2 Memory Controller 5 (rev c1)
00:01.0 ISA bridge: nVidia Corporation nForce2 ISA Bridge (rev a4)
00:01.1 SMBus: nVidia Corporation nForce2 SMBus (MCP) (rev a2)
00:02.0 USB Controller: nVidia Corporation nForce2 USB Controller (rev a4)
00:02.1 USB Controller: nVidia Corporation nForce2 USB Controller (rev a4)
00:02.2 USB Controller: nVidia Corporation nForce2 USB Controller (rev a4)
00:04.0 Ethernet controller: nVidia Corporation nForce2 Ethernet Controller 
(rev a1)
00:06.0 Multimedia audio controller: nVidia Corporation nForce2 AC97 Audio 
Controler (MCP) (rev a1)
00:08.0 PCI bridge: nVidia Corporation nForce2 External PCI Bridge (rev a3)
00:09.0 IDE interface: nVidia Corporation nForce2 IDE (rev a2)
00:1e.0 PCI bridge: nVidia Corporation nForce2 AGP (rev c1)
01:07.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and 
Audio Decoder (rev 05)
01:07.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio 
Decoder [MPEG Port] (rev 05)
01:08.0 Multimedia audio controller: Creative Labs SB0400 Audigy2 Value
01:09.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000 
Controller (PHY/Link)
01:0a.0 RAID bus controller: Silicon Image, Inc. SiI 3512 [SATALink/SATARaid] 
Serial ATA Controller (rev 01)
02:00.0 VGA compatible controller: nVidia Corporation NV44A [GeForce 6200] 
(rev a1)

[root@coyote ~]# lspci -n
00:00.0 0600: 10de:01e0 (rev c1)
00:00.1 0500: 10de:01eb (rev c1)
00:00.2 0500: 10de:01ee (rev c1)
00:00.3 0500: 10de:01ed (rev c1)
00:00.4 0500: 10de:01ec (rev c1)
00:00.5 0500: 10de:01ef (rev c1)
00:01.0 0601: 10de:0060 (rev a4)
00:01.1 0c05: 10de:0064 (rev a2)
00:02.0 0c03: 10de:0067 (rev a4)
00:02.1 0c03: 10de:0067 (rev a4)
00:02.2 0c03: 10de:0068 (rev a4)
00:04.0 0200: 10de:0066 (rev a1)
00:06.0 0401: 10de:006a (rev a1)
00:08.0 0604: 10de:006c (rev a3)
00:09.0 0101: 10de:0065 (rev a2)
00:1e.0 0604: 10de:01e8 (rev c1)
01:07.0 0400: 14f1:8800 (rev 05)
01:07.2 0480: 14f1:8802 (rev 05)
01:08.0 0401: 1102:0008
01:09.0 0c00: 104c:8024
01:0a.0 0104: 1095:3512 (rev 01)
02:00.0 0300: 10de:0221 (rev a1)

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Ten persons who speak make more noise than ten thousand who are silent.
		-- Napoleon I

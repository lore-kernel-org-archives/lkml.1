Return-Path: <linux-kernel-owner+w=401wt.eu-S1760146AbYEINlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146AbYEINlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 09:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbYEINlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 09:41:40 -0400
Received: from prospero.drewag.de ([212.111.238.28]:34438 "EHLO
	prospero.drewag.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbYEINlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 09:41:39 -0400
X-Greylist: delayed 2523 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 May 2008 09:41:38 EDT
X-Mailer: emacs 21.4.1 (via feedmail 8 I)
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "Ralf Hildebrandt" <Ralf.Hildebrandt@charite.de>,
       "Linux Kernel Maillist" <linux-kernel@vger.kernel.org>,
       <Sven_Rudolph@drewag.de>
Subject: Re: HP server and atto driver from hell
References: <0631C836DBF79F42B5A60C8C8D4E8229010475E9@NAMAIL2.ad.lsil.com>
From: Sven Rudolph <Sven_Rudolph@drewag.de>
Date: Fri, 09 May 2008 15:03:29 +0200
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229010475E9@NAMAIL2.ad.lsil.com> (Eric
 Moore's message of "Wed, 30 Apr 2008 08:50:02 -0600")
Message-ID: <xfkiqxnzl26.fsf@uxkm53.drewag.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pass-To-Notes: yes
User-Agent: Gnus/5.1007 (Gnus v5.10.7) Emacs/21.4 (gnu/linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Moore, Eric" <Eric.Moore@lsi.com> writes:

> On Wednesday, April 30, 2008 7:43 AM, Ralf Hildebrandt wrote:  
>> * Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>:
>> 
>> > Well, something seems to work:
>> > 
>> > [    3.571216] Fusion MPT base driver 3.04.06
>> > [    3.571274] Copyright (c) 1999-2007 LSI Corporation
>> > [    3.577292] Fusion MPT SPI Host driver 3.04.06
>> > [    3.577389] ACPI: PCI Interrupt 0000:14:04.0[A] -> GSI 
>> 17 (level, low) -> IRQ 17
>> > [    3.577512] mptbase: ioc0: Initiating bringup
>> > [    3.836271] ioc0: LSI53C1030 C0: Capabilities={Initiator,Target}
>> > [    3.992277] scsi0 : ioc0: LSI53C1030 C0, 
>> FwRev=01032700h, Ports=1, MaxQ=255, IRQ=17
>> > [    3.992277] ACPI: PCI Interrupt 0000:14:04.1[B] -> GSI 
>> 18 (level, low) -> IRQ 18
>> > [    3.992277] mptbase: ioc1: Initiating bringup
>> > [    4.244297] ioc1: LSI53C1030 C0: Capabilities={Initiator,Target}
>> > [    4.408304] scsi1 : ioc1: LSI53C1030 C0, 
>> FwRev=01032700h, Ports=1, MaxQ=255, IRQ=18
>> > 
>> > # lspci -v -s 14:04.0
>> > 14:04.0 SCSI storage controller: Atto Technology Ultra320 
>> SCSI Host Adapter (rev 08)
>> >         Subsystem: Atto Technology Unknown device 802f
>> >         Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 17
>> >         I/O ports at 5000 [size=256]
>> >         Memory at fdfc0000 (64-bit, non-prefetchable) [size=256K]
>> >         Memory at fdf80000 (64-bit, non-prefetchable) [size=256K]
>> >         Capabilities: [50] Power Management version 2
>> >         Capabilities: [58] Message Signalled Interrupts: 
>> Mask- 64bit+ Queue=0/0 Enable-
>> > 	Capabilities: [68] PCI-X non-bridge device
>> > 	Kernel driver in use: mptspi
>> > 	Kernel modules: mptspi
>> 
>> According to http://lwn.net/Articles/254394, Eric Moore added the ATTO
>> 4LD support:
>> 
>> mpt fusion: Add support for ATTO 4LD: Rebranded LSI
>> 
>> And the HP U320e SCSI Bus Adapter seesm to be a rebranded ATTO 4LD.
>> But I cannot be sure.
>> 
>
> Yeah, ATTO support was added about a year ago, thanks to Sven Rudolph.
> However I doubt HP card is *not* a rebranded ATTO card.  They both have
> the same scsi controller, but the bios and firmware on the HP card are
> directly from LSI, however I'm pretty sure that ATTO did everything them
> selves.

HP did two completely different PCI-Express Low-Profile SCSI HBAs:

The single-channel (HP SC11 Xe) one looks very similiar to the
LSI20320IE, but the HP version appeared months before the LSI version.

The dual-channel version (AH627A; see
<http://www.hardware.com/product.asp?id=AH627A>, other Web sites show
a wrong photo with a PCI-X connector) seems to be an Atto UL5D
Low-profile.


Ralf's card looks a lot like my Atto UL5D Lowprofile. For the first
SCSI channel:

  # lspci -v -s 0d:04.0
0d:04.0 SCSI storage controller: Atto Technology Ultra320 SCSI Host Adapter (rev 08)
        Subsystem: Atto Technology Unknown device 802f
        Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 17
        I/O ports at 6000 [size=256]
        Memory at fbc40000 (64-bit, non-prefetchable) [size=256K]
        Memory at fbc00000 (64-bit, non-prefetchable) [size=256K]
        [virtual] Expansion ROM at c2800000 [disabled] [size=1M]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
        Capabilities: [68] PCI-X non-bridge device

I just tested mine with Linux 2.6.24.4, and it finds the attached DLT
drives and they work. I missed Ralf's original problem but the output
above suggests that it didn't find any devices?

	Sven




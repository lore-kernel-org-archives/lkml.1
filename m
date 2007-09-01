Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbXIAOzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbXIAOzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 10:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbXIAOzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 10:55:44 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:48886 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753624AbXIAOzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 10:55:42 -0400
Message-ID: <46D97E15.2020005@ru.mvista.com>
Date: Sat, 01 Sep 2007 18:58:29 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: n <xellos@bluebottle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: kernel 2.6.22.6 pata_pdc202xx_old.c limiting to UDMA/33
 instead of UDMA/100 (UPDATED 2.6.22.6)
References: <46D59ED2.4000900@free.fr>	<20070829174657.09c7de3c@the-village.bc.nu>	<46D67D09.6090101@free.fr>	<46D69E03.9080403@vc.cvut.cz>	<46D6B85C.5050509@free.fr>	<46D6DDF6.6080400@free.fr> <20070831003127.6f6950f4@the-village.bc.nu> <46D7CFD7.9030404@free.fr> <200708310904.l7V94YE4015312@mi0.bluebottle.com>
In-Reply-To: <200708310904.l7V94YE4015312@mi0.bluebottle.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear n:

    Please do *not* follow-up to a completely inderended thread. Start your 
own, please. :-/

> Update with kernel 2.6.22.6 i am getting this error now
> ata2.00: ATA-6: ST3120026A, 3.06, max UDMA/100

    Gathering courage and reply to libata bug report -- I'm more of the 
drivers/ide/ guy with some SCSI background too... :-)


> here is the new error.
> ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.01: cmd ca/00:00:25:9c:fc/00:00:00:00:00/f6 tag 0 cdb 0x0 data 

    That was an attempt to read 1 sector from LBA 0xfc9c25 of rhe drive #1...

> 131072 out
>         res 40/00:00:3f:00:00/00:00:00:00:00/f0 Emask 0x4 (timeout)
> ata2: port is slow to respond, please be patient (Status 0xfe)
> ata2: device not ready (errno=-16), forcing hardreset
> ata2: soft resetting port
> ata2.01: configured for UDMA/25

     Whee! :-)

> ata2: EH complete

> here is dmseg output
[...]
> parport_pc: Current parallel port base: 0x378
> parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
> parport_pc: VIA parallel port: io=0x378, irq=7
> r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
> ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [LNKC] -> GSI 11 (level, 
> low) -> IRQ 11
> eth0: RTL8169sb/8110sb at 0xe882c000, 00:14:d1:38:5e:25, IRQ 11
> 8139too Fast Ethernet driver 0.9.28
> ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 5
> PCI: setting IRQ 5 as level-triggered
> ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKD] -> GSI 5 (level, low) 
> -> IRQ 5
> eth1: RealTek RTL8139 at 0x8800, 00:40:05:3a:15:c4, IRQ 5
> eth1:  Identified 8139 chip type 'RTL-8100B/8139D'

    RTL8139 are PoS chips (unless it's 8139D probably)... :-)

> via686a 0000:00:04.4: base address not set - upgrade BIOS or use 
> force_addr=0xaddr

     Hmmm, I'd assume that after that DMA wouldn't be possible but...

> Adding 390560k swap on /dev/sdc1.  Priority:-1 extents:1 across:390560k
> XFS mounting filesystem sdc3
> Ending clean XFS mount for filesystem: sdc3
> XFS mounting filesystem sdc4
> Ending clean XFS mount for filesystem: sdc4
> XFS mounting filesystem sdd1
> Ending clean XFS mount for filesystem: sdd1
> XFS mounting filesystem sde1
> Ending clean XFS mount for filesystem: sde1
> XFS mounting filesystem sdf1
> Ending clean XFS mount for filesystem: sdf1
> ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata2.01: (BMDMA stat 0x4)

> ata2.01: cmd ca/00:01:3f:00:00/00:00:00:00:00/f0 tag 0 cdb 0x0 data 512 out

    That was an attempt to read the 1st sector from LBA 0x3f of the drive...

>         res 51/84:00:3f:00:00/00:00:00:00:00/f0 Emask 0x10 (ATA bus error)

    ... which failed miserably, with UltraDMA CRC error. Hmmm...

> ata2: soft resetting port
> ata2.01: configured for UDMA/33
> ata2: EH complete
> ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata2.01: (BMDMA stat 0x4)
> ata2.01: cmd ca/00:01:3f:00:00/00:00:00:00:00/f0 tag 0 cdb 0x0 data 512 out
>         res 51/84:00:3f:00:00/00:00:00:00:00/f0 Emask 0x10 (ATA bus error)

     ... same sh!t happened again at UDNA/33 presumbly...

> ata2: soft resetting port
> ata2.01: configured for UDMA/33
> ata2: EH complete
> sd 1:0:1:0: [sdb] 234441648 512-byte hardware sectors (120034 MB)
> ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata2.01: (BMDMA stat 0x4)
> ata2.01: cmd ca/00:01:3f:00:00/00:00:00:00:00/f0 tag 0 cdb 0x0 data 512 out
>         res 51/84:00:3f:00:00/00:00:00:00:00/f0 Emask 0x10 (ATA bus error)

    But the DMA write failed again with the same CRC error...

> ata2: soft resetting port
> ata2.01: configured for UDMA/33
> ata2: EH complete
> sd 1:0:1:0: [sdb] Write Protect is off
> sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> ata2.01: limiting speed to UDMA/25:PIO4
> ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata2.01: (BMDMA stat 0x4)
> ata2.01: cmd ca/00:01:3f:00:00/00:00:00:00:00/f0 tag 0 cdb 0x0 data 512 out
>         res 51/84:00:3f:00:00/00:00:00:00:00/f0 Emask 0x10 (ATA bus error)

    ... and again.

> ata2: soft resetting port
> ata2.01: configured for UDMA/25
> ata2: EH complete
> ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata2.01: (BMDMA stat 0x4)
> ata2.01: cmd ca/00:01:3f:00:00/00:00:00:00:00/f0 tag 0 cdb 0x0 data 512 out
>         res 51/84:00:3f:00:00/00:00:00:00:00/f0 Emask 0x10 (ATA bus error)

    ... and again, even with UDMA 25.

> ata2: soft resetting port
> ata2.01: configured for UDMA/25
> ata2: EH complete
> sd 1:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata2.01: (BMDMA stat 0x4)
> ata2.01: cmd ca/00:01:3f:00:00/00:00:00:00:00/f0 tag 0 cdb 0x0 data 512 out
>         res 51/84:00:3f:00:00/00:00:00:00:00/f0 Emask 0x10 (ATA bus error)

    Bug is quite persistent... something's up!

> ata2: soft resetting port
> ata2.01: configured for UDMA/25
> sd 1:0:1:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
> sd 1:0:1:0: [sdb] Sense Key : 0xb [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
>        72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
>        00 00 00 3f
> sd 1:0:1:0: [sdb] ASC=0x47 ASCQ=0x0
> end_request: I/O error, dev sdb, sector 63

    Yeah, 63 == 0x3f.

> ata2: EH complete
> sd 1:0:1:0: [sdb] 234441648 512-byte hardware sectors (120034 MB)
> Filesystem "sdb1": Disabling barriers, trial barrier write failed
> sd 1:0:1:0: [sdb] Write Protect is off
> sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> XFS mounting filesystem sdb1
> sd 1:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> sd 1:0:1:0: [sdb] 234441648 512-byte hardware sectors (120034 MB)
> sd 1:0:1:0: [sdb] Write Protect is off
> sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> sd 1:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.01: cmd ca/00:00:25:9c:fc/00:00:00:00:00/f6 tag 0 cdb 0x0 data 
> 131072 out

    Thrying to DMA write 0 sectors at 0xc9c25.

>         res 40/00:00:3f:00:00/00:00:00:00:00/f0 Emask 0x4 (timeout)

    Hm, 0x40 is not normal a status value... usually, it's 0x50.  But it's 
alright anyway.

> ata2: port is slow to respond, please be patient (Status 0xfe)
> ata2: device not ready (errno=-16), forcing hardreset

    Hm...

> ata2: soft resetting port
> ata2.01: configured for UDMA/25
> ata2: EH complete
> ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.01: cmd ca/00:00:25:9c:fc/00:00:00:00:00/f6 tag 0 cdb 0x0 data 
> 131072 out
>         res 40/00:00:3f:00:00/00:00:00:00:00/f0 Emask 0x4 (timeout)

    Same here.

> ata2: port is slow to respond, please be patient (Status 0xfe)
> ata2: device not ready (errno=-16), forcing hardreset
> ata2: soft resetting port
> ata2.01: configured for UDMA/25
> ata2: EH complete
> ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.01: cmd ca/00:00:25:9c:fc/00:00:00:00:00/f6 tag 0 cdb 0x0 data 
> 131072 out
>         res 40/00:00:3f:00:00/00:00:00:00:00/f0 Emask 0x4 (timeout)

    Again strange status after writinng 0 sectors the same LBA.

[The same us repeating over and over again...]

> sd 1:0:1:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
> sd 1:0:1:0: [sdb] Sense Key : 0xb [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
>        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00

    Hm, never seen sense format 0x72... :-)
    The 2nd byte is prolly a sense key ABORTED COMMAND?

>        00 00 00 3f

   Aha, 0x3f again, this time in the SCSI sense... I've looked thru the SCSI 
spacs and found nought aboutthis format. :-(

> sd 1:0:1:0: [sdb] ASC=0x0 ASCQ=0x0
> end_request: I/O error, dev sdb, sector 117218341
> ata2: EH complete
> ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.01: cmd ca/00:00:25:9d:fc/00:00:00:00:00/f6 tag 0 cdb 0x0 data 
> 131072 out
>         res 40/00:00:3f:00:00/00:00:00:00:00/f0 Emask 0x4 (timeout)

    Then everything happily continues in the same vein but t UDMA/25 mode.
[...]

> Here is my previous post
> (not sure if anyone read it im new to mailing lists also ata1 below is 
> ata2 above since i changed it to port 2 so its the same seagate drive.)

> hello, with kernel 2.6.22.5 using the new pata_pdc202xx_old  driver it
> doesn't
> detect the cable right on this seagate drive (i tried switching ports /
> cables ...etc)

     Probably host side detecton is borked. The drived is residing alone on 
that cable?

> it detects the maxtor drive fine no matter what port its on, the seagate
> doesnt detect correctly on either port

   Hrm, then maybe it's indeed device side problem (but IIRC, libata used to 
ignore device side reporting)./

> ata1.00: ATA-6: ST3120026A, 3.06, max UDMA/100
> ata1.00: 234441648 sectors, multi 16: LBA48
> ata1.00: limited to UDMA/33 due to 40-wire cable
> ata1.00: configured for UDMA/33
> ata2.00: ATA-7: Maxtor 6B200R0, max UDMA/133
> ata2.00: 398297088 sectors, multi 16: LBA48
> ata2.00: configured for UDMA/100

> i was searching goolge and i found other uses with the same problem and had
> seagate drives (maybe the cable detect code is differnt in seagate?)

    Hardly so...

> btw only devices sda and sdb are on the pata_pdc202xx_old card.

    Not on the same cable?

> i also get this error about 50 of them
> (dmsg cut top output where it had info about the cable error) anyways if 
> you
> scroll down you will see errors like this
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata1.00: (BMDMA stat 0x4)
> ata1.00: cmd ca/00:01:3f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 512 out
>         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)

    Write of single sector 63 fails miserably with UltraDMA CRC... although, 
if you're not using UltraDMA at this moment, 0x84 may mean something 
different: bad/uncortrectable sector.

> ata1: soft resetting port
> ata1.00: configured for UDMA/33
> ata1: EH complete ..etc
> 
> .... Ends up here
> 
> ata1: EH complete
> ata1.00: limiting speed to PIO4
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata1.00: (BMDMA stat 0x4)
> ata1.00: cmd ca/00:00:21:9d:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072
> out
>         res 51/84:00:21:9d:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)

    Hmmm, the driver had just lied to you saying that it downgraded to PIO4 -- 
it still issues WRITE DMA command which failed as usual...

> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata1.00: (BMDMA stat 0x4)
> ata1.00: cmd ca/00:01:3f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 512 out
>         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
> ata1: soft resetting port
> ata1.00: configured for UDMA/33
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata1.00: (BMDMA stat 0x4)
> ata1.00: cmd ca/00:01:3f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 512 out
>         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)

    "Then it strted all over again..."

> ata1: soft resetting port
> ata1.00: configured for UDMA/25
> sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
> sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
>        72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
>        00 00 00 3f
> sd 0:0:0:0: [sda] ASC=0x47 ASCQ=0x0

    Hh, SCSI msgs cleared the forat up for me: byte 1 is a sense key, byte 2 
is ASQ (0x47 means SCSI parity error)...

> end_request: I/O error, dev sda, sector 63
> ata1: EH complete
> sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
> Filesystem "sda1": Disabling barriers, trial barrier write failed
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> XFS mounting filesystem sda1
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
> support
> DPO or FUA
> sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
> support
> DPO or FUA
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata1.00: (BMDMA stat 0x4)
> ata1.00: cmd ca/00:00:21:9c:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072
> out
>         res 51/84:00:21:9c:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)

    Again failinig DMA write of 0 sectors at LBA 826401...

> ata1: soft resetting port
> ata1.00: configured for UDMA/25
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata1.00: (BMDMA stat 0x4)
> ata1.00: cmd ca/00:00:21:9c:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072
> out
>         res 51/84:00:21:9c:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
> ata1: soft resetting port
> ata1.00: configured for UDMA/25
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata1.00: (BMDMA stat 0x4)
> ata1.00: cmd ca/00:00:21:9c:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072
> out
>         res 51/84:00:21:9c:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
> ata1: soft resetting port
> ata1.00: configured for UDMA/25
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata1.00: (BMDMA stat 0x4)
> ata1.00: cmd ca/00:00:21:9c:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072
> out
>         res 51/84:00:21:9c:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
> ata1: soft resetting port
> ata1.00: configured for UDMA/25
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata1.00: (BMDMA stat 0x4)

   It means that IDE DMA has signalled an interrupt

> ata1.00: cmd ca/00:00:21:9c:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072
> out
>         res 51/84:00:21:9c:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
> ata1: soft resetting port
> ata1.00: configured for UDMA/25
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata1.00: (BMDMA stat 0x4)
> ata1.00: cmd ca/00:00:21:9c:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072
> out
>         res 51/84:00:21:9c:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
> ata1: soft resetting port
> ata1.00: configured for UDMA/25
> sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
> sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
>        72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
>        06 fc 9c 21

    Aha, those last 4 bytes a big-endian address of a requested LBA to write to

> after the kernel finnishes booting i can mount that drive fine (also all 
> the xfs_check xfs_repair ..etc say there is no errors) but i think the drive is
> in pio4 by the time its done.

    From looking at the logs I got a feeling that the speed downgraded didn't 
work all the way to PIO...

> the ide old driver seemed to work ok with this drive also the system
> mainboard ide ports work too.

    Aha, thanks! :-)

> i tried changing the drive jumpers around and that also didnt help

> just to add i tried switching my drives around i moved a wd drive to port 2
> of the pdc controller and it worked fine so if a maxtor and a wd drive is
> hooked up it detects as udma100, this seems to be a error with seagate
> drives only, and i should also note i tried the seagate on the mainboard
> chipset (uses the pata_via.c driver) and it detected the seagate fine and
> set udma 100 on it.

    Yeah, all that is very confusing...

MBR, Sergei

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763330AbYEFMp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763330AbYEFMp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763055AbYEFMoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:44:24 -0400
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:42515 "EHLO
	ribosome.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762964AbYEFMoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:44:21 -0400
Message-ID: <4820529D.2040609@ribosome.natur.cuni.cz>
Date: Tue, 06 May 2008 14:44:13 +0200
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080328 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jan Engelhardt <jengelh@medozas.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23.17 & 2.6.24.5 and maybe earlier: pata_marvell: need to
 disable DMA to get rid of '(ATA bus error)', 'ata7.00: status: { DRDY ERR
 }', 'ata7.00: error: { ICRC ABRT }'
References: <fa.+9Q+WQnyiYTlpbXVIzn6aT2/gS0@ifi.uio.no> <fa.fKUfeQYS9BFD60fOMormQ25ard4@ifi.uio.no> <fa.QYXSW2xjSxf6xnmd0rQGJhHLnrc@ifi.uio.no> <fa.qfeYSQtlsXzGvFvBQEdF9TFFpNg@ifi.uio.no> <481BD12D.1030406@shaw.ca>
In-Reply-To: <481BD12D.1030406@shaw.ca>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Robert Hancock wrote:
> Alan Cox wrote:
>>>> libata.dma=3 will stop DMA being used for CF devices (except those that
>>>> decide to pretend to be ATA classes). This one comes up a lot as 
>>>> many CF
>>>> adapters are simply not adequate for UDMA.
>>> Perhaps the kernel could do this automatically once it sees the
>>> status code?
>>
>> We then hurt all the people with perfectly good working UDMA CF devices.
>> The kernel will eventually fall back from UDMA to PIO but it favours
>> working hardware by default.
> 
> I suspect they meant fall back on seeing the ABRT/ICRC error combination 
> - which it does, eventually. Falling back on one occurrence would be too 
> aggressive, though, as they can happen once in a blue moon, so there's 
> little reason to slow down a working setup forever because of it..

Hi, sorry for the delay. I gave it it shot instead of using libata.dma=0:

Linux version 2.6.24.5-default (root@nfssrv) (gcc version 4.1.2 (Gentoo 4.1.2 p1.1)) #1 SMP Thu May 1 13:45:06 Local time zone must be set--see zic m
Command line: root=/dev/sde1 libata.dma=3 udev
...
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:03:00.0 to 64
scsi6 : pata_marvell
scsi7 : pata_marvell
ata7: PATA max UDMA/100 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 16
ata8: PATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 16
BAR5:00:02 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:07 0D:00 0E:00 0F:00 
ata7.00: ATA-0: Delock 54111 512MB, Ver1.27, max UDMA/33
ata7.00: 1006992 sectors, multi 0: LBA 
ata7.01: ATAPI: ATAPI   DVD D  DH16D2P, HP57, max UDMA/33
ata7.00: configured for UDMA/33
ata7.01: configured for UDMA/33
ata7.00: configured for UDMA/33
ata7.01: configured for UDMA/33
ata7: EH complete
BAR5:00:02 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:07 0D:00 0E:00 0F:00 
scsi 6:0:0:0: Direct-Access     ATA      Delock 54111 512 Ver1 PQ: 0 ANSI: 5
sd 6:0:0:0: [sde] 1006992 512-byte hardware sectors (516 MB)
sd 6:0:0:0: [sde] Write Protect is off
sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 6:0:0:0: [sde] 1006992 512-byte hardware sectors (516 MB)
sd 6:0:0:0: [sde] Write Protect is off
sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1
sd 6:0:0:0: [sde] Attached SCSI disk
sd 6:0:0:0: Attached scsi generic sg4 type 0
scsi 6:0:1:0: CD-ROM            ATAPI    DVD D  DH16D2P   HP57 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 6:0:1:0: Attached scsi CD-ROM sr0
sr 6:0:1:0: Attached scsi generic sg5 type 5
...
ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata7.00: BMDMA stat 0x64
ata7.00: cmd ca/00:02:5f:40:0a/00:00:00:00:00/e0 tag 0 dma 1024 out
         res 51/84:00:5f:40:0a/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata7.00: status: { DRDY ERR }
ata7.00: error: { ICRC ABRT }
BAR5:00:02 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:07 0D:00 0E:00 0F:00 
ata7: soft resetting link
ata7.00: configured for UDMA/33
ata7.01: configured for UDMA/33
ata7.00: configured for UDMA/33
ata7.01: configured for UDMA/33
ata7: EH complete
sd 6:0:0:0: [sde] 1006992 512-byte hardware sectors (516 MB)
sd 6:0:0:0: [sde] Write Protect is off
sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 6:0:0:0: [sde] 1006992 512-byte hardware sectors (516 MB)
sd 6:0:0:0: [sde] Write Protect is off
sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata7.00: BMDMA stat 0x64
ata7.00: cmd ca/00:04:63:3f:04/00:00:00:00:00/e0 tag 0 dma 2048 out
         res 51/84:00:63:3f:04/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata7.00: status: { DRDY ERR }
ata7.00: error: { ICRC ABRT }
BAR5:00:02 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:07 0D:00 0E:00 0F:00 
ata7: soft resetting link
ata7.00: configured for UDMA/33
ata7.01: configured for UDMA/33
ata7.00: configured for UDMA/33
ata7.01: configured for UDMA/33
ata7: EH complete
ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata7.00: BMDMA stat 0x64
ata7.00: cmd ca/00:04:63:3f:04/00:00:00:00:00/e0 tag 0 dma 2048 out
         res 51/84:00:63:3f:04/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata7.00: status: { DRDY ERR }
ata7.00: error: { ICRC ABRT }
BAR5:00:02 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:07 0D:00 0E:00 0F:00 
ata7: soft resetting link
ata7.00: configured for UDMA/33
ata7.01: configured for UDMA/33
ata7.00: configured for UDMA/33
ata7.01: configured for UDMA/33
ata7: EH complete
sd 6:0:0:0: [sde] 1006992 512-byte hardware sectors (516 MB)
sd 6:0:0:0: [sde] Write Protect is off
sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 6:0:0:0: [sde] 1006992 512-byte hardware sectors (516 MB)
sd 6:0:0:0: [sde] Write Protect is off
sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
ata7.00: limiting speed to UDMA/25:PIO4
ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata7.00: BMDMA stat 0x64
ata7.00: cmd ca/00:0e:71:00:04/00:00:00:00:00/e0 tag 0 dma 7168 out
         res 51/84:00:71:00:04/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata7.00: status: { DRDY ERR }
ata7.00: error: { ICRC ABRT }
BAR5:00:02 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:07 0D:00 0E:00 0F:00 
ata7: soft resetting link
ata7.00: configured for UDMA/25
ata7.01: configured for UDMA/33
ata7.00: configured for UDMA/25
ata7.01: configured for UDMA/33
ata7: EH complete
sd 6:0:0:0: [sde] 1006992 512-byte hardware sectors (516 MB)
sd 6:0:0:0: [sde] Write Protect is off
sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 6:0:0:0: [sde] 1006992 512-byte hardware sectors (516 MB)
sd 6:0:0:0: [sde] Write Protect is off
sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata7.00: BMDMA stat 0x64
ata7.00: cmd ca/00:02:47:80:07/00:00:00:00:00/e0 tag 0 dma 1024 out
         res 51/84:00:47:80:07/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata7.00: status: { DRDY ERR }
ata7.00: error: { ICRC ABRT }
BAR5:00:02 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:07 0D:00 0E:00 0F:00 
ata7: soft resetting link
ata7.00: configured for UDMA/25
ata7.01: configured for UDMA/33
ata7.00: configured for UDMA/25
ata7.01: configured for UDMA/33
ata7: EH complete
sd 6:0:0:0: [sde] 1006992 512-byte hardware sectors (516 MB)
ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata7.00: BMDMA stat 0x64
ata7.00: cmd ca/00:02:41:80:08/00:00:00:00:00/e0 tag 0 dma 1024 out
         res 51/84:00:41:80:08/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata7.00: status: { DRDY ERR }
ata7.00: error: { ICRC ABRT }
BAR5:00:02 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:07 0D:00 0E:00 0F:00 
ata7: soft resetting link
ata7.00: configured for UDMA/25
ata7.01: configured for UDMA/33
ata7.00: configured for UDMA/25
ata7.01: configured for UDMA/33
ata7: EH complete
ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata7.00: BMDMA stat 0x64
ata7.00: cmd ca/00:02:41:80:08/00:00:00:00:00/e0 tag 0 dma 1024 out
         res 51/84:00:41:80:08/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata7.00: status: { DRDY ERR }
ata7.00: error: { ICRC ABRT }
BAR5:00:02 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:07 0D:00 0E:00 0F:00 
ata7: soft resetting link
ata7.00: configured for UDMA/25
ata7.01: configured for UDMA/33
ata7.00: configured for UDMA/25
ata7.01: configured for UDMA/33
ata7: EH complete
sd 6:0:0:0: [sde] Write Protect is off
sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata7.00: BMDMA stat 0x64
ata7.00: cmd ca/00:04:47:c2:01/00:00:00:00:00/e0 tag 0 dma 2048 out
         res 51/84:00:47:c2:01/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata7.00: status: { DRDY ERR }
ata7.00: error: { ICRC ABRT }
BAR5:00:02 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:07 0D:00 0E:00 0F:00 
ata7: soft resetting link
ata7.00: configured for UDMA/25
ata7.01: configured for UDMA/33
ata7.00: configured for UDMA/25
ata7.01: configured for UDMA/33
ata7: EH complete
sd 6:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 6:0:0:0: [sde] 1006992 512-byte hardware sectors (516 MB)
sd 6:0:0:0: [sde] Write Protect is off
sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA



That doesn't look like a fix to me. I expect the CF device run in PIO4.
Or shall I really ignore these?

Martin

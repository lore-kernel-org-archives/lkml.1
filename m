Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbYGGSID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbYGGSID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbYGGSHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:07:51 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:45864 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746AbYGGSHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:07:50 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@redhat.com>
Subject: Re: pata_it821x completely broken
Date: Mon, 7 Jul 2008 20:07:38 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
References: <200807042153.56644.linux@rainbow-software.org> <200807062350.35650.linux@rainbow-software.org> <20080706230118.GA25905@devserv.devel.redhat.com>
In-Reply-To: <20080706230118.GA25905@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072007.40818.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 July 2008 01:01:18 Alan Cox wrote:
> On Sun, Jul 06, 2008 at 11:50:33PM +0200, Ondrej Zary wrote:
> > Thanks, it does not complain about HPA anymore. However, there are some
> > error messages left. I thought that they were connected with the HPA, but
> > obviously they aren't:
>
> FLUSH_CACHE .. I would hope the firmware supports that if advertised. If so
> then adding it to the switch in it821x_smart_qc_issue might do the trick
> (ATA_CMD_FLUSH and ATA_CMD_FLUSH_EXT). I'd be interested to know if your
> firmware seems to support that or whether the entire thing goes castors up
> if it gets through.

It breaks - I get more errors and it takes ages to reboot. Looks like the 
firmware does not like that command. I don't believe that it's so stupid - is 
it even possible to safely turn off the machine when neither FLUSH nor STOP 
command can be issued?

sd 2:0:0:0: [sdb] Synchronizing SCSI cache
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: port is slow to respond, please be patient (Status 0xd0)
ata3: device not ready (errno=-16), forcing hardreset
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: port is slow to respond, please be patient (Status 0xd0)
ata3: device not ready (errno=-16), forcing hardreset
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: port is slow to respond, please be patient (Status 0xd0)
ata3: device not ready (errno=-16), forcing hardreset
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
ata3.00: limiting speed to UDMA/133:PIO6
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: port is slow to respond, please be patient (Status 0xd0)
ata3: device not ready (errno=-16), forcing hardreset
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: port is slow to respond, please be patient (Status 0xd0)
ata3: device not ready (errno=-16), forcing hardreset
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: port is slow to respond, please be patient (Status 0xd0)
ata3: device not ready (errno=-16), forcing hardreset
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
sd 2:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 2:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: port is slow to respond, please be patient (Status 0xd0)
ata3: device not ready (errno=-16), forcing hardreset
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
ata3.00: limiting speed to UDMA/33:PIO6
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: port is slow to respond, please be patient (Status 0xd0)
ata3: device not ready (errno=-16), forcing hardreset
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: port is slow to respond, please be patient (Status 0xd0)
ata3: device not ready (errno=-16), forcing hardreset
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: port is slow to respond, please be patient (Status 0xd0)
ata3: device not ready (errno=-16), forcing hardreset
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: port is slow to respond, please be patient (Status 0xd0)
ata3: device not ready (errno=-16), forcing hardreset
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: port is slow to respond, please be patient (Status 0xd0)
ata3: device not ready (errno=-16), forcing hardreset
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
sd 2:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 2:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: port is slow to respond, please be patient (Status 0xd0)
ata3: device not ready (errno=-16), forcing hardreset
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: port is slow to respond, please be patient (Status 0xd0)
ata3: device not ready (errno=-16), forcing hardreset
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
ata3.00: limiting speed to PIO6
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: port is slow to respond, please be patient (Status 0xd0)
ata3: device not ready (errno=-16), forcing hardreset
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: port is slow to respond, please be patient (Status 0xd0)
ata3: device not ready (errno=-16), forcing hardreset
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: port is slow to respond, please be patient (Status 0xd0)
ata3: device not ready (errno=-16), forcing hardreset
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: port is slow to respond, please be patient (Status 0xd0)
ata3: device not ready (errno=-16), forcing hardreset
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
sd 2:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 2:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 2:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
sd 2:0:0:0: [sdb] Sense Key : 0xb [current] [descriptor]
sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Restarting system.
machine restart



>
> Alan



-- 
Ondrej Zary

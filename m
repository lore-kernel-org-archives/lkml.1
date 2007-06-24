Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbXFXTxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbXFXTxp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 15:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbXFXTxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 15:53:37 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:16558 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbXFXTxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 15:53:36 -0400
Date: Sun, 24 Jun 2007 13:53:28 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Frequent SATA resets with sata_nv (fwd)
In-reply-to: <fa.Z5bo5y2TvW4efa6slAJpcdPwqAA@ifi.uio.no>
To: "Matthew \"Cheetah\" Gabeler-Lee" <cheetah-lkmlsata@fastcat.org>
Cc: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>
Message-id: <467ECBB8.2030706@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Z5bo5y2TvW4efa6slAJpcdPwqAA@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(ccing linux-ide)

Matthew "Cheetah" Gabeler-Lee wrote:
> (Please cc me on replies)
> 
> I have three samsung hdds (/sys/block/sda/device/model says SAMSUNG 
> SP2504C) in a raid configuration.  My system frequently (2-3x/day) 
> experiences temporary lockups, which produce messages as below in my 
> dmesg/syslog.  The system recovers, but the hang is annoying to say the 
> least.
> 
> All three drives are connected to sata_nv ports.  Oddly, it almost 
> always happens on ata6 or ata7 (the second and third ports of that 4 
> port setup on my motherboard).  There is an identical drive connected at 
> ata5, but I've only once or twice seen it hit that drive.
> 
> Googling around lkml.org, I found a few threads investigating what look 
> like very similar problems, some of which never seemed to find the 
> solution, but one of which came up with a fairly quick answer it seemed, 
> namely that the drive's NCQ implementation was horked: 
> http://lkml.org/lkml/2007/4/18/32
> 
> While I don't have older logs to verify exactly when this started, it 
> was fairly recent, perhaps around my 2.6.20.1 to 2.6.21.1 kernel 
> upgrade.
> 
> Any other info or tests I can provide/run to help?
> 
> Syslog snippet:
> Jun 21 10:35:23 cheetah kernel: ata6: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x400 next cpb count 0x0 next cpb idx 0x0
> Jun 21 10:35:24 cheetah kernel: ata6: CPB 0: ctl_flags 0x9, resp_flags 0x0
> Jun 21 10:35:24 cheetah kernel: ata6: timeout waiting for ADMA IDLE, stat=0x400
> Jun 21 10:35:24 cheetah kernel: ata6: timeout waiting for ADMA LEGACY, stat=0x400
> Jun 21 10:35:24 cheetah kernel: ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> Jun 21 10:35:24 cheetah kernel: ata6.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0
> Jun 21 10:35:24 cheetah kernel:          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> Jun 21 10:35:24 cheetah kernel: ata6: soft resetting port
> Jun 21 10:35:24 cheetah kernel: ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Jun 21 10:35:24 cheetah kernel: ata6.00: configured for UDMA/133
> Jun 21 10:35:24 cheetah kernel: ata6: EH complete
> Jun 21 10:35:24 cheetah kernel: SCSI device sdb: 488397168 512-byte hdwr sectors (250059 MB)
> Jun 21 10:35:24 cheetah kernel: sdb: Write Protect is off
> Jun 21 10:35:24 cheetah kernel: sdb: Mode Sense: 00 3a 00 00
> Jun 21 10:35:24 cheetah kernel: SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Unfortunately, this kind of problem is rather difficult to diagnose. 
Essentially what's happened is that we've sent a command (in this case a 
cache flush) to the controller but it's given no indication that it's 
done anything with it (somewhat different from the case in the link you 
mentioned above, where the controller indicates it's sent the command 
and is waiting for completion). This could be some kind of drive issue 
or drive/controller incompatibility, a controller bug, the driver doing 
something the controller doesn't expect..

Does this drive actually support NCQ? I can't tell from this part of the 
  log.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


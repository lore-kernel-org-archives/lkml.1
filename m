Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbXBWA0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbXBWA0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 19:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbXBWA0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 19:26:11 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:53405 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbXBWA0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 19:26:10 -0500
Date: Thu, 22 Feb 2007 18:25:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
In-reply-to: <fa.htPXmkKzsdLgiNC0YHDJwdgDLHg@ifi.uio.no>
To: Rolf Offermanns <roffermanns@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <45DE346B.2070301@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no>
 <fa.YHt2nIlQmoW5r2enmTSzsaySwH4@ifi.uio.no>
 <fa.7/l6y5w9DWACpMl9PLWnCeZVtaY@ifi.uio.no>
 <fa.jM0Jz2vqE6sFKJ24x7Krs9Md4+Y@ifi.uio.no>
 <fa.htPXmkKzsdLgiNC0YHDJwdgDLHg@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rolf Offermanns wrote:
> I hear the same strange noise on poweroff (2.6.20 vanilla). This is what I
> get on my system with ATA_DEBUG and ATA_VERBOSE_DEBUG both defined. The
> system will *not* poweroff with "halt -f" so there was no noise!
> 
> md: stopping all md devices.
> Synchronizing SCSI cache for disk sda:
> ata_scsi_dump_cdb: CDB (1:0,0,0) 35 00 00 00 00 00 00 00 00
> ata_scsi_translate: ENTER
> ata1: ata_dev_select: ENTER, ata1: device 0, wait 1
> ata_tf_load_pio: device 0xA0
> ata_exec_command_pio: ata1: cmd 0xE7
> ata_scsi_translate: EXIT
> ata_host_intr: ata1: protocol 1 task_state 2
> ata_hsm_move: ata1: protocol 1 task_state 2 (dev_stat 0x50)
> ata_hsm_move: ata1: dev 0 command complete, drv_stat 0x50
> System halted.
> 
> If I do a sysrq-o right after this, the above message repeate once more and
> the system turns off w/o the disturbing noise.
> 
> For the next messages, I booted the system completely (no init=/bin/sh) and
> did a "poweroff" at the console prompt after the boot was completed. This
> time the noise was there.

 From these traces you can clearly see that no STANDBY IMMEDIATE 
(command code 0xE0) was issued before the power-off, which is what would 
prevent this problem.

If you wait long enough after halting before you power down, you may not 
get the noise, since many laptop drives unload the heads after a fairly 
short period of inactivity, and so the heads are already unloaded when 
the power is shut off.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


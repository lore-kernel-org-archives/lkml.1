Return-Path: <linux-kernel-owner+w=401wt.eu-S1751627AbXBVPWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbXBVPWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbXBVPWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:22:44 -0500
Received: from main.gmane.org ([80.91.229.2]:35526 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbXBVPWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:22:43 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Rolf Offermanns <roffermanns@gmail.com>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Date: Thu, 22 Feb 2007 16:22:20 +0100
Message-ID: <erkcfc$f3n$1@sea.gmane.org>
References: <e5ab0f710702211415p37444279td690c2db4b4ca8ab@mail.gmail.com> <20070221235541.35f3d0da@lxorguk.ukuu.org.uk> <e5ab0f710702211701u4c5b62c5jb560f166641512ff@mail.gmail.com> <20070222135306.4eb757c2@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 62.8.134.2
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:

>> However, i'm not still sure i enabled as much debugging info as i
>> could in the kernel configuration. If you need more, please point me
>> to precise configuration options.
> 
> You grabbed a lot of junk but you did grab this line
> 
> [17179682.560000] Synchronizing SCSI cache for disk sda:
> 
> Which means sd_sync_cache got called and flushed the data to disk.
> 
> I don't think you can do the other needed debugging without a recompile.
> 
> The following will generate a vast amount of debug of which only the end
> matters. You may well want to build a kernel this way, boot it with
> init=/bin/sh and then at the shell prompt do "halt -f" so you don't get
> too much debug
> 
> In include/linux/libata.h change
> 
> #undef ATA_DEBUG                /* debugging output */
> #undef ATA_VERBOSE_DEBUG        /* yet more debugging output */
> 
> so both of the undef-s read define
> 
> #define ATA_DEBUG
> #define ATA_VERBOSE_DEBUG
> 
> and recompile
I hear the same strange noise on poweroff (2.6.20 vanilla). This is what I
get on my system with ATA_DEBUG and ATA_VERBOSE_DEBUG both defined. The
system will *not* poweroff with "halt -f" so there was no noise!

md: stopping all md devices.
Synchronizing SCSI cache for disk sda:
ata_scsi_dump_cdb: CDB (1:0,0,0) 35 00 00 00 00 00 00 00 00
ata_scsi_translate: ENTER
ata1: ata_dev_select: ENTER, ata1: device 0, wait 1
ata_tf_load_pio: device 0xA0
ata_exec_command_pio: ata1: cmd 0xE7
ata_scsi_translate: EXIT
ata_host_intr: ata1: protocol 1 task_state 2
ata_hsm_move: ata1: protocol 1 task_state 2 (dev_stat 0x50)
ata_hsm_move: ata1: dev 0 command complete, drv_stat 0x50
System halted.

If I do a sysrq-o right after this, the above message repeate once more and
the system turns off w/o the disturbing noise.

For the next messages, I booted the system completely (no init=/bin/sh) and
did a "poweroff" at the console prompt after the boot was completed. This
time the noise was there.

ata_host_intr: ata1: protocol 3 task_state 2
ata_host_intr: ata1: host_stat 0x24
ata_hsm_move: ata1: protocol 3 task_state 2 (dev_stat 0x50)
ata_hsm_move: ata1: dev 0 command complete, drv_stat 0x50
ata_sg_clean: unmapping 1 sg elements
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 04 b5 d4 c8 00 00 08
ata_scsi_translate: ENTER
scsi_10_lba_len: ten-byte command
ata_sg_setup: ENTER, ata1
ata_sg_setup: 1 sg elements mapped
ata_fill_sg: PRD[0] = (0x39A63000, 0x1000)
ata_tf_load_pio: feat 0x0 nsect 0x8 lba 0xC8 0xD4 0xB5
ata_tf_load_pio: device 0xE4
ata_exec_command_pio: ata1: cmd 0xC8
ata_scsi_translate: EXIT
ata_host_intr: ata1: protocol 3 task_state 2
ata_host_intr: ata1: host_stat 0x24
ata_hsm_move: ata1: protocol 3 task_state 2 (dev_stat 0x50)
ata_hsm_move: ata1: dev 0 command complete, drv_stat 0x50
ata_sg_clean: unmapping 1 sg elements
ata_scsi_dump_cdb: CDB (1:0,0,0) 35 00 00 00 00 00 00 00 00
ata_scsi_translate: ENTER
ata_tf_load_pio: device 0xA0
ata_exec_command_pio: ata1: cmd 0xE7
ata_scsi_translate: EXIT
ata_host_intr: ata1: protocol 1 task_state 2
ata_hsm_move: ata1: protocol 1 task_state 2 (dev_stat 0x50)
ata_hsm_move: ata1: dev 0 command complete, drv_stat 0x50
Power down.


HTH,
Rolf


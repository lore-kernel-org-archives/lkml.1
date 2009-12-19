Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbZLSW0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbZLSW0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 17:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbZLSW0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 17:26:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52447
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902AbZLSW0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 17:26:17 -0500
Date: Sat, 19 Dec 2009 14:26:17 -0800 (PST)
Message-Id: <20091219.142617.71129640.davem@davemloft.net>
To: mroos@linux.ee
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: pata_cmd64x broken in 2.6.33-rc1 on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.0912200017540.17801@math.ut.ee>
References: <alpine.SOC.1.00.0912200017540.17801@math.ut.ee>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Sun, 20 Dec 2009 00:23:14 +0200 (EET)

> This running on Sun Ultra 5 with CMD646 onboard ide.

Not CC:'ing linux-ide on reports like this is a good way
for your report to get lost and not looked at in a timely
manner, fixed :-)

> scsi0 : pata_cmd64x
> scsi1 : pata_cmd64x
> ata1: PATA max MWDMA2 cmd 0x1fe02c00000 ctl 0x1fe02c00008 bmdma 0x1fe02c00020 irq 14
> ata2: PATA max MWDMA2 cmd 0x1fe02c00010 ctl 0x1fe02c00018 bmdma 0x1fe02c00028 irq 14
> pata_cmd64x: active 10 recovery 10 setup 3.
> pata_cmd64x: active 10 recovery 10 setup 3.
> PCI: Enabling device: (0000:01:01.1), cmd 2
> sunhme.c:v3.10 August 26, 2008 David S. Miller (davem@davemloft.net)
> eth0: HAPPY MEAL (PCI/CheerIO) 10/100BaseT Ethernet 08:00:20:f8:c7:72
> mice: PS/2 mouse device common for all mice
> ------------[ cut here ]------------
> WARNING: at drivers/ata/pata_cmd64x.c:268 cmd64x_bmdma_stop+0x3c/0x60()
> Modules linked in:
> Call Trace:
>  [000000000064987c] cmd64x_bmdma_stop+0x3c/0x60
>  [0000000000644610] ata_sff_post_internal_cmd+0x30/0x60
>  [0000000000635910] ata_exec_internal_sg+0x310/0x4e0
>  [0000000000635b30] ata_exec_internal+0x50/0x80
>  [0000000000635ddc] ata_do_dev_read_id+0x1c/0x40
>  [0000000000635fb0] ata_dev_read_id+0x1b0/0x5c0
>  [00000000006423a8] ata_eh_recover+0x5c8/0x1280
>  [0000000000643288] ata_do_eh+0x28/0xa0
>  [0000000000643e94] ata_scsi_error+0x374/0x600
>  [00000000006221ec] scsi_error_handler+0xcc/0x460
>  [000000000046fdc0] kthread+0x60/0x80
>  [000000000042b4b0] kernel_thread+0x30/0x60
>  [000000000046fd1c] kthreadd+0x9c/0xe0
> ---[ end trace 61a1d617a7f4a94d ]---
> rtc-m48t59 rtc-m48t59.0: rtc core: registered m48t59 as rtc0
> TCP cubic registered
> NET: Registered protocol family 17
> registered taskstats version 1
> rtc-m48t59 rtc-m48t59.0: setting system clock to 2009-12-19 22:14:41 UTC (1261260881)
> ------------[ cut here ]------------
> WARNING: at drivers/ata/pata_cmd64x.c:268 cmd64x_bmdma_stop+0x3c/0x60()
> Modules linked in:
> Call Trace:
>  [000000000064987c] cmd64x_bmdma_stop+0x3c/0x60
>  [0000000000644610] ata_sff_post_internal_cmd+0x30/0x60
>  [0000000000635910] ata_exec_internal_sg+0x310/0x4e0
>  [0000000000635b30] ata_exec_internal+0x50/0x80
>  [0000000000636e1c] ata_dev_configure+0x63c/0x1780
>  [0000000000642604] ata_eh_recover+0x824/0x1280
>  [0000000000643288] ata_do_eh+0x28/0xa0
>  [0000000000643e94] ata_scsi_error+0x374/0x600
>  [00000000006221ec] scsi_error_handler+0xcc/0x460
>  [000000000046fdc0] kthread+0x60/0x80
>  [000000000042b4b0] kernel_thread+0x30/0x60
>  [000000000046fd1c] kthreadd+0x9c/0xe0
> ---[ end trace 61a1d617a7f4a94f ]---
> ata1.00: HPA detected: current 234375000, native 234441648
> ata1.00: ATA-5: WDC WD1200JB-75CRA0, 16.06V16, max UDMA/100
> ata1.00: 234375000 sectors, multi 0: LBA
> pata_cmd64x: active 3 recovery 1 setup 1.
> pata_cmd64x: active 3 recovery 1 setup 1.
> input: Sun Mouse as /devices/root/f005f9c0/f00601b4/f0061504/f0064df4/serio1/input/input0
> ------------[ cut here ]------------
> WARNING: at drivers/ata/pata_cmd64x.c:268 cmd64x_bmdma_stop+0x3c/0x60()
> Modules linked in:
> Call Trace:
>  [000000000064987c] cmd64x_bmdma_stop+0x3c/0x60
>  [0000000000644610] ata_sff_post_internal_cmd+0x30/0x60
>  [0000000000635910] ata_exec_internal_sg+0x310/0x4e0
>  [0000000000635b30] ata_exec_internal+0x50/0x80
>  [000000000063888c] ata_do_set_mode+0x6cc/0xb00
>  [000000000063f164] ata_set_mode+0x144/0x160
>  [0000000000642cf4] ata_eh_recover+0xf14/0x1280
>  [0000000000643288] ata_do_eh+0x28/0xa0
>  [0000000000643e94] ata_scsi_error+0x374/0x600
>  [00000000006221ec] scsi_error_handler+0xcc/0x460
>  [000000000046fdc0] kthread+0x60/0x80
>  [000000000042b4b0] kernel_thread+0x30/0x60
>  [000000000046fd1c] kthreadd+0x9c/0xe0
> ---[ end trace 61a1d617a7f4a950 ]---
> ------------[ cut here ]------------
> WARNING: at drivers/ata/pata_cmd64x.c:268 cmd64x_bmdma_stop+0x3c/0x60()
> Modules linked in:
> Call Trace:
>  [000000000064987c] cmd64x_bmdma_stop+0x3c/0x60
>  [0000000000644610] ata_sff_post_internal_cmd+0x30/0x60
>  [0000000000635910] ata_exec_internal_sg+0x310/0x4e0
>  [0000000000635b30] ata_exec_internal+0x50/0x80
>  [0000000000635ddc] ata_do_dev_read_id+0x1c/0x40
>  [0000000000635fb0] ata_dev_read_id+0x1b0/0x5c0
>  [00000000006365b0] ata_dev_reread_id+0x30/0x1a0
>  [0000000000638004] ata_dev_revalidate+0xa4/0x260
>  [00000000006388bc] ata_do_set_mode+0x6fc/0xb00
>  [000000000063f164] ata_set_mode+0x144/0x160
>  [0000000000642cf4] ata_eh_recover+0xf14/0x1280
>  [0000000000643288] ata_do_eh+0x28/0xa0
>  [0000000000643e94] ata_scsi_error+0x374/0x600
>  [00000000006221ec] scsi_error_handler+0xcc/0x460
>  [000000000046fdc0] kthread+0x60/0x80
>  [000000000042b4b0] kernel_thread+0x30/0x60
> ---[ end trace 61a1d617a7f4a951 ]---
> ------------[ cut here ]------------
> WARNING: at drivers/ata/pata_cmd64x.c:268 cmd64x_bmdma_stop+0x3c/0x60()
> Modules linked in:
> Call Trace:
>  [000000000064987c] cmd64x_bmdma_stop+0x3c/0x60
>  [0000000000644610] ata_sff_post_internal_cmd+0x30/0x60
>  [0000000000635910] ata_exec_internal_sg+0x310/0x4e0
>  [0000000000635b30] ata_exec_internal+0x50/0x80
>  [0000000000636e1c] ata_dev_configure+0x63c/0x1780
>  [00000000006380d4] ata_dev_revalidate+0x174/0x260
>  [00000000006388bc] ata_do_set_mode+0x6fc/0xb00
>  [000000000063f164] ata_set_mode+0x144/0x160
>  [0000000000642cf4] ata_eh_recover+0xf14/0x1280
>  [0000000000643288] ata_do_eh+0x28/0xa0
>  [0000000000643e94] ata_scsi_error+0x374/0x600
>  [00000000006221ec] scsi_error_handler+0xcc/0x460
>  [000000000046fdc0] kthread+0x60/0x80
>  [000000000042b4b0] kernel_thread+0x30/0x60
>  [000000000046fd1c] kthreadd+0x9c/0xe0
> ---[ end trace 61a1d617a7f4a952 ]---
> ata1.00: configured for MWDMA2
> scsi 0:0:0:0: Direct-Access     ATA      WDC WD1200JB-75C 16.0 PQ: 0 ANSI: 5
> sd 0:0:0:0: [sda] 234375000 512-byte logical blocks: (120 GB/111 GiB)
> pata_cmd64x: active 10 recovery 10 setup 3.
> pata_cmd64x: active 10 recovery 10 setup 3.
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> ------------[ cut here ]------------
> WARNING: at drivers/ata/pata_cmd64x.c:268 cmd64x_bmdma_stop+0x3c/0x60()
> Modules linked in:
> Call Trace:
>  [000000000064987c] cmd64x_bmdma_stop+0x3c/0x60
>  [0000000000644610] ata_sff_post_internal_cmd+0x30/0x60
>  [0000000000635910] ata_exec_internal_sg+0x310/0x4e0
>  [0000000000635b30] ata_exec_internal+0x50/0x80
>  [0000000000635ddc] ata_do_dev_read_id+0x1c/0x40
>  [0000000000635fb0] ata_dev_read_id+0x1b0/0x5c0
>  [00000000006423a8] ata_eh_recover+0x5c8/0x1280
>  [0000000000643288] ata_do_eh+0x28/0xa0
>  [0000000000643e94] ata_scsi_error+0x374/0x600
>  [00000000006221ec] scsi_error_handler+0xcc/0x460
>  [000000000046fdc0] kthread+0x60/0x80
>  [000000000042b4b0] kernel_thread+0x30/0x60
>  [000000000046fd1c] kthreadd+0x9c/0xe0
> ---[ end trace 61a1d617a7f4a953 ]---
> ata2.00: ATAPI: CRD-8322B, 1.06, max MWDMA2
> pata_cmd64x: active 3 recovery 1 setup 1.
> pata_cmd64x: active 3 recovery 1 setup 1.
>  sda:
> 
> 
> and hangs here.
> 
> -- 
> Meelis Roos (mroos@linux.ee)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

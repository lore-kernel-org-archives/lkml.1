Return-Path: <linux-kernel-owner+w=401wt.eu-S1761685AbXHXMnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761685AbXHXMnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbXHXMnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:43:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59408 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759357AbXHXMnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:43:00 -0400
Message-ID: <46CED24F.1020400@onlinehome.de>
Date: Fri, 24 Aug 2007 14:42:55 +0200
From: Felix Homann <fexpop@onlinehome.de>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Regressions w.r.t. suspend behaviour in recent kernel versions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+R28swbXsHa9Sc1vtaUD0VGnyGP8pJAyw0xBZ
 Rp5riDWzVKHGd0f1Ztcd/yGAcM6E/M2p9vx3dyRiy3nX3TMPrv
 p1dv7bIV/ptYhlSvYH4wdANuNmYcPoM
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been experiencing several problems with s2ram/s2disk with recent 
kernels (mostly starting with 2.6.19):

1. s2disk won't work without the nolapic kernel option.

I didn't have to use that option with kernels < 2.6.19. I only found out 
that I need this option with the kind help from Rafael Wysocki. 
Unfortunately, using the nolapic option raises new problems as I'm 
getting these warnings at boot time (with kernel 2.6.23-rc2):

++++++++++++++++++++++++++++++++++++

Aug  9 00:22:13 jawaka kernel: EXT3-fs: mounted filesystem with ordered
data mode.
Aug  9 00:22:13 jawaka kernel: WARNING: at kernel/irq/resend.c:70
check_irq_resend()
Aug  9 00:22:13 jawaka kernel:  [<c014afab>] check_irq_resend+0xab/0xc0
Aug  9 00:22:13 jawaka kernel:  [<c014ab99>] enable_irq+0xc9/0xd0
Aug  9 00:22:13 jawaka kernel:  [<c026ab54>]
ide_config_drive_speed+0x164/0x380
Aug  9 00:22:13 jawaka kernel:  [<c0266162>] piix_tune_chipset+0x1f2/0x3d0
Aug  9 00:22:13 jawaka kernel:  [<c0270bfb>] ide_tune_dma+0x3b/0x50
Aug  9 00:22:13 jawaka kernel:  [<c0265eec>]
piix_config_drive_xfer_rate+0xc/0x40
Aug  9 00:22:13 jawaka kernel:  [<c026fbfe>] ide_set_dma+0xe/0x40
Aug  9 00:22:13 jawaka kernel:  [<c0266c2d>] set_using_dma+0x8d/0xe0
Aug  9 00:22:13 jawaka kernel:  [<c0266ba0>] set_using_dma+0x0/0xe0
Aug  9 00:22:13 jawaka kernel:  [<c026797c>] generic_ide_ioctl+0xdc/0x430
Aug  9 00:22:13 jawaka kernel:  [<c0273722>] idedisk_ioctl+0xf2/0x120
Aug  9 00:22:13 jawaka kernel:  [<c01eb900>] blk_end_sync_rq+0x0/0x30
Aug  9 00:22:13 jawaka kernel:  [<c0273672>] idedisk_ioctl+0x42/0x120
Aug  9 00:22:13 jawaka kernel:  [<c0273630>] idedisk_ioctl+0x0/0x120
Aug  9 00:22:13 jawaka kernel:  [<c01ee194>] blkdev_driver_ioctl+0x54/0x60
Aug  9 00:22:13 jawaka kernel:  [<c01ee538>] blkdev_ioctl+0x358/0x7b0
Aug  9 00:22:13 jawaka kernel:  [<c02faefb>] _read_unlock_irq+0x1b/0x20
Aug  9 00:22:13 jawaka kernel:  [<c0157e7f>] __do_fault+0x15f/0x340
Aug  9 00:22:13 jawaka kernel:  [<c0157e23>] __do_fault+0x103/0x340
Aug  9 00:22:13 jawaka kernel:  [<c0157e88>] __do_fault+0x168/0x340
Aug  9 00:22:13 jawaka kernel:  [<c01160bb>] do_page_fault+0x18b/0x6b0
Aug  9 00:22:13 jawaka kernel:  [<c0115ff7>] do_page_fault+0xc7/0x6b0
Aug  9 00:22:13 jawaka kernel:  [<c0134384>] up_read+0x14/0x30
Aug  9 00:22:13 jawaka kernel:  [<c0190388>] block_ioctl+0x18/0x20
Aug  9 00:22:13 jawaka kernel:  [<c0190370>] block_ioctl+0x0/0x20
Aug  9 00:22:13 jawaka kernel:  [<c0176e8f>] do_ioctl+0x1f/0x70
Aug  9 00:22:13 jawaka kernel:  [<c0176f3c>] vfs_ioctl+0x5c/0x260
Aug  9 00:22:13 jawaka kernel:  [<c01771b2>] sys_ioctl+0x72/0x90
Aug  9 00:22:13 jawaka kernel:  [<c01040de>] syscall_call+0x7/0xb
Aug  9 00:22:13 jawaka kernel:  =======================
Aug  9 00:22:13 jawaka kernel: Linux agpgart interface v0.102

+++++++++++++++++++++++++++++++++

Without the nolapic option the kernel will panic when trying to suspend 
to disk. Here are the last lines of the kernel output:

EIP: [<c01127fd> lapic_nmi_suspend+0x1d/0x30 ss:ESP 0068:c1ae3ec8
Kernel panic - not syncing: Attempted to kill init!

Rafael advised me to post directly to the LKML on this issue and so I do.

You can follow the whole discussion with Rafael here:

http://sourceforge.net/mailarchive/forum.php?thread_name=46A9A9A8.2070209%40onlinehome.de&forum_name=suspend-devel
http://sourceforge.net/mailarchive/forum.php?thread_name=200708062038.41452.rjw%40sisk.pl&forum_name=suspend-devel

2. s2ram won't work with kernels > 2.6.18 if the fglrx module is loaded.

Please, don't stone me for using the fglrx driver, without it I couldn't 
  suspend at all. Unfortunately, I'm stuck to kernel 2.6.18 at the 
moment since it's the last kernel that would suspend to ram with the 
fglrx module loaded. With more recent kernels the system will hang with 
"Suspending console(s)".

3. Even with the 2.6.18 kernel sound won't work after suspending to ram. 
I don't know when this started, but I know that this has not been an 
issue in the past.

Please, let me know what additional information you might need.

Kind regards,

Felix


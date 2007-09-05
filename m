Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbXIEQhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbXIEQhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbXIEQhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:37:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39808 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756517AbXIEQhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:37:23 -0400
Date: Wed, 5 Sep 2007 09:36:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Felix Homann <fexpop@onlinehome.de>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andi Kleen <ak@suse.de>
Subject: Re: Regressions w.r.t. suspend behaviour in recent kernel versions
Message-Id: <20070905093605.ac755ce6.akpm@linux-foundation.org>
In-Reply-To: <46CED24F.1020400@onlinehome.de>
References: <46CED24F.1020400@onlinehome.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 24 Aug 2007 14:42:55 +0200 Felix Homann <fexpop@onlinehome.de> wrote:

Nearly two weeks, zero replies.

> Hi,
> 
> I've been experiencing several problems with s2ram/s2disk with recent 
> kernels (mostly starting with 2.6.19):
> 
> 1. s2disk won't work without the nolapic kernel option.
> 
> I didn't have to use that option with kernels < 2.6.19. I only found out 
> that I need this option with the kind help from Rafael Wysocki. 
> Unfortunately, using the nolapic option raises new problems as I'm 
> getting these warnings at boot time (with kernel 2.6.23-rc2):
> 
> ++++++++++++++++++++++++++++++++++++
> 
> Aug  9 00:22:13 jawaka kernel: EXT3-fs: mounted filesystem with ordered
> data mode.
> Aug  9 00:22:13 jawaka kernel: WARNING: at kernel/irq/resend.c:70
> check_irq_resend()
> Aug  9 00:22:13 jawaka kernel:  [<c014afab>] check_irq_resend+0xab/0xc0
> Aug  9 00:22:13 jawaka kernel:  [<c014ab99>] enable_irq+0xc9/0xd0
> Aug  9 00:22:13 jawaka kernel:  [<c026ab54>]
> ide_config_drive_speed+0x164/0x380
> Aug  9 00:22:13 jawaka kernel:  [<c0266162>] piix_tune_chipset+0x1f2/0x3d0
> Aug  9 00:22:13 jawaka kernel:  [<c0270bfb>] ide_tune_dma+0x3b/0x50
> Aug  9 00:22:13 jawaka kernel:  [<c0265eec>]
> piix_config_drive_xfer_rate+0xc/0x40
> Aug  9 00:22:13 jawaka kernel:  [<c026fbfe>] ide_set_dma+0xe/0x40
> Aug  9 00:22:13 jawaka kernel:  [<c0266c2d>] set_using_dma+0x8d/0xe0
> Aug  9 00:22:13 jawaka kernel:  [<c0266ba0>] set_using_dma+0x0/0xe0
> Aug  9 00:22:13 jawaka kernel:  [<c026797c>] generic_ide_ioctl+0xdc/0x430
> Aug  9 00:22:13 jawaka kernel:  [<c0273722>] idedisk_ioctl+0xf2/0x120
> Aug  9 00:22:13 jawaka kernel:  [<c01eb900>] blk_end_sync_rq+0x0/0x30
> Aug  9 00:22:13 jawaka kernel:  [<c0273672>] idedisk_ioctl+0x42/0x120
> Aug  9 00:22:13 jawaka kernel:  [<c0273630>] idedisk_ioctl+0x0/0x120
> Aug  9 00:22:13 jawaka kernel:  [<c01ee194>] blkdev_driver_ioctl+0x54/0x60
> Aug  9 00:22:13 jawaka kernel:  [<c01ee538>] blkdev_ioctl+0x358/0x7b0
> Aug  9 00:22:13 jawaka kernel:  [<c02faefb>] _read_unlock_irq+0x1b/0x20
> Aug  9 00:22:13 jawaka kernel:  [<c0157e7f>] __do_fault+0x15f/0x340
> Aug  9 00:22:13 jawaka kernel:  [<c0157e23>] __do_fault+0x103/0x340
> Aug  9 00:22:13 jawaka kernel:  [<c0157e88>] __do_fault+0x168/0x340
> Aug  9 00:22:13 jawaka kernel:  [<c01160bb>] do_page_fault+0x18b/0x6b0
> Aug  9 00:22:13 jawaka kernel:  [<c0115ff7>] do_page_fault+0xc7/0x6b0
> Aug  9 00:22:13 jawaka kernel:  [<c0134384>] up_read+0x14/0x30
> Aug  9 00:22:13 jawaka kernel:  [<c0190388>] block_ioctl+0x18/0x20
> Aug  9 00:22:13 jawaka kernel:  [<c0190370>] block_ioctl+0x0/0x20
> Aug  9 00:22:13 jawaka kernel:  [<c0176e8f>] do_ioctl+0x1f/0x70
> Aug  9 00:22:13 jawaka kernel:  [<c0176f3c>] vfs_ioctl+0x5c/0x260
> Aug  9 00:22:13 jawaka kernel:  [<c01771b2>] sys_ioctl+0x72/0x90
> Aug  9 00:22:13 jawaka kernel:  [<c01040de>] syscall_call+0x7/0xb

I expect that got fixed in later kernels.

Beware that 2.6.24-rc5 is uselessly buggy, so
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.23-rc5-git1.gz
would be a better kernel to test to check that we fixed this warning.


> Aug  9 00:22:13 jawaka kernel:  =======================
> Aug  9 00:22:13 jawaka kernel: Linux agpgart interface v0.102
> 
> +++++++++++++++++++++++++++++++++
> 
> Without the nolapic option the kernel will panic when trying to suspend 
> to disk.

A *large* number of people need noapic or nolapic to get Linux to work.

> Here are the last lines of the kernel output:
> 
> EIP: [<c01127fd> lapic_nmi_suspend+0x1d/0x30 ss:ESP 0068:c1ae3ec8
> Kernel panic - not syncing: Attempted to kill init!

Are you able to provide us with more information about this bug?  A digital
photograph of the screen would suit, or perhaps you can generate a full
trace with netconsole (Documentation/networking/netconsole.txt), although
suspend+netconsole tends to be a bad (and recently worsening) combination.

> Rafael advised me to post directly to the LKML on this issue and so I do.

Thanks.  Please continue to do so.

> You can follow the whole discussion with Rafael here:
> 
> http://sourceforge.net/mailarchive/forum.php?thread_name=46A9A9A8.2070209%40onlinehome.de&forum_name=suspend-devel
> http://sourceforge.net/mailarchive/forum.php?thread_name=200708062038.41452.rjw%40sisk.pl&forum_name=suspend-devel
> 
> 2. s2ram won't work with kernels > 2.6.18 if the fglrx module is loaded.
> 
> Please, don't stone me for using the fglrx driver, without it I couldn't 
>   suspend at all. Unfortunately, I'm stuck to kernel 2.6.18 at the 
> moment since it's the last kernel that would suspend to ram with the 
> fglrx module loaded. With more recent kernels the system will hang with 
> "Suspending console(s)".

My Vaio reliably hangs at the same place with 2.6.23-rc4.  I'll bisect that
next week sometime.  Hopefully the result of that effort will fix your bug.
 Please test Linus's tree regularly and don't let us release 2.6.23 until
it is fixed.

> 3. Even with the 2.6.18 kernel sound won't work after suspending to ram. 
> I don't know when this started, but I know that this has not been an 
> issue in the past.

Please provide full details in a separate bug report.  Send that report to
myself, linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz> and
Takashi Iwai <tiwai@suse.de>

Thanks.


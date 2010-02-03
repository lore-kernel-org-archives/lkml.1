Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab0BCRr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:47:28 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:49617 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740Ab0BCRr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:47:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=R+nNTAZJsL8WRvTQzTAUm6pBCzeVtOqrOydLsy1CMoFljfD62XKKcf8emyMAvHu2+E
         itAdScGcPjZX69dagU19jPBV5GRULmK91lWEOht50c/oXw9eDs7AYOsinhA0i7rhAGJP
         AUAc/ifE1F+uZwTy3y7x3BnPUpS/FJ3TurvJg=
Subject: Hand on resume if sd/mmc card was removed while system was
 suspended/hibernated
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-mmc <linux-mmc@vger.kernel.org>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 19:47:21 +0200
Message-ID: <1265219241.12549.8.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is what I get, if I remove mmc card while system is suspended:

<4>[15241.041945] Call Trace:
<4>[15241.042047]  [<ffffffff8106620a>] ? prepare_to_wait+0x2a/0x90
<4>[15241.042159]  [<ffffffff810790bd>] ? trace_hardirqs_on+0xd/0x10
<4>[15241.042271]  [<ffffffff8140db12>] ? _raw_spin_unlock_irqrestore+0x42/0x80
<4>[15241.042386]  [<ffffffff8112a390>] ? bdi_sched_wait+0x0/0x20
<4>[15241.042496]  [<ffffffff8112a39e>] bdi_sched_wait+0xe/0x20
<4>[15241.042606]  [<ffffffff8140af6f>] __wait_on_bit+0x5f/0x90
<4>[15241.042714]  [<ffffffff8112a390>] ? bdi_sched_wait+0x0/0x20
<4>[15241.042824]  [<ffffffff8140b018>] out_of_line_wait_on_bit+0x78/0x90
<4>[15241.042935]  [<ffffffff81065fd0>] ? wake_bit_function+0x0/0x40
<4>[15241.043045]  [<ffffffff8112a2d3>] ? bdi_queue_work+0xa3/0xe0
<4>[15241.043155]  [<ffffffff8112a37f>] bdi_sync_writeback+0x6f/0x80
<4>[15241.043265]  [<ffffffff8112a3d2>] sync_inodes_sb+0x22/0x120
<4>[15241.043375]  [<ffffffff8112f1d2>] __sync_filesystem+0x82/0x90
<4>[15241.043485]  [<ffffffff8112f3db>] sync_filesystem+0x4b/0x70
<4>[15241.043594]  [<ffffffff811391de>] fsync_bdev+0x2e/0x60
<4>[15241.043704]  [<ffffffff812226be>] invalidate_partition+0x2e/0x50
<4>[15241.043816]  [<ffffffff8116b92f>] del_gendisk+0x3f/0x140
<4>[15241.043926]  [<ffffffffa00c0233>] mmc_blk_remove+0x33/0x60 [mmc_block]
<4>[15241.044043]  [<ffffffff81338977>] mmc_bus_remove+0x17/0x20
<4>[15241.044152]  [<ffffffff812ce746>] __device_release_driver+0x66/0xc0
<4>[15241.044264]  [<ffffffff812ce89d>] device_release_driver+0x2d/0x40
<4>[15241.044375]  [<ffffffff812cd9b5>] bus_remove_device+0xb5/0x120
<4>[15241.044486]  [<ffffffff812cb46f>] device_del+0x12f/0x1a0
<4>[15241.044593]  [<ffffffff81338a5b>] mmc_remove_card+0x5b/0x90
<4>[15241.044702]  [<ffffffff8133ac27>] mmc_sd_remove+0x27/0x50
<4>[15241.044811]  [<ffffffff81337d8c>] mmc_resume_host+0x10c/0x140
<4>[15241.044929]  [<ffffffffa00850e9>] sdhci_resume_host+0x69/0xa0 [sdhci]
<4>[15241.045044]  [<ffffffffa0bdc39e>] sdhci_pci_resume+0x8e/0xb0 [sdhci_pci]
<4>[15241.045159]  [<ffffffff8124b0a2>] pci_legacy_resume+0x42/0x60
<4>[15241.045268]  [<ffffffff8124b148>] pci_pm_restore+0x88/0xb0
<4>[15241.045378]  [<ffffffff812d3942>] pm_op+0x1a2/0x1c0
<4>[15241.045483]  [<ffffffff812d44cd>] dpm_resume_end+0x14d/0x520
<4>[15241.045593]  [<ffffffff8108c0f1>] hibernation_snapshot+0xd1/0x290
<4>[15241.045704]  [<ffffffff8108c3ad>] hibernate+0xfd/0x200
<4>[15241.045811]  [<ffffffff8108ac5c>] state_store+0xec/0x100
<4>[15241.045919]  [<ffffffff81172e17>] ? sysfs_get_active_two+0x27/0x60
<4>[15241.046032]  [<ffffffff8122db07>] kobj_attr_store+0x17/0x20
<4>[15241.046141]  [<ffffffff811710a6>] sysfs_write_file+0xe6/0x170
<4>[15241.046253]  [<ffffffff811087f8>] vfs_write+0xb8/0x1a0
<4>[15241.046361]  [<ffffffff811089d1>] sys_write+0x51/0x90
<4>[15241.046470]  [<ffffffff8100305b>] system_call_fastpath+0x16/0x1b
<4>[15241.046579] INFO: lockdep is turned off.


It seems that del_disk can't be called from .resume methods.
It sleeps for threads that are frozen at that point.

Since I wrote my own driver (for xD cards) I have seen same problem.

I solved this (it is just very nice that way anyway) by a freezable 
kernel thread that polls for card state changes, 
and thus calls del_disk (indirectly) after system got fully resumed.

What do you think?

Best regards,
	Maxim Levitsky


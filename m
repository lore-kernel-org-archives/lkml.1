Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbYIFMhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbYIFMhO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 08:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbYIFMhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 08:37:01 -0400
Received: from sh.osrg.net ([192.16.179.4]:52283 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbYIFMg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 08:36:59 -0400
Date: Sat, 6 Sep 2008 21:35:09 +0900
To: m.kozlowski@tuxland.pl
Cc: rjw@sisk.pl, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com,
       akpm@linux-foundation.org, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.27-rc5-mm1: rmmod ide-cd_mod: tried to init an initialized
 object, something is seriously wrong.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200809051825.04829.m.kozlowski@tuxland.pl>
References: <200809051528.54213.rjw@sisk.pl>
	<200809051544.35443.m.kozlowski@tuxland.pl>
	<200809051825.04829.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080906213525V.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 18:25:04 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> > > > 	Again 100% reproducible rmmod ide-cd_mod problem. Kernel is tainted because
> > > > of earlier sysfs acpi problems similar (probably identical) to those reported
> > > > by Li Zefan here http://marc.info/?l=linux-kernel&m=121921059026064&w=2
> > > > 
> > > > Steps to reproduce: unload ide-cd_mod
> > > > 
> > > > kobject (dd9e4a7c): tried to init an initialized object, something is seriously wrong.
> > > > Pid: 4734, comm: modprobe Tainted: G        W 2.6.27-rc5-mm1 #1
> > > >  [<c01ec982>] kobject_init+0xc4/0xc9
> > > >  [<c02cb84a>] ? _spin_unlock+0x27/0x3f
> > > >  [<c01aff2e>] ? sysfs_find_dirent+0x21/0x2b
> > > >  [<c01aff7e>] ? __sysfs_add_one+0x46/0x6d
> > > >  [<c01affb4>] ? sysfs_add_one+0xf/0x44
> > > >  [<c01b0036>] ? sysfs_addrm_start+0x4d/0x90
> > > >  [<c01b0f31>] ? sysfs_do_create_link+0x9a/0x14c
> > > >  [<c01ec9c5>] kobject_init_and_add+0x14/0x30
> > > >  [<c01b1009>] ? sysfs_create_link+0x12/0x19
> > > >  [<c01e8bad>] blk_register_filter+0x3b/0x46
> > > >  [<ded9e40a>] ide_cd_probe+0x253/0x5a8 [ide_cd_mod]
> > > >  [<c01b0000>] ? sysfs_addrm_start+0x17/0x90
> > > >  [<c01b0f31>] ? sysfs_do_create_link+0x9a/0x14c
> > > >  [<c01b004e>] ? sysfs_addrm_start+0x65/0x90
> > > >  [<c025145f>] generic_ide_probe+0x1f/0x21
> > > >  [<c024c002>] driver_probe_device+0x77/0x15b
> > > >  [<c02cb91b>] ? _spin_unlock_irqrestore+0x39/0x60
> > > >  [<c024c146>] __driver_attach+0x60/0x62
> > > >  [<c024b7bd>] bus_for_each_dev+0x44/0x62
> > > >  [<c0251461>] ? generic_ide_remove+0x0/0x1e
> > > >  [<c024bead>] driver_attach+0x19/0x1b
> > > >  [<c024c0e6>] ? __driver_attach+0x0/0x62
> > > >  [<c024bca8>] bus_add_driver+0x1ab/0x213
> > > >  [<c0251461>] ? generic_ide_remove+0x0/0x1e
> > > >  [<c024c291>] driver_register+0x4f/0x118
> > > >  [<de7bf000>] ? ide_cdrom_init+0x0/0xf [ide_cd_mod]
> > > >  [<de7bf00d>] ide_cdrom_init+0xd/0xf [ide_cd_mod]
> > > >  [<c0101114>] do_one_initcall+0x24/0x12f
> > > >  [<c02c9d8e>] ? mutex_unlock+0x8/0xa
> > > >  [<c01455ca>] sys_init_module+0xa5/0x1c1
> > > >  [<c0176a0a>] ? sys_read+0x3d/0x64
> > > >  [<c01030f1>] sysenter_do_call+0x12/0x35
> > > >  [<c012007b>] ? __set_special_pids+0x43/0x71
> > > > 
> > > > First time I modprobe/rmmod ide-cd_mod the system works but quickly gets unstable.
> > > > Second modprobe/rmmod is 100% fatal. Memory gets corruped seriously I guess.
> > > > pcspeaker beeps all the time, kernel throws dumps on the screen until
> > > > its really dead, sadly blinking 'leds of panic' ;)
> > > 
> > > Can you please verify if that happens with the current mainline?
> > 
> > Oops. How come I didn't find it earlier? hmm...
> 
> It's relatively new, that's why :) And this is the culprit:
> 
> abf5439370491dd6fbb4fe1a7939680d2a9bc9d4 is first bad commit
> commit abf5439370491dd6fbb4fe1a7939680d2a9bc9d4
> Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date:   Sat Aug 16 14:10:05 2008 +0900
> 
>     block: move cmdfilter from gendisk to request_queue
>     
>     cmd_filter works only for the block layer SG_IO with SCSI block
>     devices. It breaks scsi/sg.c, bsg, and the block layer SG_IO with SCSI
>     character devices (such as st). We hit a kernel crash with them.
>     
>     The problem is that cmd_filter code accesses to gendisk (having struct
>     blk_scsi_cmd_filter) via inode->i_bdev->bd_disk. It works for only
>     SCSI block device files. With character device files, inode->i_bdev
>     leads you to struct cdev. inode->i_bdev->bd_disk->blk_scsi_cmd_filter
>     isn't safe.
>     
>     SCSI ULDs don't expose gendisk; they keep it private. bsg needs to be
>     independent on any protocols. We shouldn't change ULDs to expose their
>     gendisk.
>     
>     This patch moves struct blk_scsi_cmd_filter from gendisk to
>     request_queue, a common object, which eveyone can access to.
>     
>     The user interface doesn't change; users can change the filters via
>     /sys/block/. gendisk has a pointer to request_queue so the cmd_filter
>     code accesses to struct blk_scsi_cmd_filter.
>     
>     Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> 
> > This is current mainline:
> > 
> > kobject (ddb049fc): tried to init an initialized object, something is seriously wrong.
> > Pid: 4650, comm: modprobe Not tainted 2.6.27-rc5-00132-gb380b0d #8
> >  [<c01e3196>] kobject_init+0x6a/0x6c
> >  [<c01e35cb>] kobject_init_and_add+0x14/0x30
> >  [<c01e32f7>] ? kobject_get+0x12/0x17
> >  [<c01df89c>] blk_register_filter+0x4b/0x5a
> >  [<de839310>] ide_cd_probe+0x289/0x5ae [ide_cd_mod]
> >  [<c01aad99>] ? sysfs_addrm_start+0x65/0x90
> >  [<c01aba69>] ? sysfs_do_create_link+0x9a/0x11c
> >  [<c024f7a0>] generic_ide_probe+0x1f/0x21
> >  [<c024a672>] driver_probe_device+0x77/0x15b
> >  [<c02c8bdb>] ? _spin_unlock_irqrestore+0x39/0x60
> >  [<c024a7b6>] __driver_attach+0x60/0x62
> >  [<c0249e2a>] bus_for_each_dev+0x44/0x62
> >  [<c024f7a2>] ? generic_ide_remove+0x0/0x1e
> >  [<c024a51d>] driver_attach+0x19/0x1b
> >  [<c024a756>] ? __driver_attach+0x0/0x62
> >  [<c024a318>] bus_add_driver+0x1ae/0x216
> >  [<c024f7a2>] ? generic_ide_remove+0x0/0x1e
> >  [<c024a901>] driver_register+0x4f/0x118
> >  [<dee3500d>] ide_cdrom_init+0xd/0xf [ide_cd_mod]
> >  [<c010111a>] do_one_initcall+0x2a/0x14c
> >  [<c0108560>] ? native_sched_clock+0x58/0xa1
> >  [<dee35000>] ? ide_cdrom_init+0x0/0xf [ide_cd_mod]
> >  [<c013d042>] ? trace_hardirqs_on+0xb/0xd
> >  [<c013cfaf>] ? trace_hardirqs_on_caller+0xac/0x134
> >  [<c0147083>] sys_init_module+0x7e/0x19f
> >  [<c013cfaf>] ? trace_hardirqs_on_caller+0xac/0x134
> >  [<c01e8144>] ? trace_hardirqs_on_thunk+0xc/0x10
> >  [<c0103035>] sysenter_do_call+0x12/0x35
> >  [<c012007b>] ? put_fs_struct+0x5/0x2e

ide-cd uses multiple gendisks share one request_queue?

Here's a patch for mainline.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ide: remove cmd filter support in ide-cd

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/ide/ide-cd.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index f148999..49a8c58 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1933,7 +1933,6 @@ static void ide_cd_remove(ide_drive_t *drive)
 
 	ide_proc_unregister_driver(drive, info->driver);
 
-	blk_unregister_filter(info->disk);
 	del_gendisk(info->disk);
 
 	ide_cd_put(info);
@@ -2159,7 +2158,6 @@ static int ide_cd_probe(ide_drive_t *drive)
 	g->fops = &idecd_ops;
 	g->flags |= GENHD_FL_REMOVABLE;
 	add_disk(g);
-	blk_register_filter(g);
 	return 0;
 
 out_free_cd:
-- 
1.5.4.2


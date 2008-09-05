Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbYIEQZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbYIEQZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbYIEQZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:25:12 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:50682 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbYIEQZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:25:09 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.27-rc5-mm1: rmmod ide-cd_mod: tried to init an initialized object, something is seriously wrong.
Date: Fri, 5 Sep 2008 18:25:04 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20080904224004.d3dd3076.akpm@linux-foundation.org> <200809051528.54213.rjw@sisk.pl> <200809051544.35443.m.kozlowski@tuxland.pl>
In-Reply-To: <200809051544.35443.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809051825.04829.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > > 	Again 100% reproducible rmmod ide-cd_mod problem. Kernel is tainted because
> > > of earlier sysfs acpi problems similar (probably identical) to those reported
> > > by Li Zefan here http://marc.info/?l=linux-kernel&m=121921059026064&w=2
> > > 
> > > Steps to reproduce: unload ide-cd_mod
> > > 
> > > kobject (dd9e4a7c): tried to init an initialized object, something is seriously wrong.
> > > Pid: 4734, comm: modprobe Tainted: G        W 2.6.27-rc5-mm1 #1
> > >  [<c01ec982>] kobject_init+0xc4/0xc9
> > >  [<c02cb84a>] ? _spin_unlock+0x27/0x3f
> > >  [<c01aff2e>] ? sysfs_find_dirent+0x21/0x2b
> > >  [<c01aff7e>] ? __sysfs_add_one+0x46/0x6d
> > >  [<c01affb4>] ? sysfs_add_one+0xf/0x44
> > >  [<c01b0036>] ? sysfs_addrm_start+0x4d/0x90
> > >  [<c01b0f31>] ? sysfs_do_create_link+0x9a/0x14c
> > >  [<c01ec9c5>] kobject_init_and_add+0x14/0x30
> > >  [<c01b1009>] ? sysfs_create_link+0x12/0x19
> > >  [<c01e8bad>] blk_register_filter+0x3b/0x46
> > >  [<ded9e40a>] ide_cd_probe+0x253/0x5a8 [ide_cd_mod]
> > >  [<c01b0000>] ? sysfs_addrm_start+0x17/0x90
> > >  [<c01b0f31>] ? sysfs_do_create_link+0x9a/0x14c
> > >  [<c01b004e>] ? sysfs_addrm_start+0x65/0x90
> > >  [<c025145f>] generic_ide_probe+0x1f/0x21
> > >  [<c024c002>] driver_probe_device+0x77/0x15b
> > >  [<c02cb91b>] ? _spin_unlock_irqrestore+0x39/0x60
> > >  [<c024c146>] __driver_attach+0x60/0x62
> > >  [<c024b7bd>] bus_for_each_dev+0x44/0x62
> > >  [<c0251461>] ? generic_ide_remove+0x0/0x1e
> > >  [<c024bead>] driver_attach+0x19/0x1b
> > >  [<c024c0e6>] ? __driver_attach+0x0/0x62
> > >  [<c024bca8>] bus_add_driver+0x1ab/0x213
> > >  [<c0251461>] ? generic_ide_remove+0x0/0x1e
> > >  [<c024c291>] driver_register+0x4f/0x118
> > >  [<de7bf000>] ? ide_cdrom_init+0x0/0xf [ide_cd_mod]
> > >  [<de7bf00d>] ide_cdrom_init+0xd/0xf [ide_cd_mod]
> > >  [<c0101114>] do_one_initcall+0x24/0x12f
> > >  [<c02c9d8e>] ? mutex_unlock+0x8/0xa
> > >  [<c01455ca>] sys_init_module+0xa5/0x1c1
> > >  [<c0176a0a>] ? sys_read+0x3d/0x64
> > >  [<c01030f1>] sysenter_do_call+0x12/0x35
> > >  [<c012007b>] ? __set_special_pids+0x43/0x71
> > > 
> > > First time I modprobe/rmmod ide-cd_mod the system works but quickly gets unstable.
> > > Second modprobe/rmmod is 100% fatal. Memory gets corruped seriously I guess.
> > > pcspeaker beeps all the time, kernel throws dumps on the screen until
> > > its really dead, sadly blinking 'leds of panic' ;)
> > 
> > Can you please verify if that happens with the current mainline?
> 
> Oops. How come I didn't find it earlier? hmm...

It's relatively new, that's why :) And this is the culprit:

abf5439370491dd6fbb4fe1a7939680d2a9bc9d4 is first bad commit
commit abf5439370491dd6fbb4fe1a7939680d2a9bc9d4
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Sat Aug 16 14:10:05 2008 +0900

    block: move cmdfilter from gendisk to request_queue
    
    cmd_filter works only for the block layer SG_IO with SCSI block
    devices. It breaks scsi/sg.c, bsg, and the block layer SG_IO with SCSI
    character devices (such as st). We hit a kernel crash with them.
    
    The problem is that cmd_filter code accesses to gendisk (having struct
    blk_scsi_cmd_filter) via inode->i_bdev->bd_disk. It works for only
    SCSI block device files. With character device files, inode->i_bdev
    leads you to struct cdev. inode->i_bdev->bd_disk->blk_scsi_cmd_filter
    isn't safe.
    
    SCSI ULDs don't expose gendisk; they keep it private. bsg needs to be
    independent on any protocols. We shouldn't change ULDs to expose their
    gendisk.
    
    This patch moves struct blk_scsi_cmd_filter from gendisk to
    request_queue, a common object, which eveyone can access to.
    
    The user interface doesn't change; users can change the filters via
    /sys/block/. gendisk has a pointer to request_queue so the cmd_filter
    code accesses to struct blk_scsi_cmd_filter.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

> This is current mainline:
> 
> kobject (ddb049fc): tried to init an initialized object, something is seriously wrong.
> Pid: 4650, comm: modprobe Not tainted 2.6.27-rc5-00132-gb380b0d #8
>  [<c01e3196>] kobject_init+0x6a/0x6c
>  [<c01e35cb>] kobject_init_and_add+0x14/0x30
>  [<c01e32f7>] ? kobject_get+0x12/0x17
>  [<c01df89c>] blk_register_filter+0x4b/0x5a
>  [<de839310>] ide_cd_probe+0x289/0x5ae [ide_cd_mod]
>  [<c01aad99>] ? sysfs_addrm_start+0x65/0x90
>  [<c01aba69>] ? sysfs_do_create_link+0x9a/0x11c
>  [<c024f7a0>] generic_ide_probe+0x1f/0x21
>  [<c024a672>] driver_probe_device+0x77/0x15b
>  [<c02c8bdb>] ? _spin_unlock_irqrestore+0x39/0x60
>  [<c024a7b6>] __driver_attach+0x60/0x62
>  [<c0249e2a>] bus_for_each_dev+0x44/0x62
>  [<c024f7a2>] ? generic_ide_remove+0x0/0x1e
>  [<c024a51d>] driver_attach+0x19/0x1b
>  [<c024a756>] ? __driver_attach+0x0/0x62
>  [<c024a318>] bus_add_driver+0x1ae/0x216
>  [<c024f7a2>] ? generic_ide_remove+0x0/0x1e
>  [<c024a901>] driver_register+0x4f/0x118
>  [<dee3500d>] ide_cdrom_init+0xd/0xf [ide_cd_mod]
>  [<c010111a>] do_one_initcall+0x2a/0x14c
>  [<c0108560>] ? native_sched_clock+0x58/0xa1
>  [<dee35000>] ? ide_cdrom_init+0x0/0xf [ide_cd_mod]
>  [<c013d042>] ? trace_hardirqs_on+0xb/0xd
>  [<c013cfaf>] ? trace_hardirqs_on_caller+0xac/0x134
>  [<c0147083>] sys_init_module+0x7e/0x19f
>  [<c013cfaf>] ? trace_hardirqs_on_caller+0xac/0x134
>  [<c01e8144>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c0103035>] sysenter_do_call+0x12/0x35
>  [<c012007b>] ? put_fs_struct+0x5/0x2e
>  =======================
> =============================================================================
> BUG kmalloc-16: Object already free
> -----------------------------------------------------------------------------
> 
> INFO: Allocated in kvasprintf+0x2d/0x4c age=23609 cpu=0 pid=743
> INFO: Freed in kobject_release+0x3a/0x56 age=45 cpu=0 pid=4645
> INFO: Slab 0xc13b74e0 objects=64 used=45 fp=0xddba70c0 flags=0x40000083
> INFO: Object 0xddba7400 @offset=1024 fp=0xddba7440
> 
> Bytes b4 0xddba73f0:  25 12 00 00 b4 43 ff ff 5a 5a 5a 5a 5a 5a 5a 5a %...´CÿÿZZZZZZZZ
>   Object 0xddba7400:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¥
>  Redzone 0xddba7410:  bb bb bb bb                                     »»»»            
>  Padding 0xddba7438:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
> Pid: 4650, comm: modprobe Not tainted 2.6.27-rc5-00132-gb380b0d #8
>  [<c016cf7e>] print_trailer+0xca/0x105
>  [<c016d09e>] object_err+0x31/0x39
>  [<c016db93>] __slab_free+0x1aa/0x320
>  [<c016e74d>] kfree+0x85/0xee
>  [<c01e3562>] ? kobject_set_name_vargs+0x3a/0x42
>  [<c01e3562>] ? kobject_set_name_vargs+0x3a/0x42
>  [<c01e3562>] kobject_set_name_vargs+0x3a/0x42
>  [<c01e3585>] kobject_add_varg+0x1b/0x4d
>  [<c01e35e1>] kobject_init_and_add+0x2a/0x30
>  [<c01df89c>] blk_register_filter+0x4b/0x5a
>  [<de839310>] ide_cd_probe+0x289/0x5ae [ide_cd_mod]
>  [<c01aad99>] ? sysfs_addrm_start+0x65/0x90
>  [<c01aba69>] ? sysfs_do_create_link+0x9a/0x11c
>  [<c024f7a0>] generic_ide_probe+0x1f/0x21
>  [<c024a672>] driver_probe_device+0x77/0x15b
>  [<c02c8bdb>] ? _spin_unlock_irqrestore+0x39/0x60
>  [<c024a7b6>] __driver_attach+0x60/0x62
>  [<c0249e2a>] bus_for_each_dev+0x44/0x62
>  [<c024f7a2>] ? generic_ide_remove+0x0/0x1e
>  [<c024a51d>] driver_attach+0x19/0x1b
>  [<c024a756>] ? __driver_attach+0x0/0x62
>  [<c024a318>] bus_add_driver+0x1ae/0x216
>  [<c024f7a2>] ? generic_ide_remove+0x0/0x1e
>  [<c024a901>] driver_register+0x4f/0x118
>  [<dee3500d>] ide_cdrom_init+0xd/0xf [ide_cd_mod]
>  [<c010111a>] do_one_initcall+0x2a/0x14c
>  [<c0108560>] ? native_sched_clock+0x58/0xa1
>  [<dee35000>] ? ide_cdrom_init+0x0/0xf [ide_cd_mod]
>  [<c013d042>] ? trace_hardirqs_on+0xb/0xd
>  [<c013cfaf>] ? trace_hardirqs_on_caller+0xac/0x134
>  [<c0147083>] sys_init_module+0x7e/0x19f
>  [<c013cfaf>] ? trace_hardirqs_on_caller+0xac/0x134
>  [<c01e8144>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c0103035>] sysenter_do_call+0x12/0x35
>  [<c012007b>] ? put_fs_struct+0x5/0x2e
>  =======================
> FIX kmalloc-16: Object at 0xddba7400 not freed

And this is another one, this time from sparc64 on 2.6.27-rc5-mm1.
To reproduce just rmmod sr_mod.

sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
kobject (fffff800bf669068): tried to init an initialized object, something is seriously wrong.
Call Trace:
 [0000000000559770] kobject_init_and_add+0x10/0x40
 [0000000000552764] blk_register_filter+0x24/0x40
 [00000000100dc8ec] sr_probe+0x56c/0x620 [sr_mod]
 [00000000005b0d4c] driver_probe_device+0x8c/0x1c0
 [00000000005b0ed4] __driver_attach+0x54/0x80
 [00000000005b0304] bus_for_each_dev+0x44/0x80
 [00000000005b07c0] bus_add_driver+0xa0/0x240
 [00000000005b10c4] driver_register+0x44/0x140
 [00000000100e6028] init_sr+0x28/0x60 [sr_mod]
 [0000000000426a5c] do_one_initcall+0x1c/0x140
 [00000000004890ac] sys_init_module+0xac/0x1c0
 [0000000000406254] linux_sparc_syscall32+0x34/0x40
=============================================================================
BUG kmalloc-16: Object already free
-----------------------------------------------------------------------------

INFO: Allocated in kvasprintf+0x2c/0x60 age=6962 cpu=0 pid=520
INFO: Freed in kref_put+0x3c/0x80 age=10 cpu=0 pid=3212
INFO: Slab 0x00000002014eba10 objects=93 used=81 fp=0xfffff800bf45d3f0 flags=0x0083
INFO: Object 0xfffff800bf45d6b0 @offset=5808 fp=0xfffff800bf45d708

Bytes b4 0xfffff800bf45d6a0:  00 00 00 00 ff ff ad 53 5a 5a 5a 5a 5a 5a 5a 5a ....ÿÿ­SZZZZZZZZ
  Object 0xfffff800bf45d6b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¥
 Redzone 0xfffff800bf45d6c0:  bb bb bb bb bb bb bb bb                         »»»»»»»»        
 Padding 0xfffff800bf45d700:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Call Trace:
 [00000000004bdbd8] kfree+0x98/0x140
 [0000000000559704] kobject_set_name_vargs+0x44/0x60
 [000000000055972c] kobject_add_varg+0xc/0x40
 [0000000000559788] kobject_init_and_add+0x28/0x40
 [0000000000552764] blk_register_filter+0x24/0x40
 [00000000100dc8ec] sr_probe+0x56c/0x620 [sr_mod]
 [00000000005b0d4c] driver_probe_device+0x8c/0x1c0
 [00000000005b0ed4] __driver_attach+0x54/0x80
 [00000000005b0304] bus_for_each_dev+0x44/0x80
 [00000000005b07c0] bus_add_driver+0xa0/0x240
 [00000000005b10c4] driver_register+0x44/0x140
 [00000000100e6028] init_sr+0x28/0x60 [sr_mod]
 [0000000000426a5c] do_one_initcall+0x1c/0x140
 [00000000004890ac] sys_init_module+0xac/0x1c0
 [0000000000406254] linux_sparc_syscall32+0x34/0x40
FIX kmalloc-16: Object at 0xfffff800bf45d6b0 not freed
sr 0:0:6:0: Attached scsi CD-ROM sr0


	Mariusz

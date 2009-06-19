Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbZFSVcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbZFSVcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 17:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbZFSVcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 17:32:46 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:13637 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbZFSVco convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 17:32:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=LpI0hwtcS5yOOFgfzJiy8ez5J7rmWbrmeojG+QjOweUGBL0i3Eb5/OtRdCsfhpo9as
         Eh5zdXb5xjnxDmieiv1Q44CfeYlmDyQKCOpXIwT/Qx8dLyofb7JJ+3VKwScK3YFJpSp9
         hlGPPqLpxnNhaoFMjTAEV1uYU06DTKdz44a0k=
MIME-Version: 1.0
Date: Fri, 19 Jun 2009 17:32:46 -0400
Message-ID: <a44ae5cd0906191432o7c7b602dsc099cff1c4fcd84a@mail.gmail.com>
Subject: 2.6.30-git14 -- BUG inotify_inode_mark_entry: Poison overwritten
From: Miles Lane <miles.lane@gmail.com>
To: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
       Eric Paris <eparis@parisplace.org>, LKML <linux-kernel@vger.kernel.org>,
       Stephen Tweedie <sct@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will send the .config file separately, to avoid rejection by vger.

Linux ubuntu 2.6.30-git14 #4 SMP PREEMPT Fri Jun 19 16:40:52 EDT 2009
i686 GNU/Linux

Gnu C                  4.4.0
Gnu make               3.81
binutils               2.19.51.20090515
util-linux             2.15.1-rc1
mount                  support
module-init-tools      3.8
e2fsprogs              1.41.5
reiserfsprogs          3.6.21
pcmciautils            014
Linux C Library        2.9
Dynamic linker (ldd)   2.9
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.14.1
Sh-utils               7.4
wireless-tools         29
Modules Loaded         vfat fat sco bnep rfcomm l2cap bluetooth
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm psmouse
snd_seq_dummy snd_seq_oss snd_seq_midi_event iTCO_wdt
iTCO_vendor_support ath9k snd_seq rng_core mac80211 ath snd_timer
snd_seq_device cfg80211 snd soundcore snd_page_alloc shpchp
pci_hotplug rtc_cmos rtc_core rtc_lib eeepc_laptop hwmon rfkill
hid_logitech usb_storage usb_libusual usbhid sg ehci_hcd uhci_hcd
usbcore atl1e

Distro:  Ubuntu 9.10 development packages

[   15.458756] idr_remove called for id=31 which is not allocated.
[   15.463938] Pid: 1446, comm: udevd Not tainted 2.6.30-git14 #4
[   15.469161] Call Trace:
[   15.474347]  [<c1309bab>] ? printk+0xf/0x14
[   15.479553]  [<c116ca04>] idr_remove+0xcd/0x128
[   15.484640]  [<c130b995>] ? _spin_lock+0x2c/0x34
[   15.489697]  [<c10cb5d9>] inotify_destroy_mark_entry+0x87/0x9a
[   15.494544]  [<c10cad13>] inotify_freeing_mark+0x8/0xa
[   15.499312]  [<c10c9af9>] fsnotify_destroy_mark_by_entry+0x119/0x13d
[   15.504466]  [<c10cb57a>] inotify_destroy_mark_entry+0x28/0x9a
[   15.509032]  [<c10cb665>] sys_inotify_rm_watch+0x79/0x98
[   15.513550]  [<c1002c5c>] syscall_call+0x7/0xb

[   19.873130] EXT3-fs: loop0: orphan cleanup on readonly fs
[   19.876723] kjournald starting.  Commit interval 5 seconds
[   20.112125] ext3_orphan_cleanup: deleting unreferenced inode 816065
[   20.123000] ext3_orphan_cleanup: deleting unreferenced inode 816060
[   20.123295] ext3_orphan_cleanup: deleting unreferenced inode 816071
[   20.135247] ext3_orphan_cleanup: deleting unreferenced inode 818324
[   20.138055] ext3_orphan_cleanup: deleting unreferenced inode 816761
[   20.139618] ext3_orphan_cleanup: deleting unreferenced inode 818311
[   20.141607] ext3_orphan_cleanup: deleting unreferenced inode 817637
[   20.143068] ext3_orphan_cleanup: deleting unreferenced inode 818301
[   20.143283] ext3_orphan_cleanup: deleting unreferenced inode 818295
[   20.143513] ext3_orphan_cleanup: deleting unreferenced inode 817634
[   20.143948] ext3_orphan_cleanup: deleting unreferenced inode 817633
[   20.145525] ext3_orphan_cleanup: deleting unreferenced inode 817632
[   20.145748] ext3_orphan_cleanup: deleting unreferenced inode 817631
[   20.147320] ext3_orphan_cleanup: deleting unreferenced inode 817250
[   20.167391] ext3_orphan_cleanup: deleting unreferenced inode 818294
[   20.168989] ext3_orphan_cleanup: deleting unreferenced inode 818288
[   20.170703] ext3_orphan_cleanup: deleting unreferenced inode 817224
[   20.170962] ext3_orphan_cleanup: deleting unreferenced inode 816077
[   20.182551] ext3_orphan_cleanup: deleting unreferenced inode 996186
[   20.184605] ext3_orphan_cleanup: deleting unreferenced inode 996187
[   20.184744] ext3_orphan_cleanup: deleting unreferenced inode 996192
[   20.184881] ext3_orphan_cleanup: deleting unreferenced inode 996183
[   20.203202] ext3_orphan_cleanup: deleting unreferenced inode 996194
[   20.203506] ext3_orphan_cleanup: deleting unreferenced inode 996188
[   20.203642] ext3_orphan_cleanup: deleting unreferenced inode 996184
[   20.234291] ext3_orphan_cleanup: deleting unreferenced inode 996193
[   20.234433] ext3_orphan_cleanup: deleting unreferenced inode 996190
[   20.234566] ext3_orphan_cleanup: deleting unreferenced inode 996185
[   20.258159] ext3_orphan_cleanup: deleting unreferenced inode 1045155
[   20.302738] ext3_orphan_cleanup: deleting unreferenced inode 1207875
[   20.303389] ext3_orphan_cleanup: deleting unreferenced inode 1207873
[   20.336088] ext3_orphan_cleanup: deleting unreferenced inode 1003748
[   20.368865] ext3_orphan_cleanup: deleting unreferenced inode 964397
[   20.389701] ext3_orphan_cleanup: deleting unreferenced inode 963504
[   20.418304] ext3_orphan_cleanup: deleting unreferenced inode 995594
[   20.445329] ext3_orphan_cleanup: deleting unreferenced inode 963601
[   20.476128] ext3_orphan_cleanup: deleting unreferenced inode 964846
[   20.500333] ext3_orphan_cleanup: deleting unreferenced inode 996851
[   20.511649] ext3_orphan_cleanup: deleting unreferenced inode 996834
[   20.512342] ext3_orphan_cleanup: deleting unreferenced inode 996826
[   20.522362] ext3_orphan_cleanup: deleting unreferenced inode 996825
[   20.527822] ext3_orphan_cleanup: deleting unreferenced inode 996823
[   20.536990] ext3_orphan_cleanup: deleting unreferenced inode 996822
[   20.548772] ext3_orphan_cleanup: deleting unreferenced inode 996819
[   20.575450] ext3_orphan_cleanup: deleting unreferenced inode 964260
[   20.626859] ext3_orphan_cleanup: deleting unreferenced inode 965153
[   20.635596] ext3_orphan_cleanup: deleting unreferenced inode 965161
[   20.651641] ext3_orphan_cleanup: deleting unreferenced inode 965321
[   20.670861] ext3_orphan_cleanup: deleting unreferenced inode 965344
[   20.760273] ext3_orphan_cleanup: deleting unreferenced inode 179523
[   20.778718] ext3_orphan_cleanup: deleting unreferenced inode 179524
[   20.784017] ext3_orphan_cleanup: deleting unreferenced inode 179526
[   20.786491] ext3_orphan_cleanup: deleting unreferenced inode 179522
[   20.827962] ext3_orphan_cleanup: deleting unreferenced inode 971405
[   20.837332] ext3_orphan_cleanup: deleting unreferenced inode 963256
[   20.889881] ext3_orphan_cleanup: deleting unreferenced inode 1232836
[   20.890247] ext3_orphan_cleanup: deleting unreferenced inode 1161920
[   20.907540] ext3_orphan_cleanup: deleting unreferenced inode 963824
[   20.966208] ext3_orphan_cleanup: deleting unreferenced inode 1038126
[   21.006336] ext3_orphan_cleanup: deleting unreferenced inode 995930
[   21.017052] ext3_orphan_cleanup: deleting unreferenced inode 995920
[   21.017465] ext3_orphan_cleanup: deleting unreferenced inode 965414
[   21.030973] ext3_orphan_cleanup: deleting unreferenced inode 965520
[   21.041019] ext3_orphan_cleanup: deleting unreferenced inode 964206
[   21.059009] ext3_orphan_cleanup: deleting unreferenced inode 964524
[   21.077604] ext3_orphan_cleanup: deleting unreferenced inode 995753
[   21.077808] ext3_orphan_cleanup: deleting unreferenced inode 995746
[   21.078095] ext3_orphan_cleanup: deleting unreferenced inode 995744
[   21.104710] ext3_orphan_cleanup: deleting unreferenced inode 965271
[   21.139804] ext3_orphan_cleanup: deleting unreferenced inode 965278
[   21.146470] ext3_orphan_cleanup: deleting unreferenced inode 965283
[   21.183512] ext3_orphan_cleanup: deleting unreferenced inode 964496
[   21.183906] ext3_orphan_cleanup: deleting unreferenced inode 971169
[   21.194371] ext3_orphan_cleanup: deleting unreferenced inode 963023
[   21.199925] EXT3-fs: loop0: 74 orphan inodes deleted
[   21.203261] EXT3-fs: recovery complete.
[   21.298256] EXT3-fs: mounted filesystem with writeback data mode.

[   71.947514] BUG inotify_inode_mark_entry: Poison overwritten
[   71.947514] -----------------------------------------------------------------------------
[   71.947514]
[   71.947514] INFO: 0xf5c2a804-0xf5c2a804. First byte 0x6a instead of 0x6b
[   71.947514] INFO: Allocated in sys_inotify_add_watch+0x278/0x290
age=17023 cpu=1 pid=1434
[   71.947514] INFO: Freed in inotify_free_mark+0xf/0x11 age=16936
cpu=0 pid=1446
[   71.947514] INFO: Slab 0xc25eb888 objects=32 used=16 fp=0xf5c2a800
flags=0x350000c3
[   71.947514] INFO: Object 0xf5c2a800 @offset=2048 fp=0xf5c2a880
[   71.947514]
[   71.947514] Bytes b4 0xf5c2a7f0:  00 00 00 00 10 03 00 00 b5 b9 fe
ff 5a 5a 5a 5a ........����ZZZZ
[   71.947514]   Object 0xf5c2a800:  6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkjkkkkkkkkkkk
[   71.947514]   Object 0xf5c2a810:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   71.947514]   Object 0xf5c2a820:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   71.947514]   Object 0xf5c2a830:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   71.947514]   Object 0xf5c2a840:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   71.947514]   Object 0xf5c2a850:  6b 6b 6b a5
              kkk�
[   71.947514]  Redzone 0xf5c2a854:  bb bb bb bb
              ����
[   71.947514]  Padding 0xf5c2a87c:  5a 5a 5a 5a
              ZZZZ
[   71.947514] Pid: 3094, comm: hald Not tainted 2.6.30-git14 #4
[   71.947514] Call Trace:
[   71.947514]  [<c10a08f2>] print_trailer+0xe0/0xe8
[   71.947514]  [<c10a0986>] check_bytes_and_report+0x8c/0xaf
[   71.947514]  [<c10a0a7e>] check_object+0xa5/0x15f
[   71.947514]  [<c10a25a4>] __slab_alloc+0x3f8/0x49f
[   71.947514]  [<c10cb3bc>] ? sys_inotify_add_watch+0x278/0x290
[   71.947514]  [<c10a26b2>] kmem_cache_alloc+0x67/0x142
[   71.947514]  [<c10cb3bc>] ? sys_inotify_add_watch+0x278/0x290
[   71.947514]  [<c10cb3bc>] sys_inotify_add_watch+0x278/0x290
[   71.947514]  [<c1002bfe>] ? sysenter_exit+0xf/0x21
[   71.947514]  [<c104fa30>] ? trace_hardirqs_on_caller+0x108/0x130
[   71.947514]  [<c1002bcb>] sysenter_do_call+0x12/0x36
[   71.947514] FIX inotify_inode_mark_entry: Restoring
0xf5c2a804-0xf5c2a804=0x6b
[   71.947514]
[   71.947514] FIX inotify_inode_mark_entry: Marking all objects used

[   89.399884] kmemleak: unreferenced object 0xf7019cc0 (size 20):
[   89.399897]   comm "swapper", pid 0, jiffies 4294877296
[   89.399905]   backtrace:
[   89.399922]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.399935]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.399949]     [<c14d31b4>] debug_objects_mem_init+0x58/0x1b3
[   89.399963]     [<c14b7854>] start_kernel+0x32b/0x3bf
[   89.399975]     [<c14b7072>] __init_begin+0x72/0x7a
[   89.399999]     [<ffffffff>] 0xffffffff
[   89.400118] kmemleak: unreferenced object 0xf701ed40 (size 20):
[   89.400128]   comm "swapper", pid 0, jiffies 4294877296
[   89.400135]   backtrace:
[   89.400146]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.400157]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.400170]     [<c14d31b4>] debug_objects_mem_init+0x58/0x1b3
[   89.400182]     [<c14b7854>] start_kernel+0x32b/0x3bf
[   89.400194]     [<c14b7072>] __init_begin+0x72/0x7a
[   89.400210]     [<ffffffff>] 0xffffffff
[   89.408942] kmemleak: unreferenced object 0xf736d310 (size 64):
[   89.408955]   comm "swapper", pid 1, jiffies 4294877661
[   89.408963]   backtrace:
[   89.408980]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.408993]     [<c10a3308>] __kmalloc+0x133/0x153
[   89.409006]     [<c1198f7f>] kzalloc+0xb/0xd
[   89.409018]     [<c11994c8>] acpi_add_single_object+0x4dc/0xb62
[   89.409029]     [<c1199d38>] acpi_bus_scan+0xfd/0x173
[   89.409041]     [<c14d60c9>] acpi_scan_init+0xb5/0xd5
[   89.409052]     [<c14d5eab>] acpi_init+0x21e/0x262
[   89.409064]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.409077]     [<c14b7316>] kernel_init+0x143/0x194
[   89.409089]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.409113]     [<ffffffff>] 0xffffffff
[   89.411832] kmemleak: unreferenced object 0xf721c280 (size 32):
[   89.411844]   comm "swapper", pid 1, jiffies 4294877921
[   89.411851]   backtrace:
[   89.411868]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.411881]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.411894]     [<c1035596>] T.333+0x21/0x50
[   89.411907]     [<c14c9655>] __reserve_region_with_split+0x1a/0xb0
[   89.411919]     [<c14c96e2>] __reserve_region_with_split+0xa7/0xb0
[   89.411932]     [<c14c96e2>] __reserve_region_with_split+0xa7/0xb0
[   89.411944]     [<c14c96e2>] __reserve_region_with_split+0xa7/0xb0
[   89.411957]     [<c14c9714>] reserve_region_with_split+0x29/0x39
[   89.411969]     [<c14bb5e4>] e820_reserve_resources_late+0x88/0x9c
[   89.411983]     [<c14dbd37>] pcibios_resource_survey+0x23/0x25
[   89.411995]     [<c14dd6d7>] pcibios_init+0x52/0x64
[   89.412006]     [<c14dce7f>] pci_subsys_init+0xd9/0xe3
[   89.412018]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.412030]     [<c14b7316>] kernel_init+0x143/0x194
[   89.412042]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.412066]     [<ffffffff>] 0xffffffff
[   89.424537] kmemleak: unreferenced object 0xf721b800 (size 16):
[   89.424549]   comm "swapper", pid 1, jiffies 4294877996
[   89.424557]   backtrace:
[   89.424574]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.424587]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.424601]     [<c11c346c>] reserve_range+0x2c/0x132
[   89.424613]     [<c11c35cd>] system_pnp_probe+0x5b/0x76
[   89.424624]     [<c11bf5c5>] pnp_device_probe+0x7c/0x9a
[   89.424637]     [<c120ff44>] driver_probe_device+0x79/0xed
[   89.424648]     [<c120fffb>] __driver_attach+0x43/0x5f
[   89.424659]     [<c120f7c7>] bus_for_each_dev+0x3d/0x67
[   89.424670]     [<c120fe1b>] driver_attach+0x14/0x16
[   89.424681]     [<c120fb7b>] bus_add_driver+0x92/0x1bb
[   89.424692]     [<c1210227>] driver_register+0x79/0xdd
[   89.424704]     [<c11bf404>] pnp_register_driver+0x17/0x19
[   89.424717]     [<c14d774d>] pnp_system_init+0xd/0xf
[   89.424729]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.424743]     [<c14b7316>] kernel_init+0x143/0x194
[   89.424755]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.424768] kmemleak: unreferenced object 0xf6a16af0 (size 32):
[   89.424778]   comm "swapper", pid 1, jiffies 4294877996
[   89.424785]   backtrace:
[   89.424796]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.424808]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.424820]     [<c1035596>] T.333+0x21/0x50
[   89.424832]     [<c10355df>] __request_region+0x1a/0xaf
[   89.424844]     [<c11c3512>] reserve_range+0xd2/0x132
[   89.424855]     [<c11c35cd>] system_pnp_probe+0x5b/0x76
[   89.424866]     [<c11bf5c5>] pnp_device_probe+0x7c/0x9a
[   89.424876]     [<c120ff44>] driver_probe_device+0x79/0xed
[   89.424887]     [<c120fffb>] __driver_attach+0x43/0x5f
[   89.424899]     [<c120f7c7>] bus_for_each_dev+0x3d/0x67
[   89.424909]     [<c120fe1b>] driver_attach+0x14/0x16
[   89.424920]     [<c120fb7b>] bus_add_driver+0x92/0x1bb
[   89.424931]     [<c1210227>] driver_register+0x79/0xdd
[   89.424943]     [<c11bf404>] pnp_register_driver+0x17/0x19
[   89.424954]     [<c14d774d>] pnp_system_init+0xd/0xf
[   89.424966]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.425005] kmemleak: unreferenced object 0xf721b9c0 (size 16):
[   89.425015]   comm "swapper", pid 1, jiffies 4294877997
[   89.425021]   backtrace:
[   89.425032]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.425044]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.425056]     [<c11c346c>] reserve_range+0x2c/0x132
[   89.425067]     [<c11c35cd>] system_pnp_probe+0x5b/0x76
[   89.425078]     [<c11bf5c5>] pnp_device_probe+0x7c/0x9a
[   89.425090]     [<c120ff44>] driver_probe_device+0x79/0xed
[   89.425101]     [<c120fffb>] __driver_attach+0x43/0x5f
[   89.425112]     [<c120f7c7>] bus_for_each_dev+0x3d/0x67
[   89.425123]     [<c120fe1b>] driver_attach+0x14/0x16
[   89.425135]     [<c120fb7b>] bus_add_driver+0x92/0x1bb
[   89.425146]     [<c1210227>] driver_register+0x79/0xdd
[   89.425157]     [<c11bf404>] pnp_register_driver+0x17/0x19
[   89.425168]     [<c14d774d>] pnp_system_init+0xd/0xf
[   89.425179]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.425191]     [<c14b7316>] kernel_init+0x143/0x194
[   89.425204]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.425215] kmemleak: unreferenced object 0xf6a16d20 (size 32):
[   89.425224]   comm "swapper", pid 1, jiffies 4294877997
[   89.425231]   backtrace:
[   89.425242]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.425253]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.425265]     [<c1035596>] T.333+0x21/0x50
[   89.425276]     [<c10355df>] __request_region+0x1a/0xaf
[   89.425287]     [<c11c3512>] reserve_range+0xd2/0x132
[   89.425300]     [<c11c35cd>] system_pnp_probe+0x5b/0x76
[   89.425311]     [<c11bf5c5>] pnp_device_probe+0x7c/0x9a
[   89.425322]     [<c120ff44>] driver_probe_device+0x79/0xed
[   89.425334]     [<c120fffb>] __driver_attach+0x43/0x5f
[   89.425344]     [<c120f7c7>] bus_for_each_dev+0x3d/0x67
[   89.425355]     [<c120fe1b>] driver_attach+0x14/0x16
[   89.425366]     [<c120fb7b>] bus_add_driver+0x92/0x1bb
[   89.425377]     [<c1210227>] driver_register+0x79/0xdd
[   89.425388]     [<c11bf404>] pnp_register_driver+0x17/0x19
[   89.425399]     [<c14d774d>] pnp_system_init+0xd/0xf
[   89.425410]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.425422] kmemleak: unreferenced object 0xf721ba00 (size 16):
[   89.425431]   comm "swapper", pid 1, jiffies 4294877997
[   89.425438]   backtrace:
[   89.425448]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.425460]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.425471]     [<c11c346c>] reserve_range+0x2c/0x132
[   89.425483]     [<c11c35cd>] system_pnp_probe+0x5b/0x76
[   89.425495]     [<c11bf5c5>] pnp_device_probe+0x7c/0x9a
[   89.425506]     [<c120ff44>] driver_probe_device+0x79/0xed
[   89.425517]     [<c120fffb>] __driver_attach+0x43/0x5f
[   89.425529]     [<c120f7c7>] bus_for_each_dev+0x3d/0x67
[   89.425540]     [<c120fe1b>] driver_attach+0x14/0x16
[   89.425551]     [<c120fb7b>] bus_add_driver+0x92/0x1bb
[   89.425562]     [<c1210227>] driver_register+0x79/0xdd
[   89.425573]     [<c11bf404>] pnp_register_driver+0x17/0x19
[   89.425585]     [<c14d774d>] pnp_system_init+0xd/0xf
[   89.425597]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.425609]     [<c14b7316>] kernel_init+0x143/0x194
[   89.425621]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.425633] kmemleak: unreferenced object 0xf6a16d70 (size 32):
[   89.425643]   comm "swapper", pid 1, jiffies 4294877997
[   89.425650]   backtrace:
[   89.425661]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.425672]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.425684]     [<c1035596>] T.333+0x21/0x50
[   89.425696]     [<c10355df>] __request_region+0x1a/0xaf
[   89.425708]     [<c11c3512>] reserve_range+0xd2/0x132
[   89.425719]     [<c11c35cd>] system_pnp_probe+0x5b/0x76
[   89.425730]     [<c11bf5c5>] pnp_device_probe+0x7c/0x9a
[   89.425740]     [<c120ff44>] driver_probe_device+0x79/0xed
[   89.425751]     [<c120fffb>] __driver_attach+0x43/0x5f
[   89.425761]     [<c120f7c7>] bus_for_each_dev+0x3d/0x67
[   89.425772]     [<c120fe1b>] driver_attach+0x14/0x16
[   89.425783]     [<c120fb7b>] bus_add_driver+0x92/0x1bb
[   89.425795]     [<c1210227>] driver_register+0x79/0xdd
[   89.425806]     [<c11bf404>] pnp_register_driver+0x17/0x19
[   89.425818]     [<c14d774d>] pnp_system_init+0xd/0xf
[   89.425829]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.425840] kmemleak: unreferenced object 0xf721ba40 (size 16):
[   89.425849]   comm "swapper", pid 1, jiffies 4294877997
[   89.425856]   backtrace:
[   89.425867]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.425878]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.425890]     [<c11c346c>] reserve_range+0x2c/0x132
[   89.425902]     [<c11c35cd>] system_pnp_probe+0x5b/0x76
[   89.425914]     [<c11bf5c5>] pnp_device_probe+0x7c/0x9a
[   89.425925]     [<c120ff44>] driver_probe_device+0x79/0xed
[   89.425937]     [<c120fffb>] __driver_attach+0x43/0x5f
[   89.425949]     [<c120f7c7>] bus_for_each_dev+0x3d/0x67
[   89.425960]     [<c120fe1b>] driver_attach+0x14/0x16
[   89.425970]     [<c120fb7b>] bus_add_driver+0x92/0x1bb
[   89.425981]     [<c1210227>] driver_register+0x79/0xdd
[   89.425992]     [<c11bf404>] pnp_register_driver+0x17/0x19
[   89.426003]     [<c14d774d>] pnp_system_init+0xd/0xf
[   89.426014]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.426026]     [<c14b7316>] kernel_init+0x143/0x194
[   89.426038]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.426050] kmemleak: unreferenced object 0xf6a16dc0 (size 32):
[   89.426059]   comm "swapper", pid 1, jiffies 4294877997
[   89.426066]   backtrace:
[   89.426077]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.426088]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.426100]     [<c1035596>] T.333+0x21/0x50
[   89.426111]     [<c10355df>] __request_region+0x1a/0xaf
[   89.426123]     [<c11c3512>] reserve_range+0xd2/0x132
[   89.426134]     [<c11c35cd>] system_pnp_probe+0x5b/0x76
[   89.426146]     [<c11bf5c5>] pnp_device_probe+0x7c/0x9a
[   89.426158]     [<c120ff44>] driver_probe_device+0x79/0xed
[   89.426169]     [<c120fffb>] __driver_attach+0x43/0x5f
[   89.426181]     [<c120f7c7>] bus_for_each_dev+0x3d/0x67
[   89.426192]     [<c120fe1b>] driver_attach+0x14/0x16
[   89.426204]     [<c120fb7b>] bus_add_driver+0x92/0x1bb
[   89.426215]     [<c1210227>] driver_register+0x79/0xdd
[   89.426227]     [<c11bf404>] pnp_register_driver+0x17/0x19
[   89.426238]     [<c14d774d>] pnp_system_init+0xd/0xf
[   89.426249]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.426260] kmemleak: unreferenced object 0xf721ba80 (size 16):
[   89.426269]   comm "swapper", pid 1, jiffies 4294877997
[   89.426276]   backtrace:
[   89.426286]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.426298]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.426310]     [<c11c346c>] reserve_range+0x2c/0x132
[   89.426322]     [<c11c35cd>] system_pnp_probe+0x5b/0x76
[   89.426333]     [<c11bf5c5>] pnp_device_probe+0x7c/0x9a
[   89.426345]     [<c120ff44>] driver_probe_device+0x79/0xed
[   89.426356]     [<c120fffb>] __driver_attach+0x43/0x5f
[   89.426367]     [<c120f7c7>] bus_for_each_dev+0x3d/0x67
[   89.426378]     [<c120fe1b>] driver_attach+0x14/0x16
[   89.426388]     [<c120fb7b>] bus_add_driver+0x92/0x1bb
[   89.426400]     [<c1210227>] driver_register+0x79/0xdd
[   89.426411]     [<c11bf404>] pnp_register_driver+0x17/0x19
[   89.426423]     [<c14d774d>] pnp_system_init+0xd/0xf
[   89.426434]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.426446]     [<c14b7316>] kernel_init+0x143/0x194
[   89.426457]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.426469] kmemleak: unreferenced object 0xf6a16e10 (size 32):
[   89.426478]   comm "swapper", pid 1, jiffies 4294877997
[   89.426484]   backtrace:
[   89.426495]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.426507]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.426518]     [<c1035596>] T.333+0x21/0x50
[   89.426530]     [<c10355df>] __request_region+0x1a/0xaf
[   89.426542]     [<c11c3512>] reserve_range+0xd2/0x132
[   89.426553]     [<c11c35cd>] system_pnp_probe+0x5b/0x76
[   89.426564]     [<c11bf5c5>] pnp_device_probe+0x7c/0x9a
[   89.426576]     [<c120ff44>] driver_probe_device+0x79/0xed
[   89.426587]     [<c120fffb>] __driver_attach+0x43/0x5f
[   89.426598]     [<c120f7c7>] bus_for_each_dev+0x3d/0x67
[   89.426609]     [<c120fe1b>] driver_attach+0x14/0x16
[   89.426620]     [<c120fb7b>] bus_add_driver+0x92/0x1bb
[   89.426632]     [<c1210227>] driver_register+0x79/0xdd
[   89.426644]     [<c11bf404>] pnp_register_driver+0x17/0x19
[   89.426655]     [<c14d774d>] pnp_system_init+0xd/0xf
[   89.426665]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.426686] kmemleak: unreferenced object 0xf721bb00 (size 16):
[   89.426695]   comm "swapper", pid 1, jiffies 4294877997
[   89.426702]   backtrace:
[   89.426713]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.426724]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.426736]     [<c11c346c>] reserve_range+0x2c/0x132
[   89.426749]     [<c11c35cd>] system_pnp_probe+0x5b/0x76
[   89.426760]     [<c11bf5c5>] pnp_device_probe+0x7c/0x9a
[   89.426772]     [<c120ff44>] driver_probe_device+0x79/0xed
[   89.426784]     [<c120fffb>] __driver_attach+0x43/0x5f
[   89.426795]     [<c120f7c7>] bus_for_each_dev+0x3d/0x67
[   89.426806]     [<c120fe1b>] driver_attach+0x14/0x16
[   89.426817]     [<c120fb7b>] bus_add_driver+0x92/0x1bb
[   89.426829]     [<c1210227>] driver_register+0x79/0xdd
[   89.426841]     [<c11bf404>] pnp_register_driver+0x17/0x19
[   89.426852]     [<c14d774d>] pnp_system_init+0xd/0xf
[   89.426863]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.426876]     [<c14b7316>] kernel_init+0x143/0x194
[   89.426888]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.426899] kmemleak: unreferenced object 0xf6a16eb0 (size 32):
[   89.426908]   comm "swapper", pid 1, jiffies 4294877997
[   89.426915]   backtrace:
[   89.426926]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.426938]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.426949]     [<c1035596>] T.333+0x21/0x50
[   89.426960]     [<c10355df>] __request_region+0x1a/0xaf
[   89.426971]     [<c11c3512>] reserve_range+0xd2/0x132
[   89.426982]     [<c11c35cd>] system_pnp_probe+0x5b/0x76
[   89.426993]     [<c11bf5c5>] pnp_device_probe+0x7c/0x9a
[   89.427005]     [<c120ff44>] driver_probe_device+0x79/0xed
[   89.427016]     [<c120fffb>] __driver_attach+0x43/0x5f
[   89.427027]     [<c120f7c7>] bus_for_each_dev+0x3d/0x67
[   89.427039]     [<c120fe1b>] driver_attach+0x14/0x16
[   89.427050]     [<c120fb7b>] bus_add_driver+0x92/0x1bb
[   89.427061]     [<c1210227>] driver_register+0x79/0xdd
[   89.427073]     [<c11bf404>] pnp_register_driver+0x17/0x19
[   89.427084]     [<c14d774d>] pnp_system_init+0xd/0xf
[   89.427095]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.427106] kmemleak: unreferenced object 0xf721bb40 (size 16):
[   89.427115]   comm "swapper", pid 1, jiffies 4294877997
[   89.427122]   backtrace:
[   89.427133]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.427144]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.427155]     [<c11c346c>] reserve_range+0x2c/0x132
[   89.427167]     [<c11c35cd>] system_pnp_probe+0x5b/0x76
[   89.427178]     [<c11bf5c5>] pnp_device_probe+0x7c/0x9a
[   89.427190]     [<c120ff44>] driver_probe_device+0x79/0xed
[   89.427201]     [<c120fffb>] __driver_attach+0x43/0x5f
[   89.427213]     [<c120f7c7>] bus_for_each_dev+0x3d/0x67
[   89.427224]     [<c120fe1b>] driver_attach+0x14/0x16
[   89.427236]     [<c120fb7b>] bus_add_driver+0x92/0x1bb
[   89.427247]     [<c1210227>] driver_register+0x79/0xdd
[   89.427258]     [<c11bf404>] pnp_register_driver+0x17/0x19
[   89.427270]     [<c14d774d>] pnp_system_init+0xd/0xf
[   89.427281]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.427293]     [<c14b7316>] kernel_init+0x143/0x194
[   89.427305]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.427317] kmemleak: unreferenced object 0xf6a16f00 (size 32):
[   89.427326]   comm "swapper", pid 1, jiffies 4294877997
[   89.427333]   backtrace:
[   89.427344]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.427355]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.427367]     [<c1035596>] T.333+0x21/0x50
[   89.427379]     [<c10355df>] __request_region+0x1a/0xaf
[   89.427391]     [<c11c3512>] reserve_range+0xd2/0x132
[   89.427403]     [<c11c35cd>] system_pnp_probe+0x5b/0x76
[   89.427414]     [<c11bf5c5>] pnp_device_probe+0x7c/0x9a
[   89.427425]     [<c120ff44>] driver_probe_device+0x79/0xed
[   89.427436]     [<c120fffb>] __driver_attach+0x43/0x5f
[   89.427447]     [<c120f7c7>] bus_for_each_dev+0x3d/0x67
[   89.427458]     [<c120fe1b>] driver_attach+0x14/0x16
[   89.427469]     [<c120fb7b>] bus_add_driver+0x92/0x1bb
[   89.427479]     [<c1210227>] driver_register+0x79/0xdd
[   89.427490]     [<c11bf404>] pnp_register_driver+0x17/0x19
[   89.427501]     [<c14d774d>] pnp_system_init+0xd/0xf
[   89.427512]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.444375] kmemleak: unreferenced object 0xf6058b40 (size 192):
[   89.444388]   comm "swapper", pid 1, jiffies 4294878822
[   89.444396]   backtrace:
[   89.444414]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.444428]     [<c10a3308>] __kmalloc+0x133/0x153
[   89.444444]     [<c11bc09f>] acpi_processor_register_performance+0x237/0x3a8
[   89.444459]     [<c1011b7c>] acpi_cpufreq_cpu_init+0xb3/0x4d7
[   89.444472]     [<c12441a4>] cpufreq_add_dev+0x197/0x58f
[   89.444485]     [<c120eec8>] sysdev_driver_register+0x93/0xe2
[   89.444499]     [<c124314b>] cpufreq_register_driver+0x9e/0x16d
[   89.444514]     [<c14bf9d6>] acpi_cpufreq_init+0xaf/0xda
[   89.444526]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.444540]     [<c14b7316>] kernel_init+0x143/0x194
[   89.444552]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.444576]     [<ffffffff>] 0xffffffff
[   89.444804] kmemleak: unreferenced object 0xf6058d20 (size 192):
[   89.444814]   comm "swapper", pid 1, jiffies 4294878827
[   89.444822]   backtrace:
[   89.444834]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.444846]     [<c10a3308>] __kmalloc+0x133/0x153
[   89.444859]     [<c11bc09f>] acpi_processor_register_performance+0x237/0x3a8
[   89.444872]     [<c1011b7c>] acpi_cpufreq_cpu_init+0xb3/0x4d7
[   89.444884]     [<c12441a4>] cpufreq_add_dev+0x197/0x58f
[   89.444896]     [<c120eec8>] sysdev_driver_register+0x93/0xe2
[   89.444909]     [<c124314b>] cpufreq_register_driver+0x9e/0x16d
[   89.444922]     [<c14bf9d6>] acpi_cpufreq_init+0xaf/0xda
[   89.444933]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.444946]     [<c14b7316>] kernel_init+0x143/0x194
[   89.444958]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.444976]     [<ffffffff>] 0xffffffff
[   89.445322] kmemleak: unreferenced object 0xf616a310 (size 8):
[   89.445333]   comm "swapper", pid 1, jiffies 4294878838
[   89.445340]   backtrace:
[   89.445352]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.445364]     [<c10a3308>] __kmalloc+0x133/0x153
[   89.445377]     [<c117383d>] kvasprintf+0x26/0x45
[   89.445390]     [<c116d22c>] kobject_set_name_vargs+0x1d/0x4c
[   89.445402]     [<c116d26f>] kobject_add_varg+0x14/0x3d
[   89.445415]     [<c116d302>] kobject_add+0x43/0x49
[   89.445428]     [<c14db6c0>] memmap_init+0x5b/0x8c
[   89.445439]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.445452]     [<c14b7316>] kernel_init+0x143/0x194
[   89.445464]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.445482]     [<ffffffff>] 0xffffffff
[   89.445504] kmemleak: unreferenced object 0xf616a380 (size 8):
[   89.445514]   comm "swapper", pid 1, jiffies 4294878838
[   89.445521]   backtrace:
[   89.445533]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.445545]     [<c10a3308>] __kmalloc+0x133/0x153
[   89.445557]     [<c117383d>] kvasprintf+0x26/0x45
[   89.445569]     [<c116d22c>] kobject_set_name_vargs+0x1d/0x4c
[   89.445582]     [<c116d26f>] kobject_add_varg+0x14/0x3d
[   89.445594]     [<c116d302>] kobject_add+0x43/0x49
[   89.445606]     [<c14db6c0>] memmap_init+0x5b/0x8c
[   89.445617]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.445630]     [<c14b7316>] kernel_init+0x143/0x194
[   89.445642]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.445660]     [<ffffffff>] 0xffffffff
[   89.445682] kmemleak: unreferenced object 0xf616a3f0 (size 8):
[   89.445692]   comm "swapper", pid 1, jiffies 4294878838
[   89.445700]   backtrace:
[   89.445711]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.445723]     [<c10a3308>] __kmalloc+0x133/0x153
[   89.445735]     [<c117383d>] kvasprintf+0x26/0x45
[   89.445748]     [<c116d22c>] kobject_set_name_vargs+0x1d/0x4c
[   89.445760]     [<c116d26f>] kobject_add_varg+0x14/0x3d
[   89.445772]     [<c116d302>] kobject_add+0x43/0x49
[   89.445784]     [<c14db6c0>] memmap_init+0x5b/0x8c
[   89.445796]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.445809]     [<c14b7316>] kernel_init+0x143/0x194
[   89.445821]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.445839]     [<ffffffff>] 0xffffffff
[   89.445860] kmemleak: unreferenced object 0xf616a460 (size 8):
[   89.445870]   comm "swapper", pid 1, jiffies 4294878838
[   89.445877]   backtrace:
[   89.445889]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.445901]     [<c10a3308>] __kmalloc+0x133/0x153
[   89.445912]     [<c117383d>] kvasprintf+0x26/0x45
[   89.445925]     [<c116d22c>] kobject_set_name_vargs+0x1d/0x4c
[   89.445938]     [<c116d26f>] kobject_add_varg+0x14/0x3d
[   89.445950]     [<c116d302>] kobject_add+0x43/0x49
[   89.445961]     [<c14db6c0>] memmap_init+0x5b/0x8c
[   89.445973]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.445986]     [<c14b7316>] kernel_init+0x143/0x194
[   89.445998]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.446017]     [<ffffffff>] 0xffffffff
[   89.446039] kmemleak: unreferenced object 0xf616a4d0 (size 8):
[   89.446049]   comm "swapper", pid 1, jiffies 4294878838
[   89.446056]   backtrace:
[   89.446068]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.446080]     [<c10a3308>] __kmalloc+0x133/0x153
[   89.446092]     [<c117383d>] kvasprintf+0x26/0x45
[   89.446104]     [<c116d22c>] kobject_set_name_vargs+0x1d/0x4c
[   89.446117]     [<c116d26f>] kobject_add_varg+0x14/0x3d
[   89.446129]     [<c116d302>] kobject_add+0x43/0x49
[   89.446141]     [<c14db6c0>] memmap_init+0x5b/0x8c
[   89.446153]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.446166]     [<c14b7316>] kernel_init+0x143/0x194
[   89.446178]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.446196]     [<ffffffff>] 0xffffffff
[   89.446217] kmemleak: unreferenced object 0xf616a540 (size 8):
[   89.446227]   comm "swapper", pid 1, jiffies 4294878838
[   89.446234]   backtrace:
[   89.446246]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.446258]     [<c10a3308>] __kmalloc+0x133/0x153
[   89.446269]     [<c117383d>] kvasprintf+0x26/0x45
[   89.446282]     [<c116d22c>] kobject_set_name_vargs+0x1d/0x4c
[   89.446294]     [<c116d26f>] kobject_add_varg+0x14/0x3d
[   89.446307]     [<c116d302>] kobject_add+0x43/0x49
[   89.446319]     [<c14db6c0>] memmap_init+0x5b/0x8c
[   89.446330]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.446343]     [<c14b7316>] kernel_init+0x143/0x194
[   89.446355]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.446373]     [<ffffffff>] 0xffffffff
[   89.446395] kmemleak: unreferenced object 0xf616a5b0 (size 8):
[   89.446405]   comm "swapper", pid 1, jiffies 4294878838
[   89.446413]   backtrace:
[   89.446425]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.446437]     [<c10a3308>] __kmalloc+0x133/0x153
[   89.446448]     [<c117383d>] kvasprintf+0x26/0x45
[   89.446461]     [<c116d22c>] kobject_set_name_vargs+0x1d/0x4c
[   89.446473]     [<c116d26f>] kobject_add_varg+0x14/0x3d
[   89.446485]     [<c116d302>] kobject_add+0x43/0x49
[   89.446497]     [<c14db6c0>] memmap_init+0x5b/0x8c
[   89.446508]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.446521]     [<c14b7316>] kernel_init+0x143/0x194
[   89.446533]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.446551]     [<ffffffff>] 0xffffffff
[   89.446572] kmemleak: unreferenced object 0xf616a620 (size 8):
[   89.446582]   comm "swapper", pid 1, jiffies 4294878838
[   89.446590]   backtrace:
[   89.446602]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.446613]     [<c10a3308>] __kmalloc+0x133/0x153
[   89.446625]     [<c117383d>] kvasprintf+0x26/0x45
[   89.446638]     [<c116d22c>] kobject_set_name_vargs+0x1d/0x4c
[   89.446650]     [<c116d26f>] kobject_add_varg+0x14/0x3d
[   89.446662]     [<c116d302>] kobject_add+0x43/0x49
[   89.446673]     [<c14db6c0>] memmap_init+0x5b/0x8c
[   89.446684]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.446696]     [<c14b7316>] kernel_init+0x143/0x194
[   89.446708]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.446726]     [<ffffffff>] 0xffffffff
[   89.446748] kmemleak: unreferenced object 0xf616a690 (size 8):
[   89.446758]   comm "swapper", pid 1, jiffies 4294878838
[   89.446765]   backtrace:
[   89.446777]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.446789]     [<c10a3308>] __kmalloc+0x133/0x153
[   89.446801]     [<c117383d>] kvasprintf+0x26/0x45
[   89.446814]     [<c116d22c>] kobject_set_name_vargs+0x1d/0x4c
[   89.446826]     [<c116d26f>] kobject_add_varg+0x14/0x3d
[   89.446838]     [<c116d302>] kobject_add+0x43/0x49
[   89.446850]     [<c14db6c0>] memmap_init+0x5b/0x8c
[   89.446861]     [<c1001142>] do_one_initcall+0x55/0x12d
[   89.446874]     [<c14b7316>] kernel_init+0x143/0x194
[   89.446886]     [<c10038c7>] kernel_thread_helper+0x7/0x1a
[   89.446904]     [<ffffffff>] 0xffffffff
[   89.447343] kmemleak: unreferenced object 0xf674a230 (size 8):
[   89.447353]   comm "console_setup", pid 716, jiffies 4294879005
[   89.447361]   backtrace:
[   89.447373]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.447385]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.447399]     [<c11cd6d4>] tty_ldisc_try_get+0x1b/0x149
[   89.447411]     [<c11cd862>] tty_ldisc_get+0x17/0x3a
[   89.447423]     [<c11cd8cf>] tty_ldisc_reinit+0x24/0x3e
[   89.447435]     [<c11cd90a>] tty_ldisc_release+0x21/0x32
[   89.447447]     [<c11c9577>] tty_release_dev+0x3c3/0x3f5
[   89.447459]     [<c11c95bb>] tty_release+0x12/0x1c
[   89.447470]     [<c10a839a>] __fput+0xe6/0x176
[   89.447481]     [<c10a843d>] fput+0x13/0x15
[   89.447493]     [<c10a5a3f>] filp_close+0x51/0x5b
[   89.447504]     [<c10b14bf>] sys_dup3+0xda/0x105
[   89.447515]     [<c10b1541>] sys_dup2+0x57/0x62
[   89.447517]     [<c1002c5c>] syscall_call+0x7/0xb
[   89.447517]     [<ffffffff>] 0xffffffff
[   89.447610] kmemleak: unreferenced object 0xf674a498 (size 8):
[   89.447620]   comm "setfont", pid 729, jiffies 4294879011
[   89.447627]   backtrace:
[   89.447639]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.447652]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.447665]     [<c11cd6d4>] tty_ldisc_try_get+0x1b/0x149
[   89.447677]     [<c11cd862>] tty_ldisc_get+0x17/0x3a
[   89.447690]     [<c11cd8cf>] tty_ldisc_reinit+0x24/0x3e
[   89.447702]     [<c11cd90a>] tty_ldisc_release+0x21/0x32
[   89.447714]     [<c11c9577>] tty_release_dev+0x3c3/0x3f5
[   89.447726]     [<c11c95bb>] tty_release+0x12/0x1c
[   89.447738]     [<c10a839a>] __fput+0xe6/0x176
[   89.447748]     [<c10a843d>] fput+0x13/0x15
[   89.447760]     [<c10a5a3f>] filp_close+0x51/0x5b
[   89.447773]     [<c103118c>] put_files_struct+0x58/0x9c
[   89.447785]     [<c1031207>] exit_files+0x37/0x3c
[   89.447796]     [<c103259a>] do_exit+0x1a1/0x5fd
[   89.447808]     [<c1032a55>] do_group_exit+0x5f/0x86
[   89.447819]     [<c1032a8f>] sys_exit_group+0x13/0x17
[   89.447831] kmemleak: unreferenced object 0xf674a4d0 (size 8):
[   89.447840]   comm "console_setup", pid 716, jiffies 4294879015
[   89.447848]   backtrace:
[   89.447859]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.447872]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.447884]     [<c11cd6d4>] tty_ldisc_try_get+0x1b/0x149
[   89.447896]     [<c11cd862>] tty_ldisc_get+0x17/0x3a
[   89.447909]     [<c11cd8cf>] tty_ldisc_reinit+0x24/0x3e
[   89.447921]     [<c11cd90a>] tty_ldisc_release+0x21/0x32
[   89.447933]     [<c11c9577>] tty_release_dev+0x3c3/0x3f5
[   89.447945]     [<c11c95bb>] tty_release+0x12/0x1c
[   89.447956]     [<c10a839a>] __fput+0xe6/0x176
[   89.447966]     [<c10a843d>] fput+0x13/0x15
[   89.447978]     [<c10a5a3f>] filp_close+0x51/0x5b
[   89.447989]     [<c10b14bf>] sys_dup3+0xda/0x105
[   89.448000]     [<c10b1541>] sys_dup2+0x57/0x62
[   89.448011]     [<c1002c5c>] syscall_call+0x7/0xb
[   89.448029]     [<ffffffff>] 0xffffffff
[   89.448103] kmemleak: unreferenced object 0xf674a508 (size 8):
[   89.448114]   comm "console_setup", pid 716, jiffies 4294879016
[   89.448121]   backtrace:
[   89.448133]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.448145]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.448158]     [<c11cd6d4>] tty_ldisc_try_get+0x1b/0x149
[   89.448170]     [<c11cd862>] tty_ldisc_get+0x17/0x3a
[   89.448182]     [<c11cd8cf>] tty_ldisc_reinit+0x24/0x3e
[   89.448194]     [<c11cd90a>] tty_ldisc_release+0x21/0x32
[   89.448206]     [<c11c9577>] tty_release_dev+0x3c3/0x3f5
[   89.448218]     [<c11c95bb>] tty_release+0x12/0x1c
[   89.448229]     [<c10a839a>] __fput+0xe6/0x176
[   89.448240]     [<c10a843d>] fput+0x13/0x15
[   89.448252]     [<c10a5a3f>] filp_close+0x51/0x5b
[   89.448263]     [<c10b14bf>] sys_dup3+0xda/0x105
[   89.448274]     [<c10b1541>] sys_dup2+0x57/0x62
[   89.448285]     [<c1002c5c>] syscall_call+0x7/0xb
[   89.448303]     [<ffffffff>] 0xffffffff
[   89.448315] kmemleak: unreferenced object 0xf616a738 (size 8):
[   89.448325]   comm "setfont", pid 735, jiffies 4294879022
[   89.448332]   backtrace:
[   89.448344]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.448356]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.448368]     [<c11cd6d4>] tty_ldisc_try_get+0x1b/0x149
[   89.448381]     [<c11cd862>] tty_ldisc_get+0x17/0x3a
[   89.448393]     [<c11cd8cf>] tty_ldisc_reinit+0x24/0x3e
[   89.448405]     [<c11cd90a>] tty_ldisc_release+0x21/0x32
[   89.448417]     [<c11c9577>] tty_release_dev+0x3c3/0x3f5
[   89.448429]     [<c11c95bb>] tty_release+0x12/0x1c
[   89.448440]     [<c10a839a>] __fput+0xe6/0x176
[   89.448451]     [<c10a843d>] fput+0x13/0x15
[   89.448462]     [<c10a5a3f>] filp_close+0x51/0x5b
[   89.448474]     [<c103118c>] put_files_struct+0x58/0x9c
[   89.448486]     [<c1031207>] exit_files+0x37/0x3c
[   89.448497]     [<c103259a>] do_exit+0x1a1/0x5fd
[   89.448508]     [<c1032a55>] do_group_exit+0x5f/0x86
[   89.448520]     [<c1032a8f>] sys_exit_group+0x13/0x17
[   89.448531] kmemleak: unreferenced object 0xf616a770 (size 8):
[   89.448541]   comm "console_setup", pid 716, jiffies 4294879025
[   89.448549]   backtrace:
[   89.448560]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.448573]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.448585]     [<c11cd6d4>] tty_ldisc_try_get+0x1b/0x149
[   89.448597]     [<c11cd862>] tty_ldisc_get+0x17/0x3a
[   89.448609]     [<c11cd8cf>] tty_ldisc_reinit+0x24/0x3e
[   89.448621]     [<c11cd90a>] tty_ldisc_release+0x21/0x32
[   89.448634]     [<c11c9577>] tty_release_dev+0x3c3/0x3f5
[   89.448645]     [<c11c95bb>] tty_release+0x12/0x1c
[   89.448656]     [<c10a839a>] __fput+0xe6/0x176
[   89.448667]     [<c10a843d>] fput+0x13/0x15
[   89.448679]     [<c10a5a3f>] filp_close+0x51/0x5b
[   89.448690]     [<c10b14bf>] sys_dup3+0xda/0x105
[   89.448701]     [<c10b1541>] sys_dup2+0x57/0x62
[   89.448713]     [<c1002c5c>] syscall_call+0x7/0xb
[   89.448730]     [<ffffffff>] 0xffffffff
[   89.448800] kmemleak: unreferenced object 0xf616a7a8 (size 8):
[   89.448811]   comm "console_setup", pid 716, jiffies 4294879026
[   89.448818]   backtrace:
[   89.448830]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.448842]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.448855]     [<c11cd6d4>] tty_ldisc_try_get+0x1b/0x149
[   89.448867]     [<c11cd862>] tty_ldisc_get+0x17/0x3a
[   89.448879]     [<c11cd8cf>] tty_ldisc_reinit+0x24/0x3e
[   89.448892]     [<c11cd90a>] tty_ldisc_release+0x21/0x32
[   89.448904]     [<c11c9577>] tty_release_dev+0x3c3/0x3f5
[   89.448916]     [<c11c95bb>] tty_release+0x12/0x1c
[   89.448927]     [<c10a839a>] __fput+0xe6/0x176
[   89.448937]     [<c10a843d>] fput+0x13/0x15
[   89.448949]     [<c10a5a3f>] filp_close+0x51/0x5b
[   89.448960]     [<c10b14bf>] sys_dup3+0xda/0x105
[   89.448971]     [<c10b1541>] sys_dup2+0x57/0x62
[   89.448982]     [<c1002c5c>] syscall_call+0x7/0xb
[   89.448999]     [<ffffffff>] 0xffffffff
[   89.449011] kmemleak: unreferenced object 0xf616aa10 (size 8):
[   89.449021]   comm "setfont", pid 741, jiffies 4294879033
[   89.449028]   backtrace:
[   89.449040]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.449052]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.449065]     [<c11cd6d4>] tty_ldisc_try_get+0x1b/0x149
[   89.449077]     [<c11cd862>] tty_ldisc_get+0x17/0x3a
[   89.449089]     [<c11cd8cf>] tty_ldisc_reinit+0x24/0x3e
[   89.449102]     [<c11cd90a>] tty_ldisc_release+0x21/0x32
[   89.449114]     [<c11c9577>] tty_release_dev+0x3c3/0x3f5
[   89.449126]     [<c11c95bb>] tty_release+0x12/0x1c
[   89.449137]     [<c10a839a>] __fput+0xe6/0x176
[   89.449147]     [<c10a843d>] fput+0x13/0x15
[   89.449159]     [<c10a5a3f>] filp_close+0x51/0x5b
[   89.449171]     [<c103118c>] put_files_struct+0x58/0x9c
[   89.449182]     [<c1031207>] exit_files+0x37/0x3c
[   89.449194]     [<c103259a>] do_exit+0x1a1/0x5fd
[   89.449205]     [<c1032a55>] do_group_exit+0x5f/0x86
[   89.449217]     [<c1032a8f>] sys_exit_group+0x13/0x17
[   89.449229] kmemleak: unreferenced object 0xf616aa48 (size 8):
[   89.449238]   comm "console_setup", pid 716, jiffies 4294879036
[   89.449246]   backtrace:
[   89.449258]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.449270]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.449282]     [<c11cd6d4>] tty_ldisc_try_get+0x1b/0x149
[   89.449294]     [<c11cd862>] tty_ldisc_get+0x17/0x3a
[   89.449306]     [<c11cd8cf>] tty_ldisc_reinit+0x24/0x3e
[   89.449318]     [<c11cd90a>] tty_ldisc_release+0x21/0x32
[   89.449330]     [<c11c9577>] tty_release_dev+0x3c3/0x3f5
[   89.449342]     [<c11c95bb>] tty_release+0x12/0x1c
[   89.449353]     [<c10a839a>] __fput+0xe6/0x176
[   89.449364]     [<c10a843d>] fput+0x13/0x15
[   89.449376]     [<c10a5a3f>] filp_close+0x51/0x5b
[   89.449387]     [<c10b14bf>] sys_dup3+0xda/0x105
[   89.449398]     [<c10b1541>] sys_dup2+0x57/0x62
[   89.449409]     [<c1002c5c>] syscall_call+0x7/0xb
[   89.449427]     [<ffffffff>] 0xffffffff
[   89.449500] kmemleak: unreferenced object 0xf616aa80 (size 8):
[   89.449511]   comm "console_setup", pid 716, jiffies 4294879037
[   89.449518]   backtrace:
[   89.449530]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.449542]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.449555]     [<c11cd6d4>] tty_ldisc_try_get+0x1b/0x149
[   89.449567]     [<c11cd862>] tty_ldisc_get+0x17/0x3a
[   89.449579]     [<c11cd8cf>] tty_ldisc_reinit+0x24/0x3e
[   89.449591]     [<c11cd90a>] tty_ldisc_release+0x21/0x32
[   89.449603]     [<c11c9577>] tty_release_dev+0x3c3/0x3f5
[   89.449615]     [<c11c95bb>] tty_release+0x12/0x1c
[   89.449626]     [<c10a839a>] __fput+0xe6/0x176
[   89.449637]     [<c10a843d>] fput+0x13/0x15
[   89.449649]     [<c10a5a3f>] filp_close+0x51/0x5b
[   89.449660]     [<c10b14bf>] sys_dup3+0xda/0x105
[   89.449671]     [<c10b1541>] sys_dup2+0x57/0x62
[   89.449682]     [<c1002c5c>] syscall_call+0x7/0xb
[   89.449700]     [<ffffffff>] 0xffffffff
[   89.449711] kmemleak: unreferenced object 0xf616ace8 (size 8):
[   89.449721]   comm "setfont", pid 747, jiffies 4294879043
[   89.449729]   backtrace:
[   89.449740]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.449753]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.449765]     [<c11cd6d4>] tty_ldisc_try_get+0x1b/0x149
[   89.449777]     [<c11cd862>] tty_ldisc_get+0x17/0x3a
[   89.449789]     [<c11cd8cf>] tty_ldisc_reinit+0x24/0x3e
[   89.449802]     [<c11cd90a>] tty_ldisc_release+0x21/0x32
[   89.449814]     [<c11c9577>] tty_release_dev+0x3c3/0x3f5
[   89.449826]     [<c11c95bb>] tty_release+0x12/0x1c
[   89.449837]     [<c10a839a>] __fput+0xe6/0x176
[   89.449847]     [<c10a843d>] fput+0x13/0x15
[   89.449859]     [<c10a5a3f>] filp_close+0x51/0x5b
[   89.449871]     [<c103118c>] put_files_struct+0x58/0x9c
[   89.449882]     [<c1031207>] exit_files+0x37/0x3c
[   89.449894]     [<c103259a>] do_exit+0x1a1/0x5fd
[   89.449905]     [<c1032a55>] do_group_exit+0x5f/0x86
[   89.449916]     [<c1032a8f>] sys_exit_group+0x13/0x17
[   89.449928] kmemleak: unreferenced object 0xf616ad20 (size 8):
[   89.449938]   comm "console_setup", pid 716, jiffies 4294879047
[   89.449946]   backtrace:
[   89.449957]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.449970]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.449982]     [<c11cd6d4>] tty_ldisc_try_get+0x1b/0x149
[   89.449994]     [<c11cd862>] tty_ldisc_get+0x17/0x3a
[   89.450005]     [<c11cd8cf>] tty_ldisc_reinit+0x24/0x3e
[   89.450017]     [<c11cd90a>] tty_ldisc_release+0x21/0x32
[   89.450029]     [<c11c9577>] tty_release_dev+0x3c3/0x3f5
[   89.450040]     [<c11c95bb>] tty_release+0x12/0x1c
[   89.450051]     [<c10a839a>] __fput+0xe6/0x176
[   89.450062]     [<c10a843d>] fput+0x13/0x15
[   89.450074]     [<c10a5a3f>] filp_close+0x51/0x5b
[   89.450084]     [<c10b14bf>] sys_dup3+0xda/0x105
[   89.450095]     [<c10b1541>] sys_dup2+0x57/0x62
[   89.450107]     [<c1002c5c>] syscall_call+0x7/0xb
[   89.450124]     [<ffffffff>] 0xffffffff
[   89.450197] kmemleak: unreferenced object 0xf616ad58 (size 8):
[   89.450207]   comm "console_setup", pid 716, jiffies 4294879048
[   89.450215]   backtrace:
[   89.450227]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.450239]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.450252]     [<c11cd6d4>] tty_ldisc_try_get+0x1b/0x149
[   89.450264]     [<c11cd862>] tty_ldisc_get+0x17/0x3a
[   89.450276]     [<c11cd8cf>] tty_ldisc_reinit+0x24/0x3e
[   89.450288]     [<c11cd90a>] tty_ldisc_release+0x21/0x32
[   89.450300]     [<c11c9577>] tty_release_dev+0x3c3/0x3f5
[   89.450312]     [<c11c95bb>] tty_release+0x12/0x1c
[   89.450323]     [<c10a839a>] __fput+0xe6/0x176
[   89.450334]     [<c10a843d>] fput+0x13/0x15
[   89.450346]     [<c10a5a3f>] filp_close+0x51/0x5b
[   89.450357]     [<c10b14bf>] sys_dup3+0xda/0x105
[   89.450368]     [<c10b1541>] sys_dup2+0x57/0x62
[   89.450379]     [<c1002c5c>] syscall_call+0x7/0xb
[   89.450396]     [<ffffffff>] 0xffffffff
[   89.450408] kmemleak: unreferenced object 0xf616afc0 (size 8):
[   89.450418]   comm "setfont", pid 753, jiffies 4294879054
[   89.450426]   backtrace:
[   89.450437]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.450449]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.450462]     [<c11cd6d4>] tty_ldisc_try_get+0x1b/0x149
[   89.450475]     [<c11cd862>] tty_ldisc_get+0x17/0x3a
[   89.450487]     [<c11cd8cf>] tty_ldisc_reinit+0x24/0x3e
[   89.450499]     [<c11cd90a>] tty_ldisc_release+0x21/0x32
[   89.450511]     [<c11c9577>] tty_release_dev+0x3c3/0x3f5
[   89.450523]     [<c11c95bb>] tty_release+0x12/0x1c
[   89.450534]     [<c10a839a>] __fput+0xe6/0x176
[   89.450544]     [<c10a843d>] fput+0x13/0x15
[   89.450556]     [<c10a5a3f>] filp_close+0x51/0x5b
[   89.450568]     [<c103118c>] put_files_struct+0x58/0x9c
[   89.450579]     [<c1031207>] exit_files+0x37/0x3c
[   89.450591]     [<c103259a>] do_exit+0x1a1/0x5fd
[   89.450602]     [<c1032a55>] do_group_exit+0x5f/0x86
[   89.450613]     [<c1032a8f>] sys_exit_group+0x13/0x17
[   89.450625] kmemleak: unreferenced object 0xf6204000 (size 8):
[   89.450635]   comm "console_setup", pid 716, jiffies 4294879057
[   89.450643]   backtrace:
[   89.450654]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.450666]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.450679]     [<c11cd6d4>] tty_ldisc_try_get+0x1b/0x149
[   89.450691]     [<c11cd862>] tty_ldisc_get+0x17/0x3a
[   89.450703]     [<c11cd8cf>] tty_ldisc_reinit+0x24/0x3e
[   89.450716]     [<c11cd90a>] tty_ldisc_release+0x21/0x32
[   89.450727]     [<c11c9577>] tty_release_dev+0x3c3/0x3f5
[   89.450739]     [<c11c95bb>] tty_release+0x12/0x1c
[   89.450750]     [<c10a839a>] __fput+0xe6/0x176
[   89.450761]     [<c10a843d>] fput+0x13/0x15
[   89.450772]     [<c10a5a3f>] filp_close+0x51/0x5b
[   89.450784]     [<c10b14bf>] sys_dup3+0xda/0x105
[   89.450794]     [<c10b1541>] sys_dup2+0x57/0x62
[   89.450806]     [<c1002c5c>] syscall_call+0x7/0xb
[   89.450823]     [<ffffffff>] 0xffffffff
[   89.457764] kmemleak: unreferenced object 0xf634e040 (size 20):
[   89.457775]   comm "path_id", pid 994, jiffies 4294879612
[   89.457783]   backtrace:
[   89.457801]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.457815]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.457828]     [<c1176395>] __debug_object_init+0x37/0x2d7
[   89.457840]     [<c1176660>] debug_object_init+0x13/0x17
[   89.457854]     [<c10440ce>] hrtimer_init+0x1c/0x75
[   89.457868]     [<c102e7a7>] copy_process+0x6fc/0xff4
[   89.457880]     [<c102f1cc>] do_fork+0x12d/0x2bf
[   89.457892]     [<c10017d4>] sys_clone+0x22/0x29
[   89.457904]     [<c1002c5c>] syscall_call+0x7/0xb
[   89.457928]     [<ffffffff>] 0xffffffff
[   89.457966] kmemleak: unreferenced object 0xf634e0c0 (size 20):
[   89.457976]   comm "udevd", pid 1000, jiffies 4294879621
[   89.457983]   backtrace:
[   89.457995]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.458007]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.458019]     [<c1176395>] __debug_object_init+0x37/0x2d7
[   89.458031]     [<c1176660>] debug_object_init+0x13/0x17
[   89.458044]     [<c10440ce>] hrtimer_init+0x1c/0x75
[   89.458056]     [<c102e7a7>] copy_process+0x6fc/0xff4
[   89.458068]     [<c102f1cc>] do_fork+0x12d/0x2bf
[   89.458080]     [<c10017d4>] sys_clone+0x22/0x29
[   89.458091]     [<c1002c5c>] syscall_call+0x7/0xb
[   89.458108]     [<ffffffff>] 0xffffffff
[   89.458135] kmemleak: unreferenced object 0xf634e100 (size 20):
[   89.458145]   comm "path_id", pid 994, jiffies 4294879625
[   89.458152]   backtrace:
[   89.458164]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.458176]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.458188]     [<c1176395>] __debug_object_init+0x37/0x2d7
[   89.458199]     [<c1176660>] debug_object_init+0x13/0x17
[   89.458212]     [<c10440ce>] hrtimer_init+0x1c/0x75
[   89.458224]     [<c102e7a7>] copy_process+0x6fc/0xff4
[   89.458237]     [<c102f1cc>] do_fork+0x12d/0x2bf
[   89.458248]     [<c10017d4>] sys_clone+0x22/0x29
[   89.458259]     [<c1002c5c>] syscall_call+0x7/0xb
[   89.458276]     [<ffffffff>] 0xffffffff
[   89.458297] kmemleak: unreferenced object 0xf634e180 (size 20):
[   89.458307]   comm "path_id", pid 1015, jiffies 4294879628
[   89.458315]   backtrace:
[   89.458327]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.458339]     [<c10a2726>] kmem_cache_alloc+0xdb/0x142
[   89.458350]     [<c1176395>] __debug_object_init+0x37/0x2d7
[   89.458362]     [<c1176660>] debug_object_init+0x13/0x17
[   89.458375]     [<c10440ce>] hrtimer_init+0x1c/0x75
[   89.458388]     [<c102e7a7>] copy_process+0x6fc/0xff4
[   89.458399]     [<c102f1cc>] do_fork+0x12d/0x2bf
[   89.458411]     [<c10017d4>] sys_clone+0x22/0x29
[   89.458422]     [<c1002c5c>] syscall_call+0x7/0xb
[   89.458438]     [<ffffffff>] 0xffffffff
[   89.495008] kmemleak: unreferenced object 0xf61cc9b0 (size 2048):
[   89.495021]   comm "usb-stor-scan", pid 1357, jiffies 4294881685
[   89.495029]   backtrace:
[   89.495047]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.495061]     [<c10a3308>] __kmalloc+0x133/0x153
[   89.495073]     [<c10a4106>] T.554+0xd/0xf
[   89.495085]     [<c10a411b>] pcpu_mem_alloc+0x13/0x40
[   89.495097]     [<c10a4190>] pcpu_extend_area_map+0x48/0xb8
[   89.495109]     [<c10a42ee>] pcpu_alloc+0xee/0x37e
[   89.495121]     [<c10a4597>] __alloc_percpu+0xa/0xf
[   89.495134]     [<c1178515>] __percpu_counter_init+0x55/0x97
[   89.495146]     [<c108f3cc>] bdi_init+0x5f/0xa2
[   89.495159]     [<c115e6ea>] blk_alloc_queue_node+0x56/0x138
[   89.495170]     [<c115e804>] blk_init_queue_node+0x1c/0x114
[   89.495182]     [<c115e907>] blk_init_queue+0xb/0xd
[   89.495194]     [<c121bb3d>] __scsi_alloc_queue+0x17/0xea
[   89.495206]     [<c121bc20>] scsi_alloc_queue+0x10/0x49
[   89.495218]     [<c121d2b6>] scsi_alloc_sdev+0x135/0x1ca
[   89.495230]     [<c121d536>] scsi_probe_and_add_lun+0xaf/0x80d
[   89.495248] kmemleak: unreferenced object 0xf633a888 (size 8):
[   89.495258]   comm "usb-stor-scan", pid 1357, jiffies 4294881685
[   89.495266]   backtrace:
[   89.495278]     [<c10a5809>] kmemleak_alloc+0x15c/0x253
[   89.495289]     [<c10a3308>] __kmalloc+0x133/0x153
[   89.495302]     [<c117383d>] kvasprintf+0x26/0x45
[   89.495315]     [<c116d22c>] kobject_set_name_vargs+0x1d/0x4c
[   89.495327]     [<c120da1b>] dev_set_name+0x14/0x16
[   89.495340]     [<c121f1ec>] scsi_sysfs_device_initialize+0x92/0xe2
[   89.495352]     [<c121d2f0>] scsi_alloc_sdev+0x16f/0x1ca
[   89.495363]     [<c121d536>] scsi_probe_and_add_lun+0xaf/0x80d
[   89.495376]     [<c121dea9>] __scsi_scan_target+0x7e/0x435
[   89.495387]     [<c121e2a0>] scsi_scan_channel+0x40/0x66
[   89.495399]     [<c121e348>] scsi_scan_host_selected+0x82/0xba
[   89.495411]     [<c121e3da>] do_scsi_scan_host+0x5a/0x63
[   89.495423]     [<c121e637>] scsi_scan_host+0x159/0x171
[   89.495457]     [<f8c79b5a>] usb_stor_scan_thread+0x135/0x14d [usb_storage]
[   89.495472]     [<c1041a5d>] kthread+0x66/0x6b
[   89.495485]     [<c10038c7>] kernel_thread_helper+0x7/0x1a

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbXLWTi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbXLWTi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 14:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbXLWTiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 14:38:20 -0500
Received: from ns.netcenter.hu ([195.228.254.57]:50391 "EHLO netcenter.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbXLWTiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 14:38:19 -0500
X-Greylist: delayed 914 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Dec 2007 14:38:18 EST
Message-ID: <015601c84598$fa668f30$9900a8c0@dcccs>
From: "Janos Haar" <djani22@netcenter.hu>
To: <linux-kernel@vger.kernel.org>
Subject: xfs|loop|raid: attempt to access beyond end of device
Date: Sun, 23 Dec 2007 20:21:08 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1914
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1914
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, list,

I have a little problem on one of my productive system.

The system sometimes crashed, like this:

Dec 23 08:53:05 Albohacen-global kernel: attempt to access beyond end of
device
Dec 23 08:53:05 Albohacen-global kernel: loop0: rw=1, want=50552830649176,
limit=3085523200
Dec 23 08:53:05 Albohacen-global kernel: Buffer I/O error on device loop0,
logical block 6319103831146
Dec 23 08:53:05 Albohacen-global kernel: lost page write due to I/O error on
loop0
...
Dec 23 09:08:02 Albohacen-global kernel: attempt to access beyond end of
device
Dec 23 09:08:02 Albohacen-global kernel: loop0: rw=1, want=50552830649688,
limit=3085523200
Dec 23 09:08:02 Albohacen-global kernel: Buffer I/O error on device loop0,
logical block 6319103831210
Dec 23 09:08:02 Albohacen-global kernel: lost page write due to I/O error on
loop0
...
Dec 23 09:08:07 Albohacen-global kernel: attempt to access beyond end of
device
Dec 23 09:08:07 Albohacen-global kernel: loop0: rw=1, want=50552830657824,
limit=3085523200
Dec 23 09:08:07 Albohacen-global kernel: BUG: soft lockup detected on CPU#0!
Dec 23 09:08:07 Albohacen-global kernel:
Dec 23 09:08:07 Albohacen-global kernel: Call Trace:
Dec 23 09:08:07 Albohacen-global kernel:  <IRQ>  [<ffffffff802645e4>]
_spin_lock+0x9/0xb
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff802b0565>]
softlockup_tick+0xd5/0xea
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff8024bf04>]
run_local_timers+0x13/0x15
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff80292a7f>]
update_process_times+0x4c/0x78
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff8027606e>]
smp_local_timer_interrupt+0x34/0x54
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff802767dd>]
smp_apic_timer_interrupt+0x43/0x5a
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff8025d296>]
apic_timer_interrupt+0x66/0x70
Dec 23 09:08:07 Albohacen-global kernel:  <EOI>  [<ffffffff80263619>]
__mutex_lock_slowpath+0x20f/0x225
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff80263654>]
mutex_lock+0x25/0x29
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff80397894>]
xfs_icsb_modify_counters+0x121/0x1c2
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff80397a7f>]
xfs_mod_incore_sb+0x34/0x75
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff8036ba6c>]
xfs_bmap_add_extent_delay_real+0xe33/0xefa
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff8035e05b>]
xfs_alloc_vextent+0x35f/0x3e2
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff8036c2cf>]
xfs_bmap_add_extent+0x20b/0x386
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff8037360e>]
xfs_btree_init_cursor+0x34/0x1c6
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff8036d8f0>]
xfs_bmapi+0x947/0xf44
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff8038698d>]
xfs_iext_get_ext+0x34/0x58
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff8038cdd1>]
xfs_iomap_write_allocate+0x239/0x3bf
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff8038bf7e>]
xfs_iomap+0x2b1/0x355
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff802b5443>]
mempool_alloc_slab+0x11/0x13
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff803ac201>]
xfs_bmap+0x10/0x12
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff803a57c6>]
xfs_map_blocks+0x32/0x68
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff803a6707>]
xfs_page_state_convert+0x31a/0x636
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff803a6b6f>]
xfs_vm_writepage+0xa5/0xde
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff802b7011>]
generic_writepages+0x1c8/0x334
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff803a6aca>]
xfs_vm_writepage+0x0/0xde
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff803a5840>]
xfs_vm_writepages+0x44/0x4d
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff80259236>]
do_writepages+0x2b/0x3a
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff8022f498>]
__writeback_single_inode+0x1d1/0x35f
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff802207af>]
sync_sb_inodes+0x1ac/0x269
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff8029b6d9>]
keventd_create_kthread+0x0/0x79
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff8024ee78>]
writeback_inodes+0x99/0xf6
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff802544bb>]
pdflush+0x0/0x1f9
Dec 23 09:08:07 Albohacen-global kernel:  [<ffffffff802b7612>]
wb_kupdate+0x9f/0x112
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff802544bb>]
pdflush+0x0/0x1f9
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff80254606>]
pdflush+0x14b/0x1f9
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff80286670>]
__wake_up_common+0x3e/0x68
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff802b7573>]
wb_kupdate+0x0/0x112
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff80232167>]
kthread+0xf5/0x128
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff8022761c>]
schedule_tail+0x45/0xae
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff8025d478>]
child_rip+0xa/0x12
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff8029b6d9>]
keventd_create_kthread+0x0/0x79
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff80232072>]
kthread+0x0/0x128
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff8025d46e>]
child_rip+0x0/0x12
Dec 23 09:08:08 Albohacen-global kernel:
Dec 23 09:08:08 Albohacen-global kernel: BUG: soft lockup detected on CPU#0!
Dec 23 09:08:08 Albohacen-global kernel:
Dec 23 09:08:08 Albohacen-global kernel: Call Trace:
Dec 23 09:08:08 Albohacen-global kernel:  <IRQ>  [<ffffffff802645e4>]
_spin_lock+0x9/0xb
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff802b0565>]
softlockup_tick+0xd5/0xea
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff8024bf04>]
run_local_timers+0x13/0x15
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff80292a7f>]
update_process_times+0x4c/0x78
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff8027606e>]
smp_local_timer_interrupt+0x34/0x54
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff802767dd>]
smp_apic_timer_interrupt+0x43/0x5a
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff8025d296>]
apic_timer_interrupt+0x66/0x70
Dec 23 09:08:08 Albohacen-global kernel:  <EOI>  [<ffffffff803977b7>]
xfs_icsb_modify_counters+0x44/0x1c2
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff80397a7f>]
xfs_mod_incore_sb+0x34/0x75
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff8036ba6c>]
xfs_bmap_add_extent_delay_real+0xe33/0xefa
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff8035e05b>]
xfs_alloc_vextent+0x35f/0x3e2
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff8036c2cf>]
xfs_bmap_add_extent+0x20b/0x386
Dec 23 09:08:08 Albohacen-global kernel:  [<ffffffff8037360e>]
xfs_btree_init_cursor+0x34/0x1c6
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff8036d8f0>]
xfs_bmapi+0x947/0xf44
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff8038698d>]
xfs_iext_get_ext+0x34/0x58
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff8038cdd1>]
xfs_iomap_write_allocate+0x239/0x3bf
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff8038bf7e>]
xfs_iomap+0x2b1/0x355
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff802b5443>]
mempool_alloc_slab+0x11/0x13
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff803ac201>]
xfs_bmap+0x10/0x12
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff803a57c6>]
xfs_map_blocks+0x32/0x68
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff803a6707>]
xfs_page_state_convert+0x31a/0x636
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff803a6b6f>]
xfs_vm_writepage+0xa5/0xde
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff802b7011>]
generic_writepages+0x1c8/0x334
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff803a6aca>]
xfs_vm_writepage+0x0/0xde
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff8029b6d9>]
keventd_create_kthread+0x0/0x79
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff803a5840>]
xfs_vm_writepages+0x44/0x4d
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff80259236>]
do_writepages+0x2b/0x3a
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff8024dbbb>]
__filemap_fdatawrite_range+0x58/0x63
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff802b50ab>]
filemap_flush+0x17/0x19
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff803adc37>]
xfs_flush_inode_work+0x18/0x24
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff803ade7e>]
xfssyncd+0x115/0x156
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff803add69>]
xfssyncd+0x0/0x156
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff80232167>]
kthread+0xf5/0x128
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff8022761c>]
schedule_tail+0x45/0xae
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff8025d478>]
child_rip+0xa/0x12
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff8029b6d9>]
keventd_create_kthread+0x0/0x79
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff80232072>]
kthread+0x0/0x128
Dec 23 09:08:09 Albohacen-global kernel:  [<ffffffff8025d46e>]
child_rip+0x0/0x12
Dec 23 09:08:09 Albohacen-global kernel:
Dec 23 09:08:09 Albohacen-global kernel: Filesystem "loop0": Access to block
zero in inode 397821447 start_block: 0 start_off: 0 blkcnt: 0 extent-state:
0 las
tx: e4
Dec 23 09:08:18 Albohacen-global last message repeated 66 times
Dec 23 09:08:19 Albohacen-global nmbd[3128]: [2007/12/23 09:08:19, 0]
nmbd/nmbd_become_lmb.c:become_local_master_stage2(396)
Dec 23 09:08:19 Albohacen-global nmbd[3128]:   *****
Dec 23 09:08:19 Albohacen-global nmbd[3128]:
Dec 23 09:08:19 Albohacen-global nmbd[3128]:   Samba name server
ALBOHACEN-GLOBAL is now a local master browser for workgroup MSHOME on
subnet 192.168.1.100
Dec 23 09:08:19 Albohacen-global nmbd[3128]:
Dec 23 09:08:19 Albohacen-global nmbd[3128]:   *****
Dec 23 09:08:19 Albohacen-global kernel: Filesystem "loop0": Access to block
zero in inode 397821447 start_block: 0 start_off: 0 blkcnt: 0 extent-state:
0 las
tx: e4
Dec 23 09:08:22 Albohacen-global last message repeated 19 times

some more info:

[root@Albohacen-global ~]# uname -a
Linux Albohacen-global 2.6.21.1 #3 SMP Thu May 3 04:33:36 CEST 2007 x86_64
x86_64 x86_64 GNU/Linux
[root@Albohacen-global ~]# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
[multipath] [faulty]
md1 : active raid4 sdf2[1] sde2[0] sdd2[5] sdc2[4] sdb2[3] sda2[2]
      19558720 blocks level 4, 64k chunk, algorithm 0 [6/6] [UUUUUU]
      bitmap: 8/239 pages [32KB], 8KB chunk

md2 : active raid4 sdf3[1] sde3[0] sdd3[5] sdc3[4] sdb3[3] sda3[2]
      1542761600 blocks level 4, 64k chunk, algorithm 0 [6/6] [UUUUUU]
      bitmap: 0/148 pages [0KB], 1024KB chunk

md0 : active raid1 sdb1[1] sda1[0]
      104320 blocks [2/2] [UU]

unused devices: <none>
[root@Albohacen-global ~]# losetup /dev/loop0
/dev/loop0: [0010]:6598 (/dev/md2), encryption blowfish (type 18)
[root@Albohacen-global ~]# mount
/dev/md1 on / type ext3 (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
/dev/md0 on /boot type ext2 (rw)
tmpfs on /dev/shm type tmpfs (rw)
none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
/dev/loop0 on /mnt/BIG_CRYPTED type xfs (rw)
[root@Albohacen-global ~]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md1               19G   14G  4.5G  75% /
/dev/md0               99M   13M   82M  14% /boot
tmpfs                 493M     0  493M   0% /dev/shm
/dev/loop0            1.5T  953G  519G  65% /mnt/BIG_CRYPTED

If somebody need some more information, please ask!
Somebody have an idea, whats this?

Regards,

Janos Haar


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbZAGRBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbZAGRBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZAGRB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:01:27 -0500
Received: from zaphod.dth.net ([85.159.112.68]:54179 "EHLO zaphod.dth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbZAGRB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:01:26 -0500
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Jan 2009 12:01:25 EST
Date: Wed, 7 Jan 2009 17:52:18 +0100
From: dth <dth@dth.net>
To: linux-kernel@vger.kernel.org
Subject: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090107165218.GA11132@dth.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am running low-power motherboard (via epia5000 c3) as a storage (samba/nfs)
server. (uses about 20 watts when both storage drives are in powersave mode)

OS = debian lenny

Pimairy drive (60gig 2.5" pata disk using libata = sda)
 512MB ext3 partition as /boot
 swap, rest of the drive is XFS root file system.

storage:
2 x 750GB drives on a sata controller (FastTrak S150 TX2plus)
sdb & sdc which have 1 big XFS partition.

Any kernel i try to boot after 2.6.28-git2 (i tried git4-9) 
sooner or later gives me an XFS error:

[    0.000000] Linux version 2.6.28-git8 (root@laptopdth) (gcc version 4.3.2 (Ubuntu 4
.3.2-1ubuntu11) ) #1 Tue Jan 6 09:48:02 PST 2009

[*SNIP*] for full output http://www.dth.net/kernel/c3/netconsole_2.6.28-git8-error.txt 

[   21.535820] XFS mounting filesystem sdb1
[   21.646126] Starting XFS recovery on filesystem: sdb1 (logdev: internal)
[   21.747772] XFS internal error XFS_WANT_CORRUPTED_GOTO at line 3327 of file 
               fs/xfs/xfs_btree.c.  Caller 0xc01e9d71
[   21.747916] Pid: 1392, comm: mount Not tainted 2.6.28-git8 #1
[   21.748033] Call Trace:
[   21.748130]  [<c01e98b9>] xfs_btree_delrec+0x5b9/0xa50
[   21.748247]  [<c01e9d71>] xfs_btree_delete+0x21/0x70
[   21.748339]  [<c01e72ff>] xfs_btree_read_buf_block+0x4f/0x70
[   21.748462]  [<c01e5dda>] xfs_bmbt_init_key_from_rec+0xa/0x20
[   21.748556]  [<c01e66d5>] xfs_lookup_get_search_key+0x25/0x40
[   21.748680]  [<c01e9d71>] xfs_btree_delete+0x21/0x70
[   21.748771]  [<c01e2ad5>] xfs_bmap_del_extent+0x2f5/0x960
[   21.748894]  [<c01e383e>] xfs_bunmapi+0x5be/0x980
[   21.749000]  [<c01fba82>] xfs_itruncate_finish+0x1c2/0x2f0
[   21.749137]  [<c0210852>] xfs_inactive+0x1d2/0x3d0
[   21.749228]  [<c01fc33d>] xfs_imap_to_bp+0x5d/0xd0
[   21.749354]  [<c01775bc>] clear_inode+0x5c/0xb0
[   21.749443]  [<c0177a8c>] generic_delete_inode+0x6c/0xc0
[   21.749559]  [<c0177157>] iput+0x47/0x50
[   21.749644]  [<c02056fe>] xlog_recover_process_one_iunlink+0xae/0xe0
[   21.749768]  [<c02057a7>] xlog_recover_process_iunlinks+0x77/0xe0
[   21.749863]  [<c020584f>] xlog_recover_finish+0x3f/0x90
[   21.749980]  [<c0209390>] xfs_mountfs+0x450/0x550
[   21.750126]  [<c02122e6>] kmem_alloc+0x56/0xb0
[   21.750216]  [<c020995d>] xfs_mru_cache_create+0xdd/0x120
[   21.750344]  [<c021ac92>] xfs_fs_fill_super+0x152/0x2a0
[   21.750441]  [<c016b608>] get_sb_bdev+0xe8/0x130
[   21.750556]  [<c0219602>] xfs_fs_get_sb+0x12/0x20
[   21.750646]  [<c021ab40>] xfs_fs_fill_super+0x0/0x2a0
[   21.750760]  [<c016a949>] vfs_kern_mount+0x39/0x80
[   21.750850]  [<c016a9cf>] do_kern_mount+0x2f/0xc0
[   21.750972]  [<c017b3e5>] do_mount+0x5a5/0x5f0
[   21.751061]  [<c016c35f>] sys_stat64+0xf/0x30
[   21.751186]  [<c0150271>] __get_free_pages+0x11/0x30
[   21.751280]  [<c017b496>] sys_mount+0x66/0xa0
[   21.751394]  [<c0102c72>] syscall_call+0x7/0xb
[   21.751494] Filesystem "sdb1": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.  Caller 0xc021086b
[   21.751514] 
[   21.751718] Pid: 1392, comm: mount Not tainted 2.6.28-git8 #1
[   21.751799] Call Trace:
[   21.751893]  [<c020b586>] xfs_trans_cancel+0x46/0xd0
[   21.751986]  [<c021086b>] xfs_inactive+0x1eb/0x3d0
[   21.752102]  [<c021086b>] xfs_inactive+0x1eb/0x3d0
[   21.752192]  [<c01fc33d>] xfs_imap_to_bp+0x5d/0xd0
[   21.752307]  [<c01775bc>] clear_inode+0x5c/0xb0
[   21.752396]  [<c0177a8c>] generic_delete_inode+0x6c/0xc0
[   21.752512]  [<c0177157>] iput+0x47/0x50
[   21.752596]  [<c02056fe>] xlog_recover_process_one_iunlink+0xae/0xe0
[   21.752719]  [<c02057a7>] xlog_recover_process_iunlinks+0x77/0xe0
[   21.752815]  [<c020584f>] xlog_recover_finish+0x3f/0x90
[   21.752930]  [<c0209390>] xfs_mountfs+0x450/0x550
[   21.753022]  [<c02122e6>] kmem_alloc+0x56/0xb0
[   21.753136]  [<c020995d>] xfs_mru_cache_create+0xdd/0x120
[   21.753232]  [<c021ac92>] xfs_fs_fill_super+0x152/0x2a0
[   21.753348]  [<c016b608>] get_sb_bdev+0xe8/0x130
[   21.753439]  [<c0219602>] xfs_fs_get_sb+0x12/0x20
[   21.753555]  [<c021ab40>] xfs_fs_fill_super+0x0/0x2a0
[   21.753645]  [<c016a949>] vfs_kern_mount+0x39/0x80
[   21.753760]  [<c016a9cf>] do_kern_mount+0x2f/0xc0
[   21.753852]  [<c017b3e5>] do_mount+0x5a5/0x5f0
[   21.753965]  [<c016c35f>] sys_stat64+0xf/0x30
[   21.754054]  [<c0150271>] __get_free_pages+0x11/0x30
[   21.754172]  [<c017b496>] sys_mount+0x66/0xa0
[   21.754258]  [<c0102c72>] syscall_call+0x7/0xb
[   21.754378] xfs_force_shutdown(sdb1,0x8) called from line 1165 of file fs/xfs/xfs_trans.c.  Return address = 0xc020b59c
[   21.754522] Filesystem "sdb1": Corruption of in-memory data detected.  Shutting down filesystem: sdb1
[   21.754661] Please umount the filesystem, and rectify the problem(s)
[   21.754814] BUG: unable to handle kernel NULL pointer dereference at 00000054
[   21.754990] IP: [<c02057bf>] xlog_recover_process_iunlinks+0x8f/0xe0
[   21.755137] *pde = 00000000 
[   21.755263] Oops: 0000 [#1] 
[   21.755385] last sysfs file: /sys/class/net/lo/operstate
[   21.755490] Modules linked in: i2c_viapro i2c_core via_agp agpgart sata_promise sd_mod
[   21.755906] 
[   21.755976] Pid: 1392, comm: mount Not tainted (2.6.28-git8 #1) EPIA
[   21.756091] EIP: 0060:[<c02057bf>] EFLAGS: 00010296 CPU: 0
[   21.756181] EIP is at xlog_recover_process_iunlinks+0x8f/0xe0
[   21.756293] EAX: 00000000 EBX: de827f00 ECX: 00000005 EDX: df231000
[   21.756384] ESI: ffffffff EDI: df231000 EBP: 00000026 ESP: df383e14
[   21.756501]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   21.756592] Process mount (pid: 1392, ti=df382000 task=deb37b60 task.ti=df382000)
[   21.756712] Stack:
[   21.756792]  df383e24 00000026 00000003 00000000 00000000 df2572e0 00000000 00000003
[   21.757192]  df231000 c020584f 00000003 00000000 00000000 c0209390 00000017 00000000
[   21.757691]  08000004 00000000 00000000 00000001 00000058 00000000 c02122e6 00000001
[   21.758243] Call Trace:
[   21.758327]  [<c020584f>] xlog_recover_finish+0x3f/0x90
[   21.758476]  [<c0209390>] xfs_mountfs+0x450/0x550
[   21.758615]  [<c02122e6>] kmem_alloc+0x56/0xb0
[   21.758756]  [<c020995d>] xfs_mru_cache_create+0xdd/0x120
[   21.758908]  [<c021ac92>] xfs_fs_fill_super+0x152/0x2a0
[   21.759059]  [<c016b608>] get_sb_bdev+0xe8/0x130
[   21.759200]  [<c0219602>] xfs_fs_get_sb+0x12/0x20
[   21.759350]  [<c021ab40>] xfs_fs_fill_super+0x0/0x2a0
[   21.759500]  [<c016a949>] vfs_kern_mount+0x39/0x80
[   21.759647]  [<c016a9cf>] do_kern_mount+0x2f/0xc0
[   21.759794]  [<c017b3e5>] do_mount+0x5a5/0x5f0
[   21.759934]  [<c016c35f>] sys_stat64+0xf/0x30
[   21.760103]  [<c0150271>] __get_free_pages+0x11/0x30
[   21.760255]  [<c017b496>] sys_mount+0x66/0xa0
[   21.760396]  [<c0102c72>] syscall_call+0x7/0xb
[   21.760535] Code: e8 e7 f6 00 00 55 89 f1 8b 54 24 04 89 f8 e8 a9 fe ff ff 89 c6 8d 44 24 0c 50 8b 4c 24 08 31 d2 [   27.297839] NET: Registered protocol family 10
[   38.240089] eth0: no IPv6 routers present
[   38.995204] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   38.995468] NFSD: starting 90-second grace period


When i reboot to git2 again and run a xfs_check and/or xfs_repair nothing shows up.
It just works without problems. So i think it's not actually an XFS problem but
something "underneath"
It's slow hardware and i have been reading about locking situations, which could be
triggered easier on my (slow) hardware then any modern (faster) hardware.

Anyone else bitten by the same problem ?

Danny
-- 

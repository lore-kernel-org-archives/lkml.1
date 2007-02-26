Return-Path: <linux-kernel-owner+w=401wt.eu-S1030253AbXBZOBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030253AbXBZOBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 09:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030241AbXBZOBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 09:01:48 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50367 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030253AbXBZOBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 09:01:47 -0500
From: Vincent ROQUETA <Vincent.roqueta@bull.net>
To: nfsv4@linux-nfs.org
Subject: Re: [Patch][NFSv4]: Kernel panic (handle kernel NULL pointer) occurred in NFSv4 by the nfs_update_inode()
Date: Mon, 26 Feb 2007 15:05:35 +0100
User-Agent: KMail/1.9.5
Cc: patrice.martinez@bull.net, linux-kernel@vger.kernel.org,
       "fj-shic" <shic@np.css.fujitsu.com>
References: <012701c7433f$98321c50$adb1220a@shic> <200702261402.41953.Vincent.roqueta@bull.net>
In-Reply-To: <200702261402.41953.Vincent.roqueta@bull.net>
MIME-Version: 1.0
Message-Id: <200702261505.35701.Vincent.roqueta@bull.net>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/02/2007 15:03:15,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/02/2007 15:03:16,
	Serialize complete at 26/02/2007 15:03:16
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 26 février 2007 14:02, Vincent ROQUETA a écrit :
> Le lundi 29 janvier 2007 01:51, fj-shic a écrit :
> > Hi, all
> >
> >    Is there any good idea about this issue?
> >    I really think this is a problem in the NFSv4, which should be
> > resolved in the latest kernel.
>
> I have applied this patch to fix the bug I have seen in the same function
> (See mail : "Client freeze with 64K pages" in the NFSv4 mailing list )
>
> As result, it seems to have an other unfixed bug forward in the NFSv4
> stack. (in function nfs4_free_client, at unmount time), but at least the
> kernel does not crash at the same point.
>
> Since I am using a few used 64K pages configuration, I may "activate"
> unknown bugs on wildly used NFS code.

More over, 
The patch seems to introduce a delay between two mounts.
During this delay, it is not possible to umount/mount a nfsv4.
Here are the traces I have got doing a long serie of mount/umount :
.............
.............
mount: ns2:/: can't read superblock
umount: /mnt/nfs/: not mounted
mount: ns2:/: can't read superblock
umount: /mnt/nfs/: not mounted
mount: ns2:/: can't read superblock
umount: /mnt/nfs/: not mounted
mount: ns2:/: can't read superblock
..........
.........
--------------------------------------------------------------------------------------------------------------- 

NFS: nfs_update_inode(0:15/7946242 ct=1
info=0xe)
VFS: Busy inodes after unmount of 0:15. Self-destruct in 5 seconds.  Have a
nice day...
kernel BUG at fs/nfs/nfs4state.c:125!
umount[11087]: bugcheck! 0 [1]
Modules linked in: nfs sg scsi_dump perfbull mdm nfsd exportfs lockd eip ep
rms elan4 elan3 sunrpc elan qsnet ide_cd cdrom vfat fat dm_mod thermal
processor fan button uhci_hcd ehci_hcd e100 e1000 ext3 jbd aic7xxx
scsi_transport_spi sd_mod scsi_mod
>
Pid: 11087, CPU 3, comm:               umount
psr : 00001010081a6018 ifs : 800000000000038a ip  : [<a0000002083189e0>]
Not tainted
ip is at nfs4_free_client+0x1e0/0x200 [nfs]
unat: 0000000000000000 pfs : 000000000000038a rsc : 0000000000000003
rnat: 0000000000000073 bsps: 0000000000000073 pr  : 0000000005552959
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000002083189e0 b6  : a000000100065220 b7  : a0000001003781a0
f6  : 1003e0000000000000028 f7  : 1003e28f5c28f5c28f5c3
f8  : 1003e00000000000000fa f9  : 1003e0000000032000000
f10 : 1003e000000003b9aca00 f11 : 1003ed6bf94d5e57a42bd
r1  : a000000100a6e140 r2  : 0000000000004000 r3  : e000000004a20000
r8  : 0000000000000029 r9  : 0000000000000001 r10 : a0000001008884c0
r11 : 0000000000000000 r12 : e00000010f06fd60 r13 : e00000010f060000
r14 : 0000000000004000 r15 : a0000001008884c0 r16 : 0000000000004000
r17 : 0000000000000003 r18 : 0000000000000000 r19 : 0000000000000000
r20 : 0000000000000004 r21 : 0000000000000000 r22 : e00000010f060f54
r23 : 0000000000000001 r24 : e000000103140f5c r25 : e000000103140f40
r26 : e000000103140008 r27 : 0000000000000073 r28 : 0000000000000073
r29 : 6666666666666667 r30 : 00000000000000c8 r31 : 00000000000004b0
>
Call Trace:
 [<a000000100010f60>] show_stack+0x80/0xa0
                                sp=e00000010f06f8b0 bsp=e00000010f0612e8
 [<a000000100011870>] show_regs+0x890/0x8c0
                                sp=e00000010f06fa80 bsp=e00000010f0612a0
    r32 : e00000010f06fce8 r33 : e00000010f06fa90 r34 : e00000010f06fbe0
    r35 : e00000010f06fc18 r36 : e00000010f06fc30 r37 : e00000010f06fbf0
    r38 : a000000100037b20 r39 : 0000000000000510 r40 : e00000010f06fab0
 [<a000000100037b20>] die+0x1a0/0x4c0
                                sp=e00000010f06faa0 bsp=e00000010f061250
    r32 : a0000001005e5c78 r33 : e00000010f06fba0 r34 : 0000000000000000
    r35 : 0000000000000003 r36 : a000000100736ae0 r37 : a000000100736ad8
    r38 : a000000100736adc r39 : a000000100037e80 r40 : 0000000000000309
    r41 : a000000100a6e140
 [<a000000100037e80>] die_if_kernel+0x40/0x60
                                sp=e00000010f06fac0 bsp=e00000010f061220
    r32 : a0000001005e5c78 r33 : e00000010f06fba0 r34 : 0000000000000000
    r35 : a000000100038550 r36 : 0000000000000289 r37 : e00000010f06fd38
 [<a000000100038550>] ia64_bad_break+0x6b0/0x820
                                sp=e00000010f06fac0 bsp=e00000010f0611f0
    r32 : 0000000000000000 r33 : e00000010f06fba0 r34 : a00000010000b780
    r35 : 0000000000000002 r36 : a0000001000a2550
 [<a00000010000b780>] ia64_leave_kernel+0x0/0x280
                                sp=e00000010f06fb90 bsp=e00000010f0611f0
 [<a0000002083189e0>] nfs4_free_client+0x1e0/0x200 [nfs]
                                sp=e00000010f06fd60 bsp=e00000010f0611a0
    r32 : e00000016f83a180 r33 : e00000016f83a1f8 r34 : 0000000000200200
    r35 : 0000000000100100 r36 : a0000002083190b0 r37 : 0000000000000288
    r38 : a0000002083041a0 r39 : a000000208332dc0 r40 : a000000208332dd8
    r41 : 000000000000007d
 [<a0000002083190b0>] nfs4_put_client+0x110/0x180 [nfs]
                                sp=e00000010f06fd60 bsp=e00000010f061178
    r32 : e00000016f83a180 r33 : a0000002083482e8 r34 : a0000002083191a0
    r35 : 0000000000000286 r36 : a0000002083041a0
 [<a0000002083191a0>] destroy_nfsv4_state+0x80/0xa0 [nfs]
                                  sp=e00000010f06fd60 bsp=e00000010f061150
     r32 : e0000001017ffbf0 r33 : e0000001017ffbf8 r34 : a0000002082d7350
     r35 : 0000000000000286 r36 : a0000002083041a0
  [<a0000002082d7350>] nfs4_kill_super+0x90/0x160 [nfs]
                                 sp=e00000010f06fd60 bsp=e00000010f061128
     r32 : e000000103154200 r33 : e0000001017ffa80 r34 : a00000010014b900
     r35 : 0000000000000308 r36 : a0000002083041a0
  [<a00000010014b900>] deactivate_super+0x140/0x220
                                 sp=e00000010f06fd60 bsp=e00000010f0610f8
     r32 : e000000103154200 r33 : a000000100880cd0 r34 : a0000002083429c0
     r35 : a000000100185060 r36 : 0000000000000389 r37 : a000000100a6e140
  [<a000000100185060>] mntput_no_expire+0x160/0x260
                                 sp=e00000010f06fd60 bsp=e00000010f0610c0
     r32 : e000000103154200 r33 : e0000001040e4c80 r34 : a0000001006e9200
     r35 : a0000001006e9300 r36 : a00000010015df20 r37 : 0000000000000205
     r38 : a000000100a6e140
  [<a00000010015df20>] path_release_on_umount+0x40/0x60
                                 sp=e00000010f06fd60 bsp=e00000010f0610a0
     r32 : e00000010f06fd78 r33 : a000000100186670 r34 : 0000000000000916
     r35 : e0000001040e4c90
  [<a000000100186670>] sys_umount+0x450/0x800
                                 sp=e00000010f06fd60 bsp=e00000010f061010
     r32 : 6000000000012db0 r33 : 0000000000000000 r34 : 600ffffffffef270
     r35 : 600ffffffffef2f0 r36 : 4000000000006f10 r37 : c000000000000309
     r38 : c000000000000611 r39 : 4000000000004650 r40 : 0000000000000000
     r41 : 0000000000000000 r42 : 0000000000000000 r43 : e00000010f06fe30
     r44 : a0000001006e9300 r45 : a000000208342a80 r46 : a000000100881e48
     r47 : a00000010000b600 r48 : 0000000000000008 r49 : a000000100a6e140
  [<a00000010000b600>] ia64_ret_from_syscall+0x0/0x20
                                 sp=e00000010f06fe30 bsp=e00000010f061010
  [<a000000000010640>] __kernel_syscall_via_break+0x0/0x20
                                 sp=e00000010f070000 bsp=e00000010f061010
 LKCD: CPU : 3 Reconfiguring memory bank information....
 LKCD: This may take a while....
 First cpu will configure dump header
 LKCD: smp_num_cpus in header 16
 CPU 3, 15 cpus remaining
 Last cpu
 LKCD: Dumping to block device (8,17) on CPU 3 ...
 LKCD: Writing dump header
 ....LKCD:
  18030 dump pages saved of 65536 each in pass 0
 LKCD:
  29090 dump pages skipped of 65536 each in pass 1
 LKCD:
  1000319 dump pages skipped of 65536 each in pass 2
 LKCD:
  0 dump pages skipped of 65536 each in pass 3
 LKCD: CPU : 3 dumped 257 blocks of 262144 bytes each
 LKCD: Dump Complete; 18030 dump pages saved.
 The system will automatically reboot now !

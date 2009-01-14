Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbZANToX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbZANToX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 14:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbZANToM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 14:44:12 -0500
Received: from eazy.amigager.de ([213.239.192.238]:41977 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZANToL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 14:44:11 -0500
Date: Wed, 14 Jan 2009 20:44:09 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com
Subject: Re: problems showing up as XFS problems on kernels after
	2.6.28-git2
Message-ID: <20090114194409.GB4509@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
References: <20090107165218.GA11132@dth.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107165218.GA11132@dth.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added CC:]

On Wed, Jan 07, 2009 at 17:52:18 +0100, dth wrote:
> Am running low-power motherboard (via epia5000 c3) as a storage (samba/nfs)
> server. (uses about 20 watts when both storage drives are in powersave mode)
> 
> OS = debian lenny
> 
> Pimairy drive (60gig 2.5" pata disk using libata = sda)
>  512MB ext3 partition as /boot
>  swap, rest of the drive is XFS root file system.
> 
> storage:
> 2 x 750GB drives on a sata controller (FastTrak S150 TX2plus)
> sdb & sdc which have 1 big XFS partition.
> 
> Any kernel i try to boot after 2.6.28-git2 (i tried git4-9) 
> sooner or later gives me an XFS error:

[...]

> Anyone else bitten by the same problem ?
y
Hi,

I get the same on a Mac mini Core Duo using 2.6.29-rc1. I just booted,
started firefox and my /home died.

XFS internal error XFS_WANT_CORRUPTED_GOTO at line 3327 of file linux-2.6/fs/xfs/xfs_btree.c.  Caller 0xc022e9c6
Pid: 4937, comm: firefox-bin Not tainted 2.6.29-rc1-00224-ga652504 #11
Call Trace:
 [<c022e6d9>] xfs_btree_delrec+0xbd9/0xea0
 [<c022e9c6>] xfs_btree_delete+0x26/0x90
 [<c022b355>] xfs_btree_lookup_get_block+0xa5/0xe0
 [<c022933a>] xfs_bmbt_init_key_from_rec+0xa/0x20
 [<c022c6ba>] xfs_btree_lookup+0x21a/0x460
 [<c022e9c6>] xfs_btree_delete+0x26/0x90
 [<c02255ff>] xfs_bmap_del_extent+0x64f/0xb70
 [<c02262ea>] xfs_bunmapi+0x65a/0xb30
 [<c0244f6b>] xfs_itruncate_finish+0x1ab/0x3e0
 [<c026115d>] xfs_inactive+0x3cd/0x4f0
 [<c019113c>] clear_inode+0x5c/0x100
 [<c01917fe>] generic_delete_inode+0xce/0xe0
 [<c0190b24>] iput+0x44/0x50
 [<c01898a0>] do_unlinkat+0xe0/0x160
 [<c0188180>] lock_rename+0x0/0xa0
 [<c01033c5>] sysenter_do_call+0x12/0x25
Filesystem "dm-1": XFS internal error xfs_trans_cancel at line 1164 of file linux-2.6/fs/xfs/xfs_trans.c. 
Caller 0xc0261173

Pid: 4937, comm: firefox-bin Not tainted 2.6.29-rc1-00224-ga652504 #11
Call Trace:
 [<c025a54b>] xfs_trans_cancel+0xcb/0xf0
 [<c0261173>] xfs_inactive+0x3e3/0x4f0
 [<c0261173>] xfs_inactive+0x3e3/0x4f0
 [<c019113c>] clear_inode+0x5c/0x100
 [<c01917fe>] generic_delete_inode+0xce/0xe0
 [<c0190b24>] iput+0x44/0x50
 [<c01898a0>] do_unlinkat+0xe0/0x160
 [<c0188180>] lock_rename+0x0/0xa0
 [<c01033c5>] sysenter_do_call+0x12/0x25
xfs_force_shutdown(dm-1,0x8) called from line 1165 of file linux-2.6/fs/xfs/xfs_trans.c.  Return address = 0xc025a563
Filesystem "dm-1": Corruption of in-memory data detected.  Shutting down filesystem: dm-1
Please umount the filesystem, and rectify the problem(s)

Regards,
Tino

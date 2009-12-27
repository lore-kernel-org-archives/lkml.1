Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbZL0Viw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbZL0Viw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbZL0Viv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:38:51 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:55693 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbZL0Viu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:38:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=WKYEqOlgD1lRFv+TWpejf5hs+bIFTcYM5fk/SqwMKe9cFo1JPdSjrwOtB+SYEOy6im
         1IxegHYWfzmj0PpiuaoHyF0C3HF6xP6oZ7xNjw9gpYxjv9lGbbk31UXSErN3o1lNuAml
         OPOxAJQdbOr042f10uK+3KpJo/oaFyM1IKkNU=
Date: Sun, 27 Dec 2009 13:38:44 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: 2.6.33-rc1: kernel BUG at fs/ext4/inode.c:1063 (sparc)
Message-ID: <20091227213844.GA16279@core.coreip.homeip.net>
References: <a4423d670912241428n6917d2adsad887548612cf8ce@mail.gmail.com>
 <a4423d670912241449y2da43d5fi3e5a18c114b84178@mail.gmail.com>
 <87hbrfdylc.fsf@openvz.org>
 <a4423d670912251133u795338a4wd32d5cdef8c36c75@mail.gmail.com>
 <87eimir4yk.fsf@openvz.org>
 <a4423d670912271232y5bb928f7wb667ca71f1a93f8a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4423d670912271232y5bb928f7wb667ca71f1a93f8a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 27, 2009 at 11:32:25PM +0300, Alexander Beregalov wrote:
> It seems Dmitry Torokhov has the same issue, Cc'ed.
> 
> 2009/12/26 Dmitry Monakhov <dmonakhov@openvz.org>:
> > Alexander Beregalov <a.beregalov@gmail.com> writes:
> >
> >>>> It seems I can easily reproduce it.
> >>>> But I can't compile 2.6.33-rc2 :)
> > BTW what sha1 of the git-commit you have used to reproduce
> > the bug (2.6.33-rc1 HEAD has no this BUG_ON).
> > This is important to me to know it, or just post the
> > fs/ext4/inode.c file.
> 
> It was in the first post - 2f99f5c
> There is only OCFS update between it and -rc2.
> 
> >>>>
> >>>> scripts/kconfig/conf -s arch/sparc/Kconfig
> >>>>   CHK     include/linux/version.h
> >>>>   CHK     include/generated/utsrelease.h
> >>>>   CALL    scripts/checksyscalls.sh
> >>>>   CHK     include/generated/compile.h
> >>>>   GZIP    kernel/config_data.gz
> >>>>   CC      fs/configfs/inode.o
> >>>>   IKCFG   kernel/config_data.h
> >>>>   LD [M]  fs/btrfs/btrfs.o
> >>>>   CC      kernel/configs.o
> >>>> fs/btrfs/sysfs.o: file not recognized: File truncated
> >>> This happens because of  delayed allocation. Each time BUG or
> >>> unexpected power off happens during object files usually becomes
> >>> broken. IMHO this is expected issue. Just recompile from beginning
> >>> # make clean; make -j4
> >>
> >> It does not help, it still fails.
> > Again strange, please run fsck. What about compile it from very
> > beginning (start from unpacking tar-ball from kernel.org)
> > Or may be compile it on another file-system(ext3 or
> > ext4 with nodelalloc option)
> 
> I tried fsck, it did not find any problem, kernel build still fails after it.
>

Are you using ccache? I do and all the breakage is hidden there (so
"make clean" does not help), just clean you cache and you should be good
to go.

> >> I will try to crosscompile the kernel with Ted's patch on another host.
> 
> Here is output of 2.6.33-rc2 plus Ted's patch
> 
> EXT4-fs (sda1): inode #1387643: mdb_free (1) < mdb_claim (2) BUG
> 
> ------------[ cut here ]------------
> WARNING: at fs/ext4/inode.c:1067 ext4_get_blocks+0x3f0/0x440()
> Modules linked in:
> Call Trace:
>  [0000000000456bb0] warn_slowpath_common+0x50/0xa0
>  [0000000000456c1c] warn_slowpath_null+0x1c/0x40
>  [0000000000545010] ext4_get_blocks+0x3f0/0x440
>  [0000000000545420] mpage_da_map_blocks+0x80/0x800
>  [0000000000546260] mpage_add_bh_to_extent+0x40/0x100
>  [00000000005464cc] __mpage_da_writepage+0x1ac/0x220
>  [00000000004a957c] write_cache_pages+0x19c/0x380
>  [0000000000545e1c] ext4_da_writepages+0x27c/0x680
>  [00000000004a97ec] do_writepages+0x2c/0x60
>  [00000000004f952c] writeback_single_inode+0xcc/0x3c0
>  [00000000004fa438] writeback_inodes_wb+0x338/0x500
>  [00000000004fa748] wb_writeback+0x148/0x220
>  [00000000004fab60] wb_do_writeback+0x240/0x260
>  [00000000004fabec] bdi_writeback_task+0x6c/0xc0
>  [00000000004b6fb0] bdi_start_fn+0x70/0xe0
>  [000000000047036c] kthread+0x6c/0x80
> ---[ end trace 46a56c443941c84d ]---
> 
> >>
> > It is sad, but i still can not reproduce your bug.

It happens to me as soon as a moderate load is put on ext3 fs mounted
with ext4 driver.

> > At this time i've tested following configurations:
> > system   :    2.6.33-rc2, x86 two cores cpu with 2GB of ram
> > block dev: real sata drive, loopdev over tmpfs
> > mkfs     : 4k and 1k blocksize
> > mount    : w/o quota, quota, journaled quota
> > quota    : both ON and OFF states
> > fs-load  : - fsstress with 1,4,16,32 concurrent tasks
> >           - kernel compilation -j4, -j32
> >           - In fact currently my mail-dir is under quota control.
> > Please clarify your use-case:
> > 0) Your system speciffication: cpu_num, mem_size, page_size(i guess 8k)
> >   block device.
> UltraSparc IIe, UP, 2Gb, 8kb, real SCSI disk (sym53c8xx driver)
> > 1) mkfs options
> I do not remember.
> Perhaps dumpe2fs can help
> 
> root@v120 ~ # dumpe2fs -h /dev/sda1
> dumpe2fs 1.41.9 (22-Aug-2009)
> Filesystem volume name:   <none>
> Last mounted on:          /
> Filesystem UUID:          b34f302e-78a3-4f80-bae6-31639456216c
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr resize_inode dir_index
> filetype needs_recovery sparse_super large_file
> Filesystem flags:         signed_directory_hash
> Default mount options:    (none)
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              2113536
> Block count:              8448000
> Reserved block count:     422400
> Free blocks:              6661110
> Free inodes:              1861302
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Reserved GDT blocks:      1021
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         8192
> Inode blocks per group:   512
> Filesystem created:       Tue Nov 10 00:44:17 2009
> Last mount time:          Sun Dec 27 20:05:48 2009
> Last write time:          Sat Dec 26 10:59:00 2009
> Mount count:              3
> Maximum mount count:      21
> Last checked:             Sat Dec 26 06:07:50 2009
> Check interval:           15552000 (6 months)
> Next check after:         Thu Jun 24 07:07:50 2010
> Lifetime writes:          30 GB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               256
> Required extra isize:     28
> Desired extra isize:      28
> Journal inode:            8
> Default directory hash:   half_md4
> Directory Hash Seed:      ae1ec2f1-0f86-4f26-ace5-eb656fd25709
> Journal backup:           inode blocks
> Journal size:             128M
> 
> 
> > 2) mount options
> noatime
> > 3) quota options (if any)
> No
> > 4) your fs load test-case
> Have not tried to find a simpler testcase yet.
> make CROSS_COMPILE="ccache sparc64-unknown-linux-gnu-" -j4 zImage modules
> 
> Hm, perhaps ccache is the real trigger of the problem.
> 
> > 5) How long does it takes you to reproduce the bug.
> Few seconds (~5)

-- 
Dmitry

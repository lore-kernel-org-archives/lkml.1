Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab0CBH47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 02:56:59 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42022 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab0CBH46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 02:56:58 -0500
Date: Tue, 2 Mar 2010 08:56:56 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Oops while booting 2.6.34-rc0 (block pull busted)
Message-ID: <20100302075656.GO5768@kernel.dk>
References: <201003011615.31709.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003011615.31709.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01 2010, Dmitry Torokhov wrote:
> Hi,
> 
> It looks like block tree that has been pulled today into mainline is
> busted, I am getting the Opps below on boot with the following commit:
> 
> commit b1bf9368407ae7e89d8a005bb40beb70a41df539
> Merge: 524df55 4671a13
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Mon Mar 1 09:00:29 2010 -0800
> 
>     Merge branch 'for-2.6.34' of git://git.kernel.dk/linux-2.6-block
>  
> 
> but not with the previous one:
> 
> commit 524df55725217b13d5a232fb5badb5846418ea0e
> Merge: 0f45339 6679ee1
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Mon Mar 1 08:58:44 2010 -0800
> 
>     Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
> 
> This is on plain Fedora 12 VM.
> 
> Thanks.
> 
> -- 
> Dmitry
> 
> sd 2:0:0:0: Attached scsi generic sg1 type 0
> sd 2:0:0:0: [sda] 16777216 512-byte logical blocks: (8.58 GB/8.00 GiB)
> sd 2:0:0:0: [sda] Write Protect is off
> sd 2:0:0:0: [sda] Cache data unavailable
> sd 2:0:0:0: [sda] Assuming drive cache: write through
> sd 2:0:0:0: [sda] Cache data unavailable
> sd 2:0:0:0: [sda] Assuming drive cache: write through
>  sda: sda1 sda2
> sd 2:0:0:0: [sda] Cache data unavailable
> sd 2:0:0:0: [sda] Assuming drive cache: write through
> sd 2:0:0:0: [sda] Attached SCSI disk
> device-mapper: multipath: version 1.1.1 loaded
> dracut: Scanning devices sda2  for LVM volume groups 
> dracut: Reading all physical volumes. This may take a while...
> dracut: Found volume group "VolGroup" using metadata type lvm2
> dracut: 2 logical volume(s) in volume group "VolGroup" now active
> EXT4-fs (dm-0): mounted filesystem with ordered data mode
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffff81128ee1>] mpage_end_io_read+0x45/0x6f
> PGD 3b776067 PUD 3b7b1067 PMD 0 
> Oops: 0002 [#1] SMP 
> last sysfs file: /sys/kernel/uevent_seqnum
> CPU 0 
> Modules linked in: dm_multipath mptspi mptscsih mptbase scsi_transport_spi floppy [last unloaded: scsi_wait_scan]
> 
> Pid: 1, comm: init Not tainted 2.6.33 #4 440BX Desktop Reference Platform/VMware Virtual Platform
> RIP: 0010:[<ffffffff81128ee1>]  [<ffffffff81128ee1>] mpage_end_io_read+0x45/0x6f

Can you check where that is? Just do a gdb vmlinux and then an
l *mpage_end_io_read+0x45

-- 
Jens Axboe


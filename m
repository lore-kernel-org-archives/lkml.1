Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbZAMP40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbZAMP40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZAMP4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:56:16 -0500
Received: from styx.suse.cz ([82.119.242.94]:48918 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752672AbZAMP4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:56:15 -0500
Date: Tue, 13 Jan 2009 16:56:14 +0100
From: Jan Kara <jack@suse.cz>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext2 triggers WARN_ON() when media is unplugged.
Message-ID: <20090113155613.GF10064@duck.suse.cz>
References: <20090113134203.GA4354@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113134203.GA4354@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 13-01-09 14:42:05, Pavel Machek wrote:
> 2.6.29-rc1-git, pretty reproducible: mount -osync, start write
> workload, pull the drive.
  Looking at the warning more in detail, this is actually a known problem.
When IO fails, the buffer_uptodate flag gets cleared. When we then try to
write the buffer again, we call mark_buffer_dirty() and this warning gets
emitted.
  Sadly, fixing this correctly does not seem to be trivial...

									Honza

> ------------[ cut here ]------------
> WARNING: at /data/l/linux/fs/buffer.c:1250 mark_buffer_dirty+0x66/0x80()
> Hardware name: ANT
> Modules linked in:
> Pid: 2970, comm: umount Not tainted 2.6.29-rc1 #263
> Call Trace:
>  [<ffffffff8023da92>] warn_slowpath+0xf2/0x130
>  [<ffffffff80273502>] find_get_pages+0x32/0xd0
>  [<ffffffff8027ac67>] pagevec_lookup+0x17/0x20
>  [<ffffffff8027b378>] truncate_inode_pages_range+0x188/0x360
>  [<ffffffff80297833>] cache_free_debugcheck+0x103/0x230
>  [<ffffffff802bcd56>] mark_buffer_dirty+0x66/0x80
>  [<ffffffff80331249>] ext2_sync_super+0x39/0x60
>  [<ffffffff803320bc>] ext2_put_super+0xdc/0x100
>  [<ffffffff8029dfbb>] generic_shutdown_super+0x6b/0x110
>  [<ffffffff8029e089>] kill_block_super+0x29/0x50
>  [<ffffffff8029e16f>] deactivate_super+0x5f/0x80
>  [<ffffffff802b2746>] sys_umount+0x76/0x380
>  [<ffffffff8022bb72>] ia32_sysret+0x0/0xa
> ---[ end trace 1a98d19d85775109 ]---
> scsi 1:0:0:0: rejecting I/O to dead device
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

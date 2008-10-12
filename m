Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbYJLSSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbYJLSSf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 14:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbYJLSS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 14:18:26 -0400
Received: from kroah.org ([198.145.64.141]:37066 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754020AbYJLSS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 14:18:26 -0400
Date: Sun, 12 Oct 2008 11:17:00 -0700
From: Greg KH <greg@kroah.com>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org, Peter Osterlund <petero2@telia.com>
Subject: Re: pktcdvd -> sysfs warning with 2.6.27
Message-ID: <20081012181700.GA21072@kroah.com>
References: <87vdvyngni.fsf@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vdvyngni.fsf@hades.wkstn.nix>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2008 at 01:26:25PM +0100, Nix wrote:
> At the very end of my startup scripts, I say
> 
> pktsetup cdrw /dev/cdrw
> 
> to get the stuff in /etc/pktcdvd set up right.
> 
> As of 2.6.27 this has started complaining:
> 
> pktcdvd: writer pktcdvd0 mapped to hde
> ------------[ cut here ]------------
> WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x2f/0x3b()
> sysfs: duplicate filename '254:0' can not be created
> Modules linked in:
> Pid: 1306, comm: pktsetup Not tainted 2.6.27-dirty #1
>  [<c011ac1c>] warn_slowpath+0x50/0x71
>  [<c0245c17>] ? ida_get_new_above+0xdc/0x17d
>  [<c0245a8a>] ? idr_get_empty_slot+0x142/0x1f3
>  [<c0245c17>] ? ida_get_new_above+0xdc/0x17d
>  [<c01a1738>] ? sysfs_ilookup_test+0x0/0x16
>  [<c01a1919>] ? sysfs_find_dirent+0x1b/0x2c
>  [<c01a1aba>] sysfs_add_one+0x2f/0x3b
>  [<c01a26f6>] sysfs_do_create_link+0xb1/0x106
>  [<c01a276b>] sysfs_create_link+0xf/0x14
>  [<c02749d2>] device_add+0x134/0x455
>  [<c0274d0a>] device_register+0x17/0x1a
>  [<c0274d8d>] device_create_vargs+0x80/0xa3
>  [<c0274dd0>] device_create+0x20/0x24
>  [<c028208f>] pkt_setup_dev+0x2ed/0x429
>  [<c0282251>] pkt_ctl_ioctl+0x86/0x18c
>  [<c0170c09>] vfs_ioctl+0x55/0x6e
>  [<c0185801>] ? block_truncate_page+0xa9/0x1e0
>  [<c0170e58>] do_vfs_ioctl+0x236/0x249
>  [<c0170e9c>] sys_ioctl+0x31/0x4d
>  [<c0102c8d>] sysenter_do_call+0x12/0x25
>  [<c0185801>] ? block_truncate_page+0xa9/0x1e0
>  =======================
> ---[ end trace 1cdd10ab78ee5bc6 ]---
> 
> For the life of me I can't see where pkt_sysfs_dev_new() is being called
> more than once: indeed, from the trace above GCC has inlined it into
> pkt_setup_dev() as a static function called from only one place...

Perhaps some other kernel code is registering with that same major/minor
number, making it already present in sysfs.  Where does that sysfs file
link to before you load your driver?

thanks,

greg k-h

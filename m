Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbZGHOZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbZGHOZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbZGHOYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:24:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52798 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbZGHOYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:24:53 -0400
Subject: Re: 2.6.31-rc2 -- INFO: inconsistent lock state -- inconsistent 
 {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
From: Eric Paris <eparis@redhat.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       David Brownell <dbrownell@users.sourceforge.net>
In-Reply-To: <adafxd7x25h.fsf@cisco.com>
References: <a44ae5cd0907052122w1733780eh84c37a0b288cbd1d@mail.gmail.com>
	 <adafxd7x25h.fsf@cisco.com>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 10:24:27 -0400
Message-Id: <1247063067.2830.2.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 20:51 -0700, Roland Dreier wrote:
> [ adding Eric Paris cc as this looks to be an inotify issue ]
> 
>  > [ 6627.976224] =================================
>  > [ 6627.976237] [ INFO: inconsistent lock state ]
>  > [ 6627.976247] 2.6.31-rc2 #16
>  > [ 6627.976254] ---------------------------------
>  > [ 6627.976263] inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
>  > [ 6627.976276] khubd/217 [HC0[0]:SC0[0]:HE1:SE1] takes:
>  > [ 6627.976285]  (iprune_mutex){+.+.?.}, at: [<c10ba899>]
>  > invalidate_inodes+0x20/0xe3
>  > [ 6627.976315] {IN-RECLAIM_FS-W} state was registered at:
>  > [ 6627.976324]   [<c10536ab>] __lock_acquire+0x2c9/0xac4
>  > [ 6627.976343]   [<c1053f45>] lock_acquire+0x9f/0xc2
>  > [ 6627.976358]   [<c1308872>] __mutex_lock_common+0x2d/0x323
>  > [ 6627.976376]   [<c1308c00>] mutex_lock_nested+0x2e/0x36
>  > [ 6627.976392]   [<c10ba6ff>] shrink_icache_memory+0x38/0x1b2
>  > [ 6627.976407]   [<c108bfb6>] shrink_slab+0xe2/0x13c
>  > [ 6627.976424]   [<c108c3e1>] kswapd+0x3d1/0x55d
>  > [ 6627.976439]   [<c10449b5>] kthread+0x66/0x6b
>  > [ 6627.976454]   [<c1003fdf>] kernel_thread_helper+0x7/0x10
>  > [ 6627.976472]   [<ffffffff>] 0xffffffff

It could be a real bug.  Reminds me a lot of
http://lkml.org/lkml/2009/4/29/782 but not the same thing since I've
removed all allocation under *notify locks.  I'll try to put something
together this afternoon....

-Eric


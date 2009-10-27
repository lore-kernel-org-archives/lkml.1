Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbZJ0NBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbZJ0NBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbZJ0NBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:01:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:53827 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbZJ0NBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:01:20 -0400
Date: Tue, 27 Oct 2009 14:01:23 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Michael Guntsche <mike@it-loops.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Page alloc problems with 2.6.32-rc kernels
In-Reply-To: <20091027095014.GA22215@gibson.comsick.at>
Message-ID: <alpine.LRH.2.00.0910271400170.25075@twin.jikos.cz>
References: <20091027095014.GA22215@gibson.comsick.at>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009, Michael Guntsche wrote:

> Hello list,
> 
> I noticed that I get page alloc errors on one of my machines.
> It is an old server I use as a fileserver with 512MB RAM. Before
> 2.6.3[12] I did not see this problem at all. 
> This only seems to happens when I use mutt on this machine.
> I know that it means I am running out of memory here, but I am wondering
> why I did not see this before....
> 
> mutt: page allocation failure. order:1, mode:0x20
> Pid: 21746, comm: mutt Not tainted 2.6.32-rc5 #2
> Call Trace:
>  [<c11981ef>] ? printk+0x18/0x21
>  [<c1050945>] __alloc_pages_nodemask+0x417/0x4d8
>  [<c1069edc>] cache_alloc_refill+0x250/0x496
>  [<c106a1c6>] __kmalloc+0xa4/0xa8
>  [<c110ddef>] tty_buffer_request_room+0x88/0x11d
>  [<c110dfb8>] tty_insert_flip_string+0x27/0x93
>  [<c110e8d9>] pty_write+0x24/0x4a
>  [<c110a24f>] n_tty_write+0x163/0x3ab
>  [<c1020960>] ? default_wake_function+0x0/0xd
>  [<c1107f3c>] tty_write+0x129/0x1c2
>  [<c110a0ec>] ? n_tty_write+0x0/0x3ab
>  [<c106cfe0>] vfs_write+0x8e/0x142
>  [<c1107e13>] ? tty_write+0x0/0x1c2
>  [<c106d13d>] sys_write+0x3d/0x6b
>  [<c1002bb5>] syscall_call+0x7/0xb

This is a consequence of more general problem in the allocator, and is 
probably not tty-specific. Please see the thread below

	http://lkml.org/lkml/2009/10/22/128

-- 
Jiri Kosina
SUSE Labs, Novell Inc.


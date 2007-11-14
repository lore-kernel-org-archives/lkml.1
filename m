Return-Path: <linux-kernel-owner+w=401wt.eu-S1760970AbXKNQkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760970AbXKNQkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:40:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760738AbXKNQjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:39:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60296 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760723AbXKNQjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:39:46 -0500
Date: Wed, 14 Nov 2007 08:39:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: 2.6.24-rc2-mm1
Message-Id: <20071114083906.178232cb.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0711141728290.15844@twin.jikos.cz>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0711141728290.15844@twin.jikos.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 17:29:49 +0100 (CET) Jiri Kosina <jikos@jikos.cz> wrote:

> On Tue, 13 Nov 2007, Andrew Morton wrote:
> 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc2/2.6.24-rc2-mm1/
> 
> Doesn't boot here:
> 
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> 00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> Floppy drive(s): fd0 is 1.44M
> floppy0: Floppy io-port 0x03f2 in use
> INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.
> turning off the locking correctness validator.
> 
> Call Trace:
>  [<ffffffff80251f88>] __lock_acquire+0x1b7/0xcd0
>  [<ffffffff80252e8e>] lock_acquire+0x51/0x6c
>  [<ffffffff8035bd62>] kobject_add+0x9b/0x197
>  [<ffffffff80598ce2>] _spin_lock+0x1e/0x27
>  [<ffffffff8035bd62>] kobject_add+0x9b/0x197
>  [<ffffffff802c9a42>] register_disk+0x48/0x209
>  [<ffffffff80355d14>] add_disk+0x34/0x3d
>  [<ffffffff8083cdb4>] rd_init+0x172/0x1e1
>  [<ffffffff8082063a>] kernel_init+0x175/0x2e6
>  [<ffffffff8025194c>] trace_hardirqs_on+0x115/0x139
>  [<ffffffff80598779>] trace_hardirqs_on_thunk+0x35/0x3a
>  [<ffffffff8025194c>] trace_hardirqs_on+0x115/0x139
>  [<ffffffff8020c628>] child_rip+0xa/0x12
>  [<ffffffff8020bd3f>] restore_args+0x0/0x30
>  [<ffffffff808204c5>] kernel_init+0x0/0x2e6
>  [<ffffffff8020c61e>] child_rip+0x0/0x12
> 
> INFO: lockdep is turned off.
> BUG: spinlock lockup on CPU#0, swapper/1, FFFF81001FA2BED0
> 
> Call Trace:
>  [<ffffffff80363632>] _raw_spin_lock+0xd1/0xf8
>  [<ffffffff8035bd62>] kobject_add+0x9b/0x197
>  [<ffffffff8035bd62>] kobject_add+0x9b/0x197
>  [<ffffffff802c9a42>] register_disk+0x48/0x209
>  [<ffffffff80355d14>] add_disk+0x34/0x3d
>  [<ffffffff8083cdb4>] rd_init+0x172/0x1e1
>  [<ffffffff8082063a>] kernel_init+0x175/0x2e6
>  [<ffffffff8025194c>] trace_hardirqs_on+0x115/0x139
>  [<ffffffff80598779>] trace_hardirqs_on_thunk+0x35/0x3a
>  [<ffffffff8025194c>] trace_hardirqs_on+0x115/0x139
>  [<ffffffff8020c628>] child_rip+0xa/0x12
>  [<ffffffff8020bd3f>] restore_args+0x0/0x30
>  [<ffffffff808204c5>] kernel_init+0x0/0x2e6
>  [<ffffffff8020c61e>] child_rip+0x0/0x12
> 
> INFO: lockdep is turned off.
> 

I'd suspect the driver tree.  I think I'll need to do a quick -mm2 without
that tree present.


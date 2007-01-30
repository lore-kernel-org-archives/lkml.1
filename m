Return-Path: <linux-kernel-owner+w=401wt.eu-S965446AbXA3IMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965446AbXA3IMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 03:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965447AbXA3IMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 03:12:24 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47785 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965446AbXA3IMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 03:12:23 -0500
Date: Tue, 30 Jan 2007 00:12:09 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Tomasz Kvarsin" <kvarsin@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.20-rc3-mm1: can not mount root
Message-Id: <20070130001209.b716c14a.akpm@osdl.org>
In-Reply-To: <5157576d0701050620l14fd0a6emdf5793c5214931a8@mail.gmail.com>
References: <5157576d0701050620l14fd0a6emdf5793c5214931a8@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jan 2007 17:20:38 +0300
"Tomasz Kvarsin" <kvarsin@gmail.com> wrote:

> I can not boot machine with 2.6.20-rc3-mm1 and  2.6.20-rc2-mm1.
> I made binary search, patch bellow cause this bug:
> $quilt top
> patches/sched-improve-sched_clock-on-i686.patch
> 
> backtrace which I got by connecting "gdb" to machine:
> 
> _raw_spin_lock (lock=0xc06c0c60) at lib/spinlock_debug.c:108
> 108                     for (i = 0; i < loops; i++) {
> (gdb) bt
> #0  _raw_spin_lock (lock=0xc06c0c60) at lib/spinlock_debug.c:108
> #1  0xc056ac42 in _spin_lock (lock=0xc06c0c60) at kernel/spinlock.c:182
> #2  0xc011c3bb in vprintk (fmt=0xc0649c00 "<0>BUG: spinlock %s on
> CPU#%d, %s/%d\n",
>     args=0xc1167a84 "") at kernel/printk.c:534
> #3  0xc011c6c7 in printk (fmt=0xc0649c00 "<0>BUG: spinlock %s on
> CPU#%d, %s/%d\n")
>     at kernel/printk.c:508
> #4  0xc027be42 in spin_bug (lock=0xc06c0c60, msg=0xc065fc00
> "recursion") at lib/spinlock_debug.c:61
> #5  0xc027c178 in _raw_spin_lock (lock=0xc06c0c60) at lib/spinlock_debug.c:79
> #6  0xc056ac42 in _spin_lock (lock=0xc06c0c60) at kernel/spinlock.c:182
> #7  0xc011c3bb in vprintk (fmt=0xc0626ed0 "<1>BUG: unable to handle
> kernel paging request",
>     args=0xc1167b8c "") at kernel/printk.c:534
> #8  0xc011c6c7 in printk (fmt=0xc0626ed0 "<1>BUG: unable to handle
> kernel paging request")
>     at kernel/printk.c:508
> #9  0xc0116de4 in do_page_fault (regs=0xc1167bcc, error_code=0) at
> arch/i386/mm/fault.c:555
> #10 0xc056b11c in page_fault ()
> #11 0xc0808160 in ?? ()
> #12 0xc0626ed0 in kallsyms_token_index ()
> #13 0xc1167cac in ?? ()
> #14 0x00000001 in ?? ()
> #15 0xc0808163 in printk_buf.19225 ()
> #16 0xc1167c0c in ?? ()
> #17 0x00000000 in ?? ()

Tomasz, is this still happening in 2.6.20-rc6-mm3?

err.  We merged that patch.  So perhaps 2.6.20-rc6 now crashes in the same
manner?


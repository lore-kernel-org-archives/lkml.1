Return-Path: <linux-kernel-owner+w=401wt.eu-S964771AbXA3JEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964771AbXA3JEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 04:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965281AbXA3JEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 04:04:43 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:46900 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964771AbXA3JEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 04:04:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VKcK8oyNzMqSAU1TqO+7qOLlr4tEMdPfQK3P8Ga8AHBuf1NAcskyBaFPg360WNmdVNrqM0WQ8CEkh6vePT5Ap+qhchozCkI06/tetc0CWnNZY/MBwlKUh+HA+nSzYTnFc3KQFp0h31GLGBcP0r1Ndb7xjL9KTxMaTDT5SPEZ0ts=
Message-ID: <5157576d0701300104j7c55c03boca274cbcd7620a3c@mail.gmail.com>
Date: Tue, 30 Jan 2007 12:04:40 +0300
From: "Tomasz Kvarsin" <kvarsin@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>
Subject: Re: [BUG] 2.6.20-rc3-mm1: can not mount root
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20070130001209.b716c14a.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5157576d0701050620l14fd0a6emdf5793c5214931a8@mail.gmail.com>
	 <20070130001209.b716c14a.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/30/07, Andrew Morton <akpm@osdl.org> wrote:
> On Fri, 5 Jan 2007 17:20:38 +0300
> "Tomasz Kvarsin" <kvarsin@gmail.com> wrote:
>
> > I can not boot machine with 2.6.20-rc3-mm1 and  2.6.20-rc2-mm1.
> > I made binary search, patch bellow cause this bug:
> > $quilt top
> > patches/sched-improve-sched_clock-on-i686.patch
> >
> > backtrace which I got by connecting "gdb" to machine:
> >
> > _raw_spin_lock (lock=0xc06c0c60) at lib/spinlock_debug.c:108
> > 108                     for (i = 0; i < loops; i++) {
> > (gdb) bt
> > #0  _raw_spin_lock (lock=0xc06c0c60) at lib/spinlock_debug.c:108
> > #1  0xc056ac42 in _spin_lock (lock=0xc06c0c60) at kernel/spinlock.c:182
> > #2  0xc011c3bb in vprintk (fmt=0xc0649c00 "<0>BUG: spinlock %s on
> > CPU#%d, %s/%d\n",
> >     args=0xc1167a84 "") at kernel/printk.c:534
> > #3  0xc011c6c7 in printk (fmt=0xc0649c00 "<0>BUG: spinlock %s on
> > CPU#%d, %s/%d\n")
> >     at kernel/printk.c:508
> > #4  0xc027be42 in spin_bug (lock=0xc06c0c60, msg=0xc065fc00
> > "recursion") at lib/spinlock_debug.c:61
> > #5  0xc027c178 in _raw_spin_lock (lock=0xc06c0c60) at lib/spinlock_debug.c:79
> > #6  0xc056ac42 in _spin_lock (lock=0xc06c0c60) at kernel/spinlock.c:182
> > #7  0xc011c3bb in vprintk (fmt=0xc0626ed0 "<1>BUG: unable to handle
> > kernel paging request",
> >     args=0xc1167b8c "") at kernel/printk.c:534
> > #8  0xc011c6c7 in printk (fmt=0xc0626ed0 "<1>BUG: unable to handle
> > kernel paging request")
> >     at kernel/printk.c:508
> > #9  0xc0116de4 in do_page_fault (regs=0xc1167bcc, error_code=0) at
> > arch/i386/mm/fault.c:555
> > #10 0xc056b11c in page_fault ()
> > #11 0xc0808160 in ?? ()
> > #12 0xc0626ed0 in kallsyms_token_index ()
> > #13 0xc1167cac in ?? ()
> > #14 0x00000001 in ?? ()
> > #15 0xc0808163 in printk_buf.19225 ()
> > #16 0xc1167c0c in ?? ()
> > #17 0x00000000 in ?? ()
>
> Tomasz, is this still happening in 2.6.20-rc6-mm3?
>

Have no idea, I tryied to test 2.6.20-rc6-mm2, but
build failed, I will try -mm3.

> err.  We merged that patch.  So perhaps 2.6.20-rc6 now crashes in the same
> manner?
>
>

Actually there is solution by Vivek Goyal
>
> -int tsc_disable __cpuinitdata = 0;
> +int tsc_disable = 0;

if you merge his patch also all should be fine.

Return-Path: <linux-kernel-owner+w=401wt.eu-S932638AbXCAG2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbXCAG2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 01:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932702AbXCAG2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 01:28:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51819
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932638AbXCAG2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 01:28:50 -0500
Date: Wed, 28 Feb 2007 22:23:41 -0800 (PST)
Message-Id: <20070228.222341.74751530.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: compudj@google.com, mbligh@google.com, linux-kernel@vger.kernel.org,
       ak@suse.de, paulus@samba.org, tony.luck@intel.com,
       hskinnemoen@atmel.com
Subject: Re: Thread flags modified without set_thread_flag() (non
 atomically)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070228220349.b42bf571.akpm@linux-foundation.org>
References: <45E33EBD.6020603@google.com>
	<20070228220349.b42bf571.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 28 Feb 2007 22:03:49 -0800

> On Mon, 26 Feb 2007 12:10:37 -0800 Mathieu Desnoyers <compudj@google.com> wrote:
> 
> > Other examples :
> > 
> > sparc64/kernel/ptrace.c:                if 
> > ((task_thread_info(child)->flags & _TIF_32BIT) != 0) {
> > sparc64/kernel/process.c:               t->flags ^= (_TIF_ABI_PENDING | 
> > _TIF_32BIT);
> > sparc64/kernel/process.c:                       t->flags &= ~_TIF_PERFCTR;
> > 
> > sparc/kernel/process.c:         current_thread_info()->flags &= 
> > ~_TIF_USEDFPU;
> > sparc/kernel/process.c:         current_thread_info()->flags &= 
> > ~_TIF_USEDFPU;
> > sparc/kernel/process.c:         current_thread_info()->flags &= 
> > ~_TIF_USEDFPU;
> > sparc/kernel/process.c:                 current_thread_info()->flags &= 
> > ~(_TIF_USEDFPU);
> > sparc/kernel/traps.c:   current_thread_info()->flags |= _TIF_USEDFPU;
> > sparc/kernel/traps.c:   task_thread_info(fpt)->flags &= ~_TIF_USEDFPU;
> 
> That all looks rather deliberate.
> 
> > powerpc/kernel/process.c:               t->flags ^= (_TIF_ABI_PENDING | 
> > _TIF_32BIT);
> >
> > ia64/kernel/mca.c:      ti->flags = _TIF_MCA_INIT;
> >
> > avr32/kernel/ptrace.c:          ti->flags |= _TIF_BREAKPOINT;
> 
> No, I don't immediately see anything in the flush_old_exec() code path
> which tells us that nobody else can look up this thread_info (or be holding
> a ref to it) in this context.

Provide the counter example, what other threads of control can modify
relevant flags while a thread is exec()'ing?  It's essentially frozen
outside of these code paths, otherwise we wouldn't be able to make all
of these modifications to the task state.

I think these cases are very safe.

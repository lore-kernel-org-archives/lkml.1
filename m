Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbXCAIRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbXCAIRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 03:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933001AbXCAIRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 03:17:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33668 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932978AbXCAIR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 03:17:26 -0500
Date: Thu, 1 Mar 2007 00:17:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: compudj@google.com, mbligh@google.com, linux-kernel@vger.kernel.org,
       ak@suse.de, paulus@samba.org, tony.luck@intel.com,
       hskinnemoen@atmel.com
Subject: Re: Thread flags modified without set_thread_flag() (non
 atomically)
Message-Id: <20070301001708.900eb5e5.akpm@linux-foundation.org>
In-Reply-To: <20070228.222341.74751530.davem@davemloft.net>
References: <45E33EBD.6020603@google.com>
	<20070228220349.b42bf571.akpm@linux-foundation.org>
	<20070228.222341.74751530.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007 22:23:41 -0800 (PST) David Miller <davem@davemloft.net> wrote:

> > That all looks rather deliberate.
> > 
> > > powerpc/kernel/process.c:               t->flags ^= (_TIF_ABI_PENDING | 
> > > _TIF_32BIT);
> > >
> > > ia64/kernel/mca.c:      ti->flags = _TIF_MCA_INIT;
> > >
> > > avr32/kernel/ptrace.c:          ti->flags |= _TIF_BREAKPOINT;
> > 
> > No, I don't immediately see anything in the flush_old_exec() code path
> > which tells us that nobody else can look up this thread_info (or be holding
> > a ref to it) in this context.
> 
> Provide the counter example, what other threads of control can modify
> relevant flags while a thread is exec()'ing?  It's essentially frozen
> outside of these code paths, otherwise we wouldn't be able to make all
> of these modifications to the task state.

As Mathieu points out, resched_task(), perhaps.  It can be called from interrupt.

Return-Path: <linux-kernel-owner+w=401wt.eu-S933221AbXCAJfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221AbXCAJfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 04:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933222AbXCAJfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 04:35:06 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:59806 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933221AbXCAJfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 04:35:04 -0500
Date: Thu, 1 Mar 2007 10:34:51 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <compudj@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Thread flags modified without set_thread_flag() (non
 atomically)
Message-ID: <20070301103451.2618cc35@dhcp-252-105.norway.atmel.com>
In-Reply-To: <20070228220349.b42bf571.akpm@linux-foundation.org>
References: <45E33EBD.6020603@google.com>
	<20070228220349.b42bf571.akpm@linux-foundation.org>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[trimming cc list since I'm only replying to the avr32 part]

On Wed, 28 Feb 2007 22:03:49 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 26 Feb 2007 12:10:37 -0800 Mathieu Desnoyers <compudj@google.com> wrote:

> > avr32/kernel/ptrace.c:          ti->flags |= _TIF_BREAKPOINT;
> 
> No, I don't immediately see anything in the flush_old_exec() code path
> which tells us that nobody else can look up this thread_info (or be holding
> a ref to it) in this context.
> 
> 
> > avr32/kernel/ptrace.c:                  ti->flags |= TIF_SINGLE_STEP;
> 
> heh.  Haarvard, you got a bug.

Heh, yeah. That would indeed explain some strange gdb behaviour. It
will only trigger when single-stepping into an exception or interrupt
handler so thanks for pointing it out; I would have had a hard time
figuring it out on my own...

I don't think either of those need to be atomic though, since both of
them happen in monitor mode with interrupts disabled.

Haavard

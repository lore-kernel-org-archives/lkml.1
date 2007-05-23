Return-Path: <linux-kernel-owner+w=401wt.eu-S1762012AbXEWGn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762012AbXEWGn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 02:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbXEWGnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 02:43:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57742 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754630AbXEWGnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 02:43:17 -0400
Date: Tue, 22 May 2007 23:43:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Chinner <dgc@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/fork.c:385
Message-Id: <20070522234314.54081817.akpm@linux-foundation.org>
In-Reply-To: <20070523063154.GR85884050@sgi.com>
References: <20070523063154.GR85884050@sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 16:31:54 +1000 David Chinner <dgc@sgi.com> wrote:

> Saw this when running strace -f on a script on 2.6.21 on ia64:
> 
> BUG: sleeping function called from invalid context at kernel/fork.c:385
> in_atomic():1, irqs_disabled():0
> 
> Call Trace:
>  [<a000000100014700>] show_stack+0x80/0xa0
>                                 sp=e00000306e6f7a00 bsp=e00000306e6f0ef8
>  [<a000000100014750>] dump_stack+0x30/0x60
>                                 sp=e00000306e6f7bd0 bsp=e00000306e6f0ee0
>  [<a0000001000acaf0>] __might_sleep+0x1f0/0x260
>                                 sp=e00000306e6f7bd0 bsp=e00000306e6f0eb8
>  [<a0000001000bd2e0>] mmput+0x20/0x220
>                                 sp=e00000306e6f7bd0 bsp=e00000306e6f0e90
>  [<a0000001000321e0>] sys_ptrace+0x460/0x1600
>                                 sp=e00000306e6f7bd0 bsp=e00000306e6f0d80
>  [<a00000010000bc40>] ia64_ret_from_syscall+0x0/0x20
>                                 sp=e00000306e6f7e30 bsp=e00000306e6f0d80
>  [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
>                                 sp=e00000306e6f8000 bsp=e00000306e6f0d80
> BUG: sleeping function called from invalid context at kernel/fork.c:385
> in_atomic():1, irqs_disabled():0
> 
> Call Trace:
>  [<a000000100014700>] show_stack+0x80/0xa0
>                                 sp=e00000306e6f7a00 bsp=e00000306e6f0ef8
>  [<a000000100014750>] dump_stack+0x30/0x60
>                                 sp=e00000306e6f7bd0 bsp=e00000306e6f0ee0
>  [<a0000001000acaf0>] __might_sleep+0x1f0/0x260
>                                 sp=e00000306e6f7bd0 bsp=e00000306e6f0eb8
>  [<a0000001000bd2e0>] mmput+0x20/0x220
>                                 sp=e00000306e6f7bd0 bsp=e00000306e6f0e90
>  [<a0000001000321e0>] sys_ptrace+0x460/0x1600
>                                 sp=e00000306e6f7bd0 bsp=e00000306e6f0d80
>  [<a00000010000bc40>] ia64_ret_from_syscall+0x0/0x20
>                                 sp=e00000306e6f7e30 bsp=e00000306e6f0d80
>  [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
>                                 sp=e00000306e6f8000 bsp=e00000306e6f0d80
> 
> I could reproduce it via 'strace -f sleep 1'
> 

I'd say this is specific to ia64.   Someone would have spotted it on
x86 by now.

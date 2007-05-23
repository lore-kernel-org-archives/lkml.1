Return-Path: <linux-kernel-owner+w=401wt.eu-S1761539AbXEWGcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539AbXEWGcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 02:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756715AbXEWGcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 02:32:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49728 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756285AbXEWGb7 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 02:31:59 -0400
Date: Wed, 23 May 2007 16:31:54 +1000
From: David Chinner <dgc@sgi.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: BUG: sleeping function called from invalid context at kernel/fork.c:385
Message-ID: <20070523063154.GR85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Saw this when running strace -f on a script on 2.6.21 on ia64:

BUG: sleeping function called from invalid context at kernel/fork.c:385
in_atomic():1, irqs_disabled():0

Call Trace:
 [<a000000100014700>] show_stack+0x80/0xa0
                                sp=e00000306e6f7a00 bsp=e00000306e6f0ef8
 [<a000000100014750>] dump_stack+0x30/0x60
                                sp=e00000306e6f7bd0 bsp=e00000306e6f0ee0
 [<a0000001000acaf0>] __might_sleep+0x1f0/0x260
                                sp=e00000306e6f7bd0 bsp=e00000306e6f0eb8
 [<a0000001000bd2e0>] mmput+0x20/0x220
                                sp=e00000306e6f7bd0 bsp=e00000306e6f0e90
 [<a0000001000321e0>] sys_ptrace+0x460/0x1600
                                sp=e00000306e6f7bd0 bsp=e00000306e6f0d80
 [<a00000010000bc40>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000306e6f7e30 bsp=e00000306e6f0d80
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000306e6f8000 bsp=e00000306e6f0d80
BUG: sleeping function called from invalid context at kernel/fork.c:385
in_atomic():1, irqs_disabled():0

Call Trace:
 [<a000000100014700>] show_stack+0x80/0xa0
                                sp=e00000306e6f7a00 bsp=e00000306e6f0ef8
 [<a000000100014750>] dump_stack+0x30/0x60
                                sp=e00000306e6f7bd0 bsp=e00000306e6f0ee0
 [<a0000001000acaf0>] __might_sleep+0x1f0/0x260
                                sp=e00000306e6f7bd0 bsp=e00000306e6f0eb8
 [<a0000001000bd2e0>] mmput+0x20/0x220
                                sp=e00000306e6f7bd0 bsp=e00000306e6f0e90
 [<a0000001000321e0>] sys_ptrace+0x460/0x1600
                                sp=e00000306e6f7bd0 bsp=e00000306e6f0d80
 [<a00000010000bc40>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00000306e6f7e30 bsp=e00000306e6f0d80
 [<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
                                sp=e00000306e6f8000 bsp=e00000306e6f0d80

I could reproduce it via 'strace -f sleep 1'

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

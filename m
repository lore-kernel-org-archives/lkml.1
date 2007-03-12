Return-Path: <linux-kernel-owner+w=401wt.eu-S1030241AbXCLOoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030241AbXCLOoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030220AbXCLOoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:44:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030241AbXCLOoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:44:23 -0400
Message-ID: <45F56730.2050604@redhat.com>
Date: Mon, 12 Mar 2007 10:44:00 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>
Subject: Re: [patch] futex: PI state locking fix
References: <20070312091342.GA27425@elte.hu>
In-Reply-To: <20070312091342.GA27425@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Subject: [patch] futex: PI state locking fix
> From: Ingo Molnar <mingo@elte.hu>
> 
> testing of -rt by IBM uncovered a locking bug in wake_futex_pi(): the PI 
> state needs to be locked before we access it.
> 
> this patch has been tested in -rt. Must-have for v2.6.21.
> 

Does that fix this:

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=224262

[<c043f3d7>] rt_mutex_next_owner+0x2f/0x40
    kernel/rt_mutex_common.c:rt_mutex_top_waiter():74:
        BUG_ON(w->lock != lock);
[<c043ecfc>] do_futex+0x94d/0xbe3
     inlined: futex_unlock_pi()
     inlined: wake_futex_pi()
     kernel/futex.c:wake_futex_pi():569:
        new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
[<c043f0af>] sys_futex+0x11d/0x130
[<c040404b>] syscall_call+0x7/0xb



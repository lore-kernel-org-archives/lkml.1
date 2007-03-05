Return-Path: <linux-kernel-owner+w=401wt.eu-S1030319AbXCENlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030319AbXCENlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030426AbXCENlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:41:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:53478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030319AbXCENlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:41:01 -0500
Date: Mon, 5 Mar 2007 15:40:33 +0100
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <compudj@google.com>,
       "Martin J. Bligh" <mbligh@google.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, "David S. Miller" <davem@davemloft.net>,
       Paul Mackerras <paulus@samba.org>, "Luck, Tony" <tony.luck@intel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: Thread flags modified without set_thread_flag() (non atomically)
Message-ID: <20070305144033.GG22829@bingen.suse.de>
References: <45E33EBD.6020603@google.com> <20070228220349.b42bf571.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228220349.b42bf571.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It does seem risky.  Perhaps it is a micro-optimisation which utilises
> knowledge that this thread_struct cannot be looked up via any path in this
> context.
> 
> Or perhaps it is a bug.  Andi, can you please comment?

On flush_thread nobody else can mess with the thread, so yes it's a micro
optimization.

> 
> > And about this specific flush_thread, I am puzzled about the t->flags ^= 
> > (_TIF_ABI_PENDING | _TIF_IA32); line. The XOR will clearly flip the 
> > _TIF_ABI_PENDING bit to 0, and very likely set _TIF_IA32 to the opposite 
> > of its current value. Why does this change need to be written atomically 
> > (can other threads play with these flags ?) ?
> > 
> 
> Don't know.

iirc it came from DaveM originally. He just likes to write things in 
comp^wclever ways :0) It's just a little shorter.

> No, I don't immediately see anything in the flush_old_exec() code path
> which tells us that nobody else can look up this thread_info (or be holding
> a ref to it) in this context.

Normally the process flags atomicity should only matter with signals;
i don't think you can send a signal to a process being in exec this way.

-Andi

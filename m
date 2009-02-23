Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbZBWAL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbZBWAL1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 19:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbZBWALT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 19:11:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59539 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbZBWALS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 19:11:18 -0500
Date: Mon, 23 Feb 2009 01:29:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/6] ftrace, x86: make kernel text writable only for conversions
Message-ID: <20090223002918.GQ26292@one.firstfloor.org>
References: <20090220011316.379904625@goodmis.org> <20090220011521.003556651@goodmis.org> <87y6vyuzsn.fsf@basil.nowhere.org> <alpine.DEB.2.00.0902221741040.18221@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902221741040.18221@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We are changing over 19000 locations in the kernel. This touches almost 
> all kernel text pages anyway. You want to map a page in and out for over 
> 19000 locations?

Well kernel size / PAGE_SIZE times if you sort locations first and
take a last-hit cache. Or if you want to overoptimize you can
also use 2MB pages when available. Also it can be done much cheaper
than a full flush because it doesn't need to be global over all CPUs
(assuming you disable preempt, which you probably do anyways)
And it can use INVLPG on x86 (or similar directed flushed) 
which is much much cheaper than blowing everything away.

I'm not sure which one would be faster, but I suspect the difference
will not be very large. And not changing the kernel has the 
advantage that there is no window where it is unprotected.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

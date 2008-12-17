Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757304AbYLQByn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYLQByn (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 20:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYLQByd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 20:54:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50296 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYLQByc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 20:54:32 -0500
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@googlemail.com>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Robert Richter <robert.richter@amd.com>,
        Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        perfctr-devel@lists.sourceforge.net
Subject: Re: [patch] Performance Counters for Linux, v4
From: Andi Kleen <andi@firstfloor.org>
References: <20081214212829.GA9435@elte.hu>
	<18758.18810.350923.806445@cargo.ozlabs.ibm.com>
	<1229437341.7025.11.camel@twins>
	<18760.13407.568536.198724@cargo.ozlabs.ibm.com>
Date: Wed, 17 Dec 2008 02:55:10 +0100
In-Reply-To: <18760.13407.568536.198724@cargo.ozlabs.ibm.com> (Paul Mackerras's message of "Wed, 17 Dec 2008 10:06:07 +1100")
Message-ID: <87ljuf1s75.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras <paulus@samba.org> writes:
>
> The perf counter subsystem will, in Ingo's design, naturally try to
> schedule as many counters and groups on as it can.  Given a list of
> counters/groups, it could start with the first and keep on trying to
> add counters or groups while it can, essentially trying all possible
> combinations until it either fills up all the hardware counters or
> exhausts the possible combinations.  If it moves all the
> counters/groups that do fit on up to the head of the list, and then
> rotates them to the back of the list when the timeslice expires, that
> would probably be OK.  In fact the computation about what set of
> counters/groups to put on should be done when adding/removing a
> counter/group and when the timeslice expires, rather than at context
> switch time.  (I'm talking about the list of part-time counters/groups
> here, of course.)

One issue is that PMU counts can cover more than one CPU. One example
for this are the Uncore events on Nehalem (which cover a whole socket)
or when you are in AnyThreads monitoring mode (then you get events
from both SMT siblings in a core)

With that you would need to examine other CPU's state at context switch
time. Probably not a good idea for scalability.

-Andi

-- 
ak@linux.intel.com

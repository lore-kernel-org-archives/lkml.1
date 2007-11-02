Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbXKBQXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbXKBQXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 12:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbXKBQXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 12:23:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbXKBQW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 12:22:59 -0400
Message-ID: <472B4ECE.7010602@redhat.com>
Date: Fri, 02 Nov 2007 12:22:38 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/4] x86: FIFO ticket spinlocks
References: <20071101140146.GA26879@wotan.suse.de> <20071101140320.GC26879@wotan.suse.de>
In-Reply-To: <20071101140320.GC26879@wotan.suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2007 10:03 AM, Nick Piggin wrote:
> Introduce ticket lock spinlocks for x86 which are FIFO. The implementation
> is described in the comments. The straight-line lock/unlock instruction
> sequence is slightly slower than the dec based locks on modern x86 CPUs,
> however the difference is quite small on Core2 and Opteron when working out of
> cache, and becomes almost insignificant even on P4 when the lock misses cache.
> trylock is more significantly slower, but they are relatively rare.
> 
> On an 8 core (2 socket) Opteron, spinlock unfairness is extremely noticable,
> with a userspace test having a difference of up to 2x runtime per thread, and
> some threads are starved or "unfairly" granted the lock up to 1 000 000 (!)
> times. After this patch, all threads appear to finish at exactly the same
> time.

There's also a very easy way to get better fairness with our current spinlocks:
use xchg to release the lock instead of mov.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbZGAMlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbZGAMlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbZGAMkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:40:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58884 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZGAMkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:40:52 -0400
Date: Wed, 1 Jul 2009 14:40:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
Message-ID: <20090701124055.GQ6760@one.firstfloor.org>
References: <20090701.152115.706994265076015808.mitake@dcl.info.waseda.ac.jp> <87hbxwj1k3.fsf@basil.nowhere.org> <20090701.174226.419764642024067218.mitake@dcl.info.waseda.ac.jp> <20090701090749.GA13535@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701090749.GA13535@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> His arguments are bogus: both lockstat and perfcounters are optional 

The patch was for schedstat, not lockstat.

> (and default off), and the sw counter can be made near zero cost 

My understanding was that perfcounters was supposed to 
be enabled on production kernels?

If not it would be fairly useless to most people who
don't recompile their kernels.

> even if both perfcounters and lockstat is enabled. Also, sw counters 
> are generally per CPU, etc. so not a performance issue.

Uncontended spinlock is still a hotpath and adding code
to it will add overhead. 

Without cache line bouncing it might not be fatal, but 
making very fundamental micro operations like that slower
in production kernels doesn't seem like a good idea to me.

It would be especially sad since now in the x86 world we're
getting CPUs with fast LOCK prefix widely deplouyed and wasting
these improvements in Linux specific overhead again wouldn't
seem like the right direction to me.

Especially if it's quite dubious if the information gotten
through this counter is actually useful (or in the few cases
you really need it you can easily get with one of the
dynamic probing solutions)

One potential useful alternative metric I could imagine might
be useful be possible number of spins. I wouldn't have a problem with
that because spinning is already a slower path in the common
case. It might still cost a bit of SMT, but probably not fatal.
Still I suspect you can relatively easily get equivalent information
with a normal cycle profiler.

Benchmark numbers would be still a good idea of course.

> Andi is often trolling perfcounters related (and other) threads, 

It's an interesting insight into your way of thinking that you now 
consistently started to describe code review as trolling.

FYI I generally don't enjoy doing code review but do it anyways because I 
think it's important to do to keep code quality up. Even if it doesn't
seem to be appreciated by people like you.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

Return-Path: <linux-kernel-owner+w=401wt.eu-S2993111AbXDSCUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993111AbXDSCUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 22:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993112AbXDSCUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 22:20:15 -0400
Received: from omta01sl.mx.bigpond.com ([144.140.92.153]:27320 "EHLO
	omta01sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993111AbXDSCUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 22:20:14 -0400
Message-ID: <4626D1D5.4040508@bigpond.net.au>
Date: Thu, 19 Apr 2007 12:20:05 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <462467E9.4030509@bigpond.net.au> <20070417084405.GA13661@elte.hu>
In-Reply-To: <20070417084405.GA13661@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta01sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Thu, 19 Apr 2007 02:20:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Williams <pwil3058@bigpond.net.au> wrote:
> 
>>> And my scheduler for example cuts down the amount of policy code and 
>>> code size significantly.
>> Yours is one of the smaller patches mainly because you perpetuate (or 
>> you did in the last one I looked at) the (horrible to my eyes) dual 
>> array (active/expired) mechanism.  That this idea was bad should have 
>> been apparent to all as soon as the decision was made to excuse some 
>> tasks from being moved from the active array to the expired array.  
>> This essentially meant that there would be circumstances where extreme 
>> unfairness (to the extent of starvation in some cases) -- the very 
>> things that the mechanism was originally designed to ensure (as far as 
>> I can gather).  Right about then in the development of the O(1) 
>> scheduler alternative solutions should have been sought.
> 
> in hindsight i'd agree.

Hindsight's a wonderful place isn't it :-) and, of course, it's where I 
was making my comments from.

> But back then we were clearly not ready for 
> fine-grained accurate statistics + trees (cpus are alot faster at more 
> complex arithmetics today, plus people still believed that low-res can 
> be done well enough),  and taking out any of these two concepts from CFS
> would result in a similarly complex runqueue implementation.

I disagree.  The single priority array with a promotion mechanism that I 
use in the SPA schedulers can do the job of avoiding starvation with no 
measurable increase in the overhead.  Fairness, nice, good interactive 
responsiveness can then be managed by how you determine tasks' dynamic 
priorities.

> Also, the 
> array switch was just thought to be of another piece of 'if the 
> heuristics go wrong, we fall back to an array switch' logic, right in 
> line with the other heuristics. And you have to accept it, mainline's 
> ability to auto-renice make -j jobs (and other CPU hogs) was quite a 
> plus for developers, so it had (and probably still has) quite some 
> inertia.

I agree, it wasn't totally useless especially for the average user.  My 
main problem with it was that the effect of "nice" wasn't consistent or 
predictable enough for reliable resource allocation.

I also agree with the aims of the various heuristics i.e. you have to be 
unfair and give some tasks preferential treatment in order to give the 
users the type of responsiveness that they want.  It's just a shame that 
it got broken in the process but as you say it's easier to see these 
things in hindsight than in the middle of the melee.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce

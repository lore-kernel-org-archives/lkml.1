Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbYDTUCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbYDTUCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 16:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbYDTUCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 16:02:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33425 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbYDTUCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 16:02:46 -0400
Message-ID: <480BA12A.4000307@firstfloor.org>
Date: Sun, 20 Apr 2008 22:01:46 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Daniel Hazelton <dhazelton@enter.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <200804181737.m3IHbabI010051@hera.kernel.org>	<20080420104444.GI1595@cs181133002.pp.htv.fi>	<87y778aezh.fsf@basil.nowhere.org>	<200804201144.33308.dhazelton@enter.net>	<480B7CB2.3080002@firstfloor.org> <20080420114845.77bf3fed@laptopd505.fenrus.org>
In-Reply-To: <20080420114845.77bf3fed@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> These are real customer workloads; java based "many things going on" at a time
> showed several thousands of threads fin the system (a dozen or two per request, multiplied
> by the number of outstanding connections) for *real customers*.

Several thousands or 50k? Several thousands sounds large, but not entirely unreasonable, 
but it is far from 50k.

> That you don't take that serious, fair, you can take serious whatever you want.

No I don't take 50k threads on 32bit serious. And I hope you do not
either.

Why I don't take it serious: on 32bit 50k threads will lead
to lowmem exhaustion if the threads are actually doing something 
(like keeping select pages around or similar and having some thread
local data). You'll easily be at 16-32K/thread and that is already 
far beyond the lowmem available on any 3:1 split 32bit kernel, likely 
even beyond 2:2. Even with 3:1 it could be tight.

So you can say about customer workloads what you want, but you'll
have a hard time convincing me they really run 50k threads 
doing something on 32bit.

Now if we take the real realistic overhead of a thread into 
account 4k or more less don't really matter all that much
and the decreased safety from the 4k stack starts to look
like a very bad bargain.

>> attacked (2) in earlier thread; in particular in
> 
> yes you did attack. 
> But lets please use more friendly conversation here than words like
> "attack". This is not a war, and we really shouldn't be hostile in this forum, neither
> in words nor in intention.

Ok what word would you prefer? 

There is no war involved right, just a technical argument. I previously 
always assumed that "attacking" was a standard term in discussions, but 
if you don't like I can switch to another one. 

Regarding war like terminology: I used to think that people who commonly 
talk about "nuking code" went a little too far, but at some point
I adapted to them I think. Perhaps it comes from that.


> What you didn't atta^Waddress 

Fine, I will call it address from now.

> was the observation that fragmentation is fundamentally unsolvable.

Where was that observation? 

> Yes 2.4 sucked a lot more than 2.6 does. But even 2.6 will (and does) have fragmentation issues.
> We don't have effective physical address based reclaim yet for higher order allocs.

I don't see any evidence that there are serious order 1 fragmentation 
issues on 2.6. If you have any please post it.

-Andi

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYDTXRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYDTXRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 19:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbYDTXRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 19:17:45 -0400
Received: from [88.44.63.5] ([88.44.63.5]:53679 "EHLO smtp-out03.alice-dsl.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753514AbYDTXRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 19:17:44 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
From: Andi Kleen <andi@firstfloor.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	<20080420104444.GI1595@cs181133002.pp.htv.fi>
	<87y778aezh.fsf@basil.nowhere.org>
	<200804201144.33308.dhazelton@enter.net>
	<480B7CB2.3080002@firstfloor.org>
	<20080420114845.77bf3fed@laptopd505.fenrus.org>
	<480BA12A.4000307@firstfloor.org>
	<20080420153318.553e5d2d@laptopd505.fenrus.org>
Date: Mon, 21 Apr 2008 01:16:22 +0200
In-Reply-To: <20080420153318.553e5d2d@laptopd505.fenrus.org> (Arjan van de Ven's message of "Sun, 20 Apr 2008 15:33:18 -0700")
Message-ID: <87prsk86d5.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Apr 2008 23:09:33.0835 (UTC) FILETIME=[9894DDB0:01C8A33B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:
>
> it is you who keeps putting up the 50k argument.

See the links I posted and quote in an earlier message up the thread if you
don't remember what you wrote yourself.

I originally only hold up the fragmentation argument (or rather only
argued against it), until I was corrected by both Ingo and you in the
earlier thread and you both insisted that 50k threads were the real
reason'd'etre for 4k stacks.  

You're saying that was wrong and the fragmentation issue was really the 
real reason for 4k stacks? If both you and Ingo can agree on that
I would be happy to forget the 50k threads :)

> What I'm talking about is in the 10k to 20k range; and that is actual workloads
> by real customers.

On a 32bit kernel? 

My estimate is that you need around 32k for a functional blocked thread
in a network server (8k + 2*4k for poll with large fd table and wait queues + 
some pinned dentries and inodes + misc other stuff). With 20k you're 625MB into
your lowmem which leaves about 200MB left on a 3:1 system with 16GB 
(and ~128MB mem_map).  That might work for some time, but I expect it will fall
over at some point because there is just too much pinned lowmem
and not enough left for other stuff (like networking buffers etc.) 

10k sounds more doable. But again do 4k more or less make 
a big difference with the other thread overhead? I don't think so.

And trading reliability (and functionality -- you basically have to
cut off XFS)just for 4k/thread doesn't seem like good bargain to
me. Especially with kernel code getting more complicated all the time.

>> I don't see any evidence that there are serious order 1 fragmentation 
>> issues on 2.6. 
>
> I assume you're not asking me to give you customer confidential data from a previous job in public ;)

Well if it is that serious a problem surely it will have hit some public
bugzillas or mailing lists?  Arguing with something secret is also not 
very useful.

Also I find it always important to reevaluate assumptions when new 
facts come up. In this case we should reevaluate a decision that made
sense[1] in 2.4 with the new facts of 2.6 (e.g. new VM with much better
reclaim)

[1] refering to the fragmentation argument, not the 50k threads which
were always unrealistic.

-Andi

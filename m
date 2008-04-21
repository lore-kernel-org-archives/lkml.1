Return-Path: <linux-kernel-owner+w=401wt.eu-S1762277AbYDUReq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277AbYDUReq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 13:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYDURei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 13:34:38 -0400
Received: from smtp.enter.net ([216.193.128.24]:4209 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbYDUReh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 13:34:37 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: x86: 4kstacks default
Date: Mon, 21 Apr 2008 13:34:33 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <200804202145.45146.dhazelton@enter.net> <20080421075102.GB14446@one.firstfloor.org>
In-Reply-To: <20080421075102.GB14446@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804211334.33912.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 April 2008 03:51:02 Andi Kleen wrote:
> > Never said it worked on a 32bit system. I was pointing out that there can
> > be workloads that do reach
>
> Ah your point was that people might do this on 64bit systems?

My point was that people might try to make such a system work on a 32bit 
system and fail. The  fact that the limit does exist and changing the stack 
size doesn't really help things is a key there.

My point is that you can get a few more threads out of a machine with 4K 
stacks, even on 32bit. Sure, the difference is basically negligible, but it 
does happen. That extra available space may be the difference between a 
poorly coded program triggering random crashes (and the OOM killer) and the 
system surviving it. 

While it's true that I feel that the job of the kernel isn't to protect the 
incompetent, it should protect the competent admins from the incompetent 
developers (and middle management).

> They could indeed. It would not be very efficient but it should work
> in theory at least with enough memory. Of course they don't need 4k
> stacks for it. They can also try it on 32bit and it will work
> to some extent too, just not scale very far.  And 4k stack more or less
> won't make much difference for that because the stack is only
> a small part of the lowmem needed for a blocked thread with
> open sockets.

True. But having that tiny bit of extra memory might be the difference between 
a crash and a somewhat memory starved but surviving system.

> But this thread clearly was about 32bit systems only.

I didn't say otherwise. I was pointing out that 50K threads isn't out of the 
question when looking at the workload provided (and ignoring all other memory 
concerns.

However, I had hoped I wouldn't have to spell out the stuff I've had to point 
out in this mail.

> > that 50K thread-count that you seem to be
> > calling "stupid".
>
> Note I didn't come up with that number, it was quoted to me earlier
> (but one of its authors has distanced itself from it now, so it
> seems to becoming more and more irrelevant indeed now)

Yes, I know you didn't come up with it. But in seeing the original commit-log 
for it, I'm thinking that the '50K' number was initially meant as either a 
small joke or a dream of a maximum.

> Stupid in this case just refers to the general observation that
> it is quite inefficient to do one thread per request on servers
> who are expected to process lots of long running connections.

Remember, you're talking about people that write the code in Java. It's going 
to spawn all kinds of threads anyway. I, personally, would write the code in 
a language giving me better control over the available resources. However, 
I'm not employed by any major company because I will almost always refuse to 
work on a project if it's being done in an inefficient manner.

> Perhaps I could have put that better I will give you that. Please
> assume I always meant "inefficient" when I wrote "stupid".

In that case I agree. It is very inefficient to do things that way.

> > talking about. If I had been running 4K stacks on that machine I probably
> > would have survived the mis-configuration without the reboot it took to
> > make
>
> Now that is a very doubtful claim. You realize that a functional network
> server thread needs a lot more lowmem than just the stack?

There was nothing else running on the machine and it was reporting lowmem free 
in the logs, just none "usable". Since the two biggest hogs on that box are 
Apache2 and MySQL - and since repairing the Apache2 config damage has halted 
further OOM's on that machine, I'm pretty much certain that it was Apache2 at 
fault, though since there were reports of free lowmem, I'm pretty certain it 
was a combination of fragmentation and Apache2.

DRH


-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbYDUHpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbYDUHpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 03:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbYDUHpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 03:45:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46584 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbYDUHpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 03:45:33 -0400
Date: Mon, 21 Apr 2008 09:51:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080421075102.GB14446@one.firstfloor.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <200804201643.35830.dhazelton@enter.net> <480BB85A.6020508@firstfloor.org> <200804202145.45146.dhazelton@enter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804202145.45146.dhazelton@enter.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Never said it worked on a 32bit system. I was pointing out that there can be 
> workloads that do reach 

Ah your point was that people might do this on 64bit systems? 

They could indeed. It would not be very efficient but it should work
in theory at least with enough memory. Of course they don't need 4k
stacks for it. They can also try it on 32bit and it will work
to some extent too, just not scale very far.  And 4k stack more or less
won't make much difference for that because the stack is only
a small part of the lowmem needed for a blocked thread with
open sockets.

But this thread clearly was about 32bit systems only.

> that 50K thread-count that you seem to be 
> calling "stupid". 

Note I didn't come up with that number, it was quoted to me earlier
(but one of its authors has distanced itself from it now, so it 
seems to becoming more and more irrelevant indeed now) 

Stupid in this case just refers to the general observation that
it is quite inefficient to do one thread per request on servers
who are expected to process lots of long running connections.

Perhaps I could have put that better I will give you that. Please
assume I always meant "inefficient" when I wrote "stupid".

> talking about. If I had been running 4K stacks on that machine I probably 
> would have survived the mis-configuration without the reboot it took to make 

Now that is a very doubtful claim. You realize that a functional network
server thread needs a lot more lowmem than just the stack? 

-Andi


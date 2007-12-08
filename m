Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbXLHW4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbXLHW4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 17:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXLHW42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 17:56:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:2056 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbXLHW41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 17:56:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=bOqzH6SqUbO//SrmyGhLzQ48ZgbX9ZPaagupGXkBBFYLF32jemxoeUSjcLQFf6Lb3LBCvA+QCqPRC7kyIzTNxv1UqXB3MMgM/g4JYtBgZkDIwg2OicVaUjYx21BC8fNC3tiS7ZKFy7U6uV7UxuLJwMVveDGI/pyy+H0gIyBTBoA=
Message-ID: <475B2169.6030709@gmail.com>
Date: Sat, 08 Dec 2007 23:57:45 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Remy Bohmer <linux@bohmer.net>, Daniel Walker <dwalker@mvista.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Dave Chinner <dgc@sgi.com>
Subject: Re: lockdep problem conversion semaphore->mutex (dev->sem)
References: <3efb10970712071502p4db9c58ck623c377172ead4b2@mail.gmail.com>	 <1197116185.31440.1.camel@twins>	 <1197132792.1568.162.camel@jnielson-xp.ddns.mvista.com>	 <1197133910.6353.33.camel@lappy>	 <1197133577.1568.166.camel@jnielson-xp.ddns.mvista.com>	 <1197135413.6353.36.camel@lappy>	 <3efb10970712081152o2d4abcfbo634a8d2445c09699@mail.gmail.com>	 <1197144276.6353.44.camel@lappy>	 <3efb10970712081233q10ac7f6bwb2c0ab8107714c1c@mail.gmail.com> <1197147016.6353.53.camel@lappy>
In-Reply-To: <1197147016.6353.53.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote, On 12/08/2007 09:50 PM:

> On Sat, 2007-12-08 at 21:33 +0100, Remy Bohmer wrote:
> 
>> Which problems? I did not see any special things, it looked rather
>> straight forward. What have I overlooked?
> 
> On suspend it locks the whole device tree, this means it has 'unbounded'
> nesting and holds an 'unbounded' number of locks. Neither things are
> easy to annotate (remember that mutex_lock_nested can handle up to 8
> nestings and current->held_locks has a max of 30).
> 
> In fact, converting this will be the hardest part, it would require
> reworking the locking and introduction of a hard limit on the device
> tree depth - this might upset some people, but I suspect that 16 or 24
> should be deep enough for pretty much anything. Of course, if people
> prove me wrong, I'll have to reconsider. The up-side of the locking
> scheme I'm thinking of will be that locking the whole tree will only
> take 'depth' number of opterations vs the total number of tree elements.

Of course, I don't know the problem enough, and would be glad if somebody
give me a hint, but I wonder why so deep nesting with lockdep's modification
is necessary here? Does buses have parent buses and so on x8? Why isn't
here considered creating of different lockdep classes according to types
of buses and devices "the usual way"? This way seems to be quite easy in
later debugging.

Regards,
Jarek P.

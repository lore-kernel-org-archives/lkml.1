Return-Path: <linux-kernel-owner+w=401wt.eu-S1423042AbXCBLxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423042AbXCBLxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 06:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423045AbXCBLxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 06:53:38 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:47478 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423042AbXCBLxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 06:53:37 -0500
Date: Fri, 2 Mar 2007 14:48:55 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070302114855.GB25908@2ka.mipt.ru>
References: <20070301095402.GA14603@elte.hu> <20070301131118.GA30228@elte.hu> <20070301133018.GB30177@2ka.mipt.ru> <200703011519.20001.dada1@cosmosbay.com> <20070301141637.GA20006@elte.hu> <20070301145454.GB12684@2ka.mipt.ru> <20070301150942.GA26025@elte.hu> <20070301153655.GB8217@2ka.mipt.ru> <20070302105713.GB15576@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070302105713.GB15576@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Fri, 02 Mar 2007 14:49:22 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 11:57:13AM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > > > > [...] The numbers are still highly suspect - and we are already 
> > > > > down from the prior claim of kevent being almost twice as fast 
> > > > > to a 25% difference.
> > > >
> > > > Btw, there were never almost twice perfromance increase - epoll in 
> > > > my tests always showed 4-5 thousands requests per second, kevent - 
> > > > up to 7 thausands.
> > > 
> > > i'm referring to your claim in this mail of yours from 4 days ago 
> > > for example:
> > > 
> > >   http://lkml.org/lkml/2007/2/25/116
> > > 
> > >  "But note, that on my athlon64 3500 test machine kevent is about 7900
> > >   requests per second compared to 4000+ epoll, so expect a challenge."
> > > 
> > > no matter how i look at it, but 7900 is 1.9 times 4000 - which is 
> > > "almost twice".
> > 
> > After your changes epoll increased to 5k.
> 
> Can we please stop this pointless episode of benchmarketing, where every 
> mail of yours shows different results and you even deny having said 
> something which you clearly said just a few days ago? At this point i 
> simply cannot trust the numbers you are posting, nor is the discussion 
> style you are following productive in any way in my opinion.

I just show what I see in tests - I do not perform deep analysis of
that, since I do not see why it should be done - it is not fake, it is
not fantasy - real behaviour which is observed in my test machine, if it
will sudenly change I will report it.
Btw, I showed cases when epoll behaved better than kevent and
performance was unbeatable 9k requests per second - I do not know, why
it happend - maybe some cache related issues, other process all slept in
once, increased radiation or strong wind blew away my bad aura - it is
not reproducible on demand too.

> (you are never ever wrong, and if you are proven wrong on topic A you 
> claim it is an irrelevant topic (without even admitting you were wrong 
> about it) and you point to topic B claiming it's the /real/ topic you 
> talked about all along. And along the way you are slandering other 
> projects like epoll and threadlets, distorting the discussion. This kind 
> of keep-the-ball-moving discussion style is effective in politics but 
> IMO it's a waste of time when developing a kernel.)

Heh - that is why I'm not subscribed to lkml@ - it tooo frequently ends
up with politics :)

What we are talking about - we try to insult each other with something,
that was supposed to be said after some assumption on theoretical mental
exercise? I can only laugh on that :)

Ingo, I never ever tried to show that something is broken - that is
fantasy based on straight words, not on the real intension.

I never said epoll is broken. Absolutely.

I never said threadlet is broken. Absolutely.

I just showed that it is not (in my opinion) right decision to use
threadlets for IO based model instead of event driven - it is not based
on kevent performance (I _never_ stated it as a main factor - kevent was
only an example of event driven model, you were confused it with kevent
AIO, which is different beast), but instead on experience with nptl
threads and linuxthreads, and related rescheduling overhead compared to 
userspace one.

I showed kevent as a possible usage scenario - since it does support own
AIO. And you started to fight against it in every detail, since you
think kevent is not a good idea to handle AIO model - well, it can be
pefectly correct, I showed kevent AIO (please do not think that kevent
and kevent AIO are the same - the latter is just one of the possible
users I implemented, it only uses kevent to deliver completion event to 
userspace) as possible AIO implementation, but not _kevent_ itself.

But somehow we ended with binding to me some words I never said and ideas
I never based my assumptions on... I do not really think you even
remotely wanted to make any somehow personal assumptions on what we had
discussed.

We even concluded, that perfect IO model should use both approaches to
really scale - both threadlets with its on-demand-only rescheduling, and
event driven ring.
You pointed your opinion on kevents - well, I can not agree with it, but
that is your right not to like something.

Let's not continue bad practice of kicking each other just because there
were some problematic roots which noone even remember correctly - let's
do not make a mistake of pointing something personal out of trivial bits
- if you will be in Russia of around any time soon I will happily buy you 
a beer or what you prefer :)

So, let's just draw a line:
kevent was showed to people, and its performance, although flacky, is a
bit faster than epoll. Threadlets bound to any event driven ring do not
show any performance degradation in network driven setup with small
number of reschedulings with all advantages of simpler programming.
So, repeating myself, both models (not kevent and threadlet, but event
driven and thread based) should be used to achieve the maximum
performance.

So, I will draw yet another request for peace and fun and interesting
technical discussion. Peace?

Anyway, that was interesting discussion, thanks a lot for all
participants :)

> Ingo

-- 
	Evgeniy Polyakov

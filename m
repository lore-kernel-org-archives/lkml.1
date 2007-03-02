Return-Path: <linux-kernel-owner+w=401wt.eu-S1161327AbXCBKaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161327AbXCBKaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 05:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161184AbXCBKaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 05:30:13 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60284 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933315AbXCBKaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 05:30:11 -0500
Date: Fri, 2 Mar 2007 11:27:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20070302102714.GB27687@elf.ucw.cz>
References: <20070226195416.GA11188@elte.hu> <20070227102832.GC23170@2ka.mipt.ru> <20070227115221.GJ8154@thunk.org> <20070227121116.GA31597@2ka.mipt.ru> <20070228161413.GA4319@ucw.cz> <20070301081808.GD7217@2ka.mipt.ru> <20070301092634.GB20171@elf.ucw.cz> <20070301094723.GJ7217@2ka.mipt.ru> <20070301101102.GE20171@elf.ucw.cz> <20070301111815.GB15709@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301111815.GB15709@2ka.mipt.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > If you can replace them with something simpler, and no worse than 10%
> > > > slower in worst case, then go ahead. (We actually tried to do that at
> > > > some point, only to realize that efence stresses vm subsystem in very
> > > > unexpected/unfriendly way).
> > > 
> > > Agh, only 10% in the worst case.
> > > I think you can not even imagine what tricks network uses to get at
> > > least aditional 1% out of the box.
> > 
> > Yep? Feel free to rewrite networking to assembly on Eugenix. That
> > should get you 1% improvement. If you reserve few registers to be only
> > used by kernel (not allowed by userspace), you can speedup networking
> > 5%, too. Ouch and you could turn off MMU, that is sure way to get few
> > more percent improvement in your networking case.
> 
> It is not _my_ networking, but taht one you use everyday in every Linux
> box. Notice which tricks are used to remove single byte from
> sk_buff.

Ok, so tricks were worth it in sk_buff case.

> It is called optimization, and if it does us a single plus it must be
> implemented. Not all people have magical fear of new things.

But that does not mean "every optimalization must be
implemented". Only optimalizations that are "worth it" are... 

> > > Using such logic you can just abandon any further development, since it
> > > work as is right now.
> > 
> > Stop trying to pervert my logic.
> 
> Ugh? :)
> I just say in simple words your 'we do not need something if adds 10%,
> but is complex to understand'.

Yes... but that does not mean "stop development". You are still free
to clean up the code _while_ making it faster.

> > If your code is so complex that it is almost impossible to use from
> > userspace, that is good enough reason not to be merged. "But it is 3%
> > faster if..." is not a good-enough argument.
> 
> Is it enough for you?
> 
> epoll           4794.23 req/sec
> kevent          6468.95 req/sec

Maybe. It is not up to me to decide. But "it is faster" is _not_ the
only merge criterium.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

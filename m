Return-Path: <linux-kernel-owner+w=401wt.eu-S933209AbXCAJ1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209AbXCAJ1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 04:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933214AbXCAJ1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 04:27:18 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53227 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933209AbXCAJ1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 04:27:17 -0500
Date: Thu, 1 Mar 2007 10:26:34 +0100
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
Message-ID: <20070301092634.GB20171@elf.ucw.cz>
References: <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226172812.GC22454@2ka.mipt.ru> <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070226195416.GA11188@elte.hu> <20070227102832.GC23170@2ka.mipt.ru> <20070227115221.GJ8154@thunk.org> <20070227121116.GA31597@2ka.mipt.ru> <20070228161413.GA4319@ucw.cz> <20070301081808.GD7217@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301081808.GD7217@2ka.mipt.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I understand that - and I totally agree.
> > > But when more complex, more bug-prone code results in higher performance
> > > - that must be used. We have linked lists and binary trees - the latter
> > 
> > No-o. Kernel is not designed like that.
> > 
> > Often, more complex and slightly faster code exists, and we simply use
> > slower variant, because it is fast enough.
> > 
> > 10% gain in speed is NOT worth major complexity increase.
> 
> Should I create a patch to remove rb-tree implementation?

If you can replace them with something simpler, and no worse than 10%
slower in worst case, then go ahead. (We actually tried to do that at
some point, only to realize that efence stresses vm subsystem in very
unexpected/unfriendly way).

> That practice is stupid IMO.

Too bad. Now you can start Linux fork called Eugenix.

(But really, Linux is not "maximum performance at any cost". Linux is
"how fast can we get that while keeping it maintainable?").

That is why, while arguing syslets vs. kevents, you need need to argue
not "kevents are faster because they avoid context switch overhead",
but "kevents are _so much_ faster that it is worth the added
complexity". And Ingo seems to showing you they are not _so much_
faster.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

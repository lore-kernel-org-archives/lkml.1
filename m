Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbZAFCvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbZAFCvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbZAFCvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:51:32 -0500
Received: from vps1.tull.net ([66.180.172.116]:47857 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751870AbZAFCvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:51:31 -0500
Date: Tue, 6 Jan 2009 13:51:25 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: David Newall <davidn@davidnewall.com>
Cc: Linas Vepstas <linasvepstas@gmail.com>, david@lang.hm,
       Kyle Moffett <kyle@moffetthome.net>,
       Ben Goodger <goodgerster@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years	2008-2009
Message-ID: <20090106025125.GB28431@mail.local.tull.net>
References: <496076A9.7030907@davidnewall.com> <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com> <4960897D.5030603@davidnewall.com> <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm> <4961432A.80509@davidnewall.com> <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm> <49614835.7000505@davidnewall.com> <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com> <20090105143335.GC18055@mail.local.tull.net> <4962BB13.7060304@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4962BB13.7060304@davidnewall.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 12:29:47PM +1030, David Newall wrote:
> Nick Andrew wrote:
> > I can sympathise with the opinion that linux should be able to accurately
> > distinguish xx:59:60 when a leap second is added (or the missing :59 when
> > one is subtracted) but not at the expense of making a day which is not
> > 86400 seconds long.
> >   
> 
> Some days are not 86400 seconds long.  That's a fact and regardless of
> how inconvenient it is, we have to live with it.

Sorry, but you're wrong - in the context of time_t, every day is 86400
seconds long. man 2 time says so clearly in the notes:

NOTES
       POSIX.1 defines seconds since the Epoch as a value to be interpreted as the number of sec‐
       onds between a specified time and the Epoch, according to a formula  for  conversion  from
       UTC  equivalent  to  conversion  on  the naive basis that leap seconds are ignored and all
       years divisible by 4 are leap years.  This value is not the same as the actual  number  of
       seconds between the time and the Epoch, because of leap seconds and because clocks are not
       required to be synchronized to a standard reference.

> Some years don't have
> 365 days; some months don't have 30 days; some Februaries don' have 28
> days; and now, some days don't have 86400 seconds. What's the point in
> fighting this?

I'm not fighting this - the real world has all these issues but the
world of time_t does not. You want to redefine time_t to include all
the leap seconds that were already added (34) or perhaps only the
future ones; either approach is a disaster. It's unreasonable to change
the semantics of something as fundamental as time_t when so much code
depends on those semantics.

Instead, define a new timebase which counts time predictably and
unambiguously then a set of mappings to derived time values like
time_t, UTC and local time.

> > Just so long as the
> > existing behaviour of time() which doesn't recognise leap seconds
> > is preserved.
> 
> I haven't been able to find this Annex B that Alan talked of, so I can
> only go by the man page, which states, simply and explicitly, that
> time() returns seconds since Epoch, and also that Epoch is start of
> January 1 1970.  To my mind, time *does* recognise leap seconds.

Please read the NOTES section, which clarifies what "seconds since
the Epoch" means.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7

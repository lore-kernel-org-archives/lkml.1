Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbZLFUIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbZLFUIl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757225AbZLFUIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:08:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44735 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224AbZLFUIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:08:38 -0500
Date: Sun, 6 Dec 2009 21:08:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>, stable@kernel.org
Subject: Re: aim7 scalability issue on 4 socket machine
Message-ID: <20091206200833.GA2357@elf.ucw.cz>
References: <1253179879.2606.37.camel@ymzhang>
 <1253180411.8497.1.camel@twins>
 <Pine.LNX.4.64.0909171122180.25864@sister.anvils>
 <1253239339.2606.40.camel@ymzhang>
 <20090917195909.3a00ef83.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0909180742500.14561@sister.anvils>
 <20090918000542.268934e1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090918000542.268934e1.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-09-18 00:05:42, Andrew Morton wrote:
> On Fri, 18 Sep 2009 07:53:58 +0100 (BST) Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> 
> > On Thu, 17 Sep 2009, Andrew Morton wrote:
> > > On Fri, 18 Sep 2009 10:02:19 +0800 "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:
> > > > > 
> > > > > So, Yanmin, please retest with http://lkml.org/lkml/2009/9/13/25
> > > > > and let us know if that works as well for you - thanks.
> > > > I tested Lee's patch and it does fix the issue.
> > 
> > Thanks for checking and reporting back, Yanmin.
> > 
> > > 
> > > Do we think we should cook up something for -stable?
> > 
> > Gosh, I laughed at Lee (sorry!) for suggesting it for -stable:
> > is stable really for getting a better number out of a benchmark?
> > 
> > I'd have thought the next release is the right place for that; but
> > I've no problem if you guys and the stable guys agree it's appropriate.
> > 
> > > 
> > > Either this is a regression or the workload is particularly obscure. 
> > 
> > I've not cross-checked descriptions, but assume Lee was actually
> > testing on exactly the same kind of upcoming Nehalem as Yanmin, and
> > that machine happens to have characteristics which show up badly here.
> > 
> > > 
> > > aim7 is sufficiently non-obscure to make me wonder what's happened here?
> > 
> > Not a regression, just the onward march of new hardware, I think.
> > Could easily be other such things in other places with other tests.
> > 
> 
> Well, it comes down to the question "what is -stable for".
> 
> If you take it as "bugfixed version of the 2.6.x kernel" then no,
> speedups aren't appropriate.
> 
> If you consider -stable to be "something distros, etc will use" then
> yes, perhaps we serve those consumers better by including fairly major
> efficiency improvements.

Well, if speedups are ok, then someone should update stable_rules
file...?

...because I do not think it should be accepted based on that.

								Pavel
It currently says:
-------------------


Rules on what kind of patches are accepted, and which ones are not,
into the
"-stable" tree:

 - It must be obviously correct and tested.
 - It cannot be bigger than 100 lines, with context.
 - It must fix only one thing.
 - It must fix a real bug that bothers people (not a, "This could be a
   problem..." type thing).
 - It must fix a problem that causes a build error (but not for things
   marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
   security issue, or some "oh, that's not good" issue.  In short,
something
   critical.
 - New device IDs and quirks are also accepted.
 - No "theoretical race condition" issues, unless an explanation of
how the
   race can be exploited is also provided.
 - It cannot contain any "trivial" fixes in it (spelling changes,
   whitespace cleanups, etc).
 - It must follow the Documentation/SubmittingPatches rules.
 - It or an equivalent fix must already exist in Linus' tree.  Quote
the
   respective commit ID in Linus' tree in your patch submission to
-stable.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

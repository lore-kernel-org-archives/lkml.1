Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbZHKUa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbZHKUa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 16:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbZHKUa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 16:30:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34067 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbZHKUa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 16:30:57 -0400
Date: Mon, 10 Aug 2009 18:10:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>, manfred@colorfullife.com
Subject: Re: [BUG] race of RCU vs NOHU
Message-ID: <20090810161007.GB1505@ucw.cz>
References: <20090807151529.2806b8b4@skybase> <20090807142957.GB6700@linux.vnet.ibm.com> <20090810142535.3e685109@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810142535.3e685109@skybase>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I analysed a dump of a hanging 2.6.30 system and found what I think is
> > > a bug of RCU vs NOHZ. There are a number of patches ontop of that
> > > kernel but they should be independent of the bug.
> > > 
> > > The systems has 4 cpus and uses classic RCU. cpus #0, #2 and #3 woke up
> > > recently, cpu #1 has been sleeping for 5 minutes, but there is a pending
> > > rcu batch. The timer wheel for cpu #1 is empty, it will continue to
> > > sleep for NEXT_TIMER_MAX_DELTA ticks.
> > 
> > Congratulations, Martin!  You have exercised what to date has been a
> > theoretical bug identified last year by Manfred Spraul.  The fix is to
> > switch from CONFIG_RCU_CLASSIC to CONFIG_RCU_TREE, which was added in
> > 2.6.29.
> > 
> > Of course, if you need to work with an old kernel version, you might
> > still need a patch, perhaps for the various -stable versions.  If so,
> > please let me know -- otherwise, I will focus forward on CONFIG_RCU_TREE
> > rather than backwards on CONFIG_RCU_CLASSIC.
> 
> SLES11 is 2.6.27 and uses classic RCU. The not-so theoretical bug is
> present there and I think it needs to be fixed :-/

Plus... if config_rcu_classic is known buggy  (and you are not willing
to fix it),  it should be disabled (or made depend on !CONFIG_NOHZ, or
maybe made depend on CONFIG_BROKEN).

Ugh. rcu_classic  does not seem to have help text, and I'm running
								known
								bad
								code
								here
								:-(.


								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

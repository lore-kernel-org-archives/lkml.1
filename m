Return-Path: <linux-kernel-owner+w=401wt.eu-S1764762AbZAQQZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764762AbZAQQZw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZAQQZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:25:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49860 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108AbZAQQZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:25:41 -0500
Date: Sat, 17 Jan 2009 17:25:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Avi Kivity <avi@redhat.com>, Kevin Shanahan <kmshanah@ucwb.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] scheduler fixes
Message-ID: <20090117162519.GD10825@elte.hu>
References: <1232173776.7073.21.camel@marge.simson.net> <1232186054.6813.48.camel@marge.simson.net> <1232186877.14073.59.camel@laptop> <1232188484.6813.85.camel@marge.simson.net> <1232193617.14073.67.camel@laptop> <1232194752.6273.5.camel@marge.simson.net> <20090117044316.bda7d0bd.akpm@linux-foundation.org> <1232198574.16303.8.camel@marge.simson.net> <20090117160115.GA31601@elte.hu> <1232209281.5987.4.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232209281.5987.4.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Sat, 2009-01-17 at 17:01 +0100, Ingo Molnar wrote:
> > * Mike Galbraith <efault@gmx.de> wrote:
> > 
> > > On Sat, 2009-01-17 at 04:43 -0800, Andrew Morton wrote:
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=12465 just popped up - another
> > > > scheduler regression.  It has been bisected.
> > > 
> > > Seems pretty clear.  I'd suggest reverting it.
> > 
> > We can revert it (and will revert it if no solution is found), but i'd 
> > also like to understand why it happens, because that kind of 
> > regression from this change is unexpected - we might be hiding some 
> > bug that could pop up under less debuggable circumstances, so we need 
> > to understand it while we have a chance.
> 
> Agree.  However, with the sched_mc stuff, mysql+oltp now does better 
> with NEWIDLE on than off as well, as does an nfs kbuild.

Didnt you come up with the verdict that sched_mc=2 is not a win - or has 
that changed? If we should change the defaults then please send a 
re-tuning patch against the latest code.

Still, the ping delays of multiple seconds are completely unacceptable and 
need to be understood, or these will come back and might bite us in a lot 
less fortunate place. NEWIDLE and WAKE_BALANCE has micro-effects on 
latencies - anything in the user-visible range is highly anomalous at 
these low load levels.

	Ingo

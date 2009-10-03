Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbZJCOuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbZJCOuA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 10:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZJCOt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 10:49:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52919 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbZJCOt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 10:49:58 -0400
Date: Sat, 3 Oct 2009 16:49:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: drago01 <drago01@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       kernel list <linux-kernel@vger.kernel.org>, mingo@redhat.com,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: sched regression introduced by NO_NEW_FAIR_SLEEPERS
Message-ID: <20091003144957.GA27943@elte.hu>
References: <f6ca9fed0909271247k7fad64b1g1c4c65544196d7ac@mail.gmail.com> <f6ca9fed0909271250h61e2ce94n31c9f23e835f802c@mail.gmail.com> <20091003104723.GC15919@elte.hu> <f6ca9fed0910030623m3cde192br7e1a3256b3cf7838@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f6ca9fed0910030623m3cde192br7e1a3256b3cf7838@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* drago01 <drago01@gmail.com> wrote:

> On Sat, Oct 3, 2009 at 12:47 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * drago01 <drago01@gmail.com> wrote:
> >
> >> On Sun, Sep 27, 2009 at 9:47 PM, drago01 <drago01@gmail.com> wrote:
> >> > Hi,
> >> >
> >> > Chuck has backported some scheduler patches from 2.6.32 to the fedora kernel.
> >> >
> >> > I did the following test to test the new scheduler (cpu is a core i7
> >> > 920 4 cores + HT).
> >> >
> >> > run 8 "md5sum /dev/urandom" task and try to use the desktop (compiz).
> >> >
> >> > The result was that moving windows or rotating the cube is very slow.
> >> > (same happens with pure metacity but is is worse in compiz).
> >> >
> >> > Mounting debugfs and doing "echo NEW_FAIR_SLEEPERS > sched_features"
> >> > results into a useable desktop while the 8 md5sum tasks are running
> >> > (ie. the system behaves as if they where not running at all from an
> >> > interactivity pov).
> >> >
> >> >
> >> > P.S: please CC me when replying.
> >> >
> >>
> >> With "NEW_FAIR_SLEEPERS" I can even run 100(!)  "md5sum" task without
> >> any effect on interactivity. (still have not found a number of tasks
> >> needed to make the system unresponsive as with 8 with
> >> "NO_NEW_FAIR_SLEEPERS".
> >
> > Can you try the latest -tip tree please:
> >
> >  http://people.redhat.com/mingo/tip.git/README
> >
> > There we default to FAIR_SLEEPERS + GENTLE_FAIR_SLEEPERS - which should
> > give much of the new-fair-sleepers advantage.
> 
> OK, with this kernel it works fine (can spam the system with md5sum 
> tasks and the desktop is still responsive).
>
> Was able to use the system with 129 "md5sum /dev/urandom" running.

ok, great!

Those changes are in Linus's latest tree as well.

	Ingo

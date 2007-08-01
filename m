Return-Path: <linux-kernel-owner+w=401wt.eu-S1763574AbXHAOhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763574AbXHAOhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763874AbXHAOgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:36:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44534 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763093AbXHAOgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:36:44 -0400
Date: Wed, 1 Aug 2007 16:36:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070801143624.GA18043@elte.hu>
References: <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random> <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home> <p73wswfo0hf.fsf@bingen.suse.de> <Pine.LNX.4.64.0708011525560.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708011525560.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> > jiffies based sched_clock should be soon very rare. It's probably 
> > not worth optimizing for it.
> 
> I'm not so sure about that. sched_clock() has to be fast, so many 
> archs may want to continue to use jiffies. [...]

i think Andi was talking about the vast majority of the systems out 
there. For example, check out the arch demography of current Fedora 
installs (according to the Smolt opt-in UUID based user metrics):

   http://smolt.fedoraproject.org/

   i686:     74743
   x86_64:   18599
   i386:      1208
   ppc:        527
   ppc64:      396
   sparc64:     14
   ---------------
   Total:    95488

even pure i386 (kernels, not systems) is a only 1.2% of all installs. By 
the time the CFS kernel gets into a distro (a few months at minimum, 
typically a year) this percentage will go down further. And embedded 
doesnt really care about task-statistics corner cases [ (it likely 
doesnt have 'top' installed - likely doesnt even have /proc mounted or 
even built in ;-) ].

of course CFS should not do _worse_ stats than what we had before, and 
should not break or massively misbehave. Also, anything sane we can do 
for low-resolution arches we should do (and we already do quite a bit - 
the while wmult stuff is to avoid expensive divisions) - and i regularly 
booted CFS with a low-resolution clock to make sure it works. So i'm not 
trying to duck anything, we've just got to keep our design priorities 
right :-)

	Ingo

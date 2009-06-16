Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbZFPJHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbZFPJHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbZFPJHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:07:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44648 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbZFPJHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:07:12 -0400
Date: Tue, 16 Jun 2009 11:06:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [GIT pull] ntp updates for 2.6.31
Message-ID: <20090616090647.GD13771@elte.hu>
References: <alpine.LFD.2.00.0906151452000.2800@localhost.localdomain> <1f1b08da0906151316s7d25f8ceraa1bc967a8abe172@mail.gmail.com> <1f1b08da0906151641u4cd964e6vf1a61afe50cc1d90@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f1b08da0906151641u4cd964e6vf1a61afe50cc1d90@mail.gmail.com>
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


* john stultz <johnstul@us.ibm.com> wrote:

> Linus,
>     You probably didn't see this before merging.  Could you yank the
> above two patches?  Miroslav (RH package maintainer for ntpd), has
> voiced concerns that the SHIFT_PLL patch breaks the NTP design and is
> worried it may negatively effect NTP networks of systems running with
> different SHIFT_PLL values.
> 
> While the patch does greatly improve NTP convergence times, and so 
> far no negative results have been seen in tests, its out of an 
> abundance of caution and a desire to keep the adjtimex behavior 
> stable that I requested Thomas and Ingo to hold off on merging 
> this patch, while I work with Miroslav to see if we cannot get the 
> same benefit by adjusting the userspace NTPd.

As i explained it in previous threads i disagree. The only 
technically correct direction is to improve NTP stabilization and 
convergence times as much as possible. [*]

( [*] Without getting into over-compensation and without starting to
      oscillate instead of converging - that would be a bug, but 
      such a bug has not been reported so far. )

The 'concern' voiced was that: "what if other OSs converge slower in 
a cluster and now we have a faster OS in the mix". This absolutely 
ignores the other 99% of cases where people would have crappier 
convergence after the revert and for no good reason.

And even regarding that 1% example, well, duh: different OSes have 
different convergence times, fundamentally so - such as Linux had a 
very slow convergence time from about 2.6.18 up to recent kernels 
due to a bug. Now it's converging even faster ...

So i dont think that "Linux is too good" is a good basis to 
artificially make Linux's NTP code crappier. Really. We dont 'play 
nice' by being equally crappy.

Each OS should converge back to the correct time _as fast as 
physically possible_. If this is a problem and if someone wants 
crappy time and longer periods of convergence for some odd reason 
then that header file change can be edited by hand even. It's not 
like it's that hard to change, if there's genuine interest.

So i'm against any revert on this basis. If another basis comes up 
we can reconsider of course. What do you think?

	Ingo


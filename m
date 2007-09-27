Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbXI0Ifw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbXI0Ifw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 04:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXI0Ifn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 04:35:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54800 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbXI0Ifl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 04:35:41 -0400
Date: Thu, 27 Sep 2007 10:35:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Antoine Martin <antoine@nagafix.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: CFS: new java yield graphs
Message-ID: <20070927083506.GA21412@elte.hu>
References: <20070914153216.GA27213@elte.hu> <46F00417.7080301@redhat.com> <20070918224656.GA26719@elte.hu> <46F058EE.1080408@redhat.com> <20070919191837.GA19500@elte.hu> <alpine.LFD.0.999.0709191230230.16478@woody.linux-foundation.org> <20070919195633.GA23595@elte.hu> <alpine.LFD.0.999.0709191306530.16478@woody.linux-foundation.org> <20070919214105.GA12245@elte.hu> <46F9B9FF.1020508@nagafix.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F9B9FF.1020508@nagafix.co.uk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Antoine Martin <antoine@nagafix.co.uk> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> These are pure cpu scheduling tests, not doing any I/O this time. All 
> these tests are still "pathological" in the sense that they are only 
> meant to show differences between schedulers rather than try to 
> simulate real usage scenarios.

thanks for testing this!

> all the graphs are here:
> http://devloop.org.uk/lkml/

wow - really nice graphs!

> Legend:
> * 2.6.23-rc6-yield2: "yield2" patch is this one:
> http://lkml.org/lkml/2007/9/14/157
> * 2.6.23-rc6-yield2-highlatency is the same patch, but the kernel is
> built without preempt, with HZ100 and the scheduling granularity is
> doubled using sysctl.
> * 2.6.23-rc6-yield3 is CFS-v21 combo3 + the yield patch
> * 2.6.23-rc6-yield4 is this patch (queued for mainline? and in mm?):
> http://lkml.org/lkml/2007/9/19/409

wrt. yield4 did you set /proc/sys/kernel/sched_compat_yield to 1? 
(with sched_compat_yield at 0, which is the default, nothing 
changes)

which one would be your favorite kernel? To me yield4 looks pretty good.

> of interest I found:
> * rc6-mm1 is not always fair (see "ManyThreadsYieldOften" tests) - the
> only one to have almost half the threads already finished at the half
> way point when yielding often. Also slower for the "RandomSleep".
> * increasing latency makes a noticeable difference (see "ShortPause")
> it can be more fair, but it also makes it a lot more erratic (see
> "Yield" tests)
> * most changes are only noticeable with a large number for threads (look
> for 'ManyThreads' in the filename)

i'm wondering, how easy would it be for you to test the sched-devel.git 
tree? If you havent used git before then first install the 'git' 
package, then do:

  git-clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6.git
  cd linux-2.6.git
  git-pull git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git

> PS: now testing -rc8, also added a test that consumes memory in each 
> thread. also now recording context switches and idle time.

ok.

	Ingo

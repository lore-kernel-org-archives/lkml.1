Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbYIPIkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbYIPIkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 04:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYIPIkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 04:40:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46322 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbYIPIkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 04:40:19 -0400
Date: Tue, 16 Sep 2008 10:39:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frank Mayhar <fmayhar@google.com>
Cc: Roland McGrath <roland@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 2.6.27-rc5 resubmit] Fix itimer/many thread hang.
Message-ID: <20080916083915.GB17287@elte.hu>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com> <20080914151404.GA28850@elte.hu> <20080914193140.728F56409D@pipsqueak.localdomain> <20080915064106.GB15680@elte.hu> <1221501582.19012.30.camel@bobble.smo.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221501582.19012.30.camel@bobble.smo.corp.google.com>
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


* Frank Mayhar <fmayhar@google.com> wrote:

> On Mon, 2008-09-15 at 08:41 +0200, Ingo Molnar wrote:
> > * Roland McGrath <roland@redhat.com> wrote:
> > 
> > > > please uninline these functions.
> > > 
> > > They are short and have only one caller.
> > 
> > then they should be defined in the .c file which uses them.
> 
> Well, they are actually used in sched.h, in the inline routines 
> account_group_user_time() and friends, which are in turn used by 
> routines in sched.c.  The point here is that the 
> thread_group_cputime_account_xxx() routines are defined differently 
> depending upon whether we're building for UP or SMP and the 
> account_group_xxx() routines use the appropriate version accordingly.
> 
> > really, sched.h is large enough already and has lots of unnecessary 
> > stuff in it.
> 
> Agreed, but Roland and I were trying to make life easier for folks who 
> have to maintain SMP and UP versions of this stuff, keeping it all in 
> one place rather than scattering it about.
> 
> If you insist, I'll un-inline the routines but this will mean moving 
> all of this (thread_group_cputime_account_xxx() and 
> account_group_xxx() routines) to sched.c.  Maybe that makes sense.  
> It's your call; I'll hold off on the changes (and resubmitting the 
> patch) while I wait for you to let me know what you prefer.  Thanks.

it's already in tip/sched/posix-cpu-timers, so please send a delta patch 
against tip/master:

  http://people.redhat.com/mingo/tip.git/README

i'd suggest to move all the scheduler-internal accounting functions into 
kernel/sched_stats.h. AFAICS there's no scheduler-external user of these 
APIs. The most widely used external APIs is thread_group_cputime_smp(), 
and that is out of line already. (except on UP where it's trivial)

	Ingo

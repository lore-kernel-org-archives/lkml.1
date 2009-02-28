Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbZB1NpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbZB1NpB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 08:45:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZB1Now
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 08:44:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47734 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbZB1Now (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 08:44:52 -0500
Date: Sat, 28 Feb 2009 14:44:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [git-pull -tip] x86: Basic AMD Support for performance counters
Message-ID: <20090228134434.GA32473@elte.hu>
References: <1235756278.3914.9.camel@localhost.localdomain> <20090228094018.GF12095@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228094018.GF12095@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > Hello Ingo,
> > 
> > These patches added basic AMD (K7 and later) support for performance counters:
> > 
> > [jaswinder@hpdv5 linux-2.6-tip]$ perfstat -e 0,1,2,3,4,5,-1,-2,-3,-4,-5 ls -lR > /dev/null
> > 
> >  Performance counter stats for 'ls':
> > 
> >     2723.203821  task clock ticks     (msecs)
> > 
> >      1812527794  CPU cycles           (events)
> >      1121688997  instructions         (events)
> >       569836744  cache references     (events)
> >        15934598  cache misses         (events)
> >        57313261  branches             (events)
> >         4243201  branch misses        (events)
> >     2639.682866  cpu clock ticks      (msecs)
> >     2723.203821  task clock ticks     (msecs)
> >             647  pagefaults           (events)
> >            2401  context switches     (events)
> >               3  CPU migrations       (events)
> > 
> >  Wall-clock time elapsed:  6813.030975 msecs
> 
> Very nice feature!
> 
> The AMD patches look much cleaner than i feared they would be. 
> It seems you were able to keep pretty generic x86 code in 
> arch/x86/kernel/cpu/perf_counters.c, sharing most of the logic 
> between Intel and AMD perfcounters.

Seems to be working fine, here's the output from an Athlon 64 
3200+ (Sempron) box:

 Performance counter stats for 'ls':

      17.420811  task clock ticks     (msecs)

              0  CPU migrations       (events)
             12  context switches     (events)
            583  pagefaults           (events)
       29760299  CPU cycles           (events)
       29401642  instructions         (events)
       12698498  cache references     (events)
          66269  cache misses         (events)

 Wall-clock time elapsed:   687.999988 msecs

	Ingo

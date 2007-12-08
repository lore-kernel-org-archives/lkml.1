Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbXLHTRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbXLHTRd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 14:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbXLHTR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 14:17:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34531 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbXLHTRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 14:17:25 -0500
Date: Sat, 8 Dec 2007 20:16:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stefano Brivio <stefano.brivio@polimi.it>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] x86: scale cyc_2_nsec according to CPU frequency
Message-ID: <20071208191629.GB21186@elte.hu>
References: <20071207021952.6f0ac922@morte> <alpine.LFD.0.99999.0712070646210.3221@localhost.localdomain> <3d8471ca0712062318j483f8be6h256778752a13639a@mail.gmail.com> <20071207090252.1caf1509@inria.fr> <20071207135525.GA5588@elte.hu> <20071207152741.3408aeef@inria.fr> <20071207145206.GA21326@elte.hu> <20071208075735.4700bcac@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071208075735.4700bcac@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> > > > Firstly, we dont need the 'offset' anymore because cpu_clock() 
> > > > maintains offsets itself.
> > > 
> > > Yes, but a lower quality one. __update_rq_clock tries to 
> > > compensate large jumping clocks with a jiffy resolution, while my 
> > > offset arranges for a very smooth frequency transition.
> > 
> > yes, but that would be easy to fix up via calling 
> > sched_clock_idle_wakeup_event(0) when doing a frequency transition, 
> > without burdening the normal sched_clock() codepath with the offset. 
> > See the attached latest version.
> 
> can this deal with dual/quad core where the frequency of one core 
> changes if the sofware changes the frequency of the other core?

doesnt the notifier still get run on the target CPU?

	Ingo

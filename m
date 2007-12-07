Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbXLGKlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbXLGKlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 05:41:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbXLGKk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 05:40:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55789 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbXLGKk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 05:40:57 -0500
Date: Fri, 7 Dec 2007 11:40:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefano Brivio <stefano.brivio@polimi.it>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Message-ID: <20071207104013.GC27307@elte.hu>
References: <20071207021952.6f0ac922@morte> <20071207084559.GA11162@elte.hu> <20071207023241.15274ef6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207023241.15274ef6.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > -				t = printk_clock();
> > +				t = cpu_clock(printk_cpu);
> >  				nanosec_rem = do_div(t, 1000000000);
> >  				tlen = sprintf(tbuf,
> >  						"<%c>[%5lu.%06lu] ",
> 
> A bit risky - it's quite an expansion of code which no longer can call 
> printk.
> 
> You might want to take that WARN_ON out of __update_rq_clock() ;)

hm, dont we already detect printk recursions and turn them into a silent 
return instead of a hang/crash?

	Ingo

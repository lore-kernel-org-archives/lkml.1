Return-Path: <linux-kernel-owner+w=401wt.eu-S1759535AbZBTROz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535AbZBTROz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbZBTROm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:14:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58186 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018AbZBTROl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:14:41 -0500
Date: Fri, 20 Feb 2009 18:14:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090220171427.GE24538@elte.hu>
References: <20090220134121.GA19575@damson.getinternet.no> <20090220135000.GA9616@elte.hu> <20090220140157.GA12799@elte.hu> <19f34abd0902200651k7e86aebay5398ef5ac0578561@mail.gmail.com> <20090220154619.GC6960@linux.vnet.ibm.com> <20090220160409.GB11294@elte.hu> <20090220164441.GG6960@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220164441.GG6960@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> > > So, what flavor of RCU were you using?
> > 
> > well, even in preemptible RCU the grace period should be 
> > extended as long as we are non-preempt (which we are here), 
> > correct?
> 
> Given Classic RCU, you are quite correct.  With preemptable 
> RCU, if there are no readers, and if irqs are enabled, the 
> grace period could end within the spinlock's critical section.  
> Of course, the spinlock would need to be held for an 
> improbably long time -- many milliseconds.

ah. But we _can_ get unlucky there and get into 
multiple-milliseconds of blockage: for example if some heavy 
interrupt source or softirq processes stuff for many 
milliseconds.

So it's a real fix needed both for mainline and for 2.6.28. 
And kudos to kmemcheck ;-)

	Ingo

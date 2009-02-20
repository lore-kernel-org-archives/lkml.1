Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbZBTTlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbZBTTlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 14:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZBTTll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 14:41:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60409 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbZBTTlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 14:41:40 -0500
Date: Fri, 20 Feb 2009 20:40:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       steiner@sgi.com
Subject: Re: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single
	ipi fallback for smp_call_function_many())
Message-ID: <20090220194054.GA2444@elte.hu>
References: <20090217112657.GE26402@wotan.suse.de> <1234923702.29823.7.camel@vayu> <20090218135945.GC23125@wotan.suse.de> <1234982620.29823.22.camel@vayu> <20090218191757.GD8889@elte.hu> <1235001314.14523.2.camel@vayu> <20090219122031.GC1703@elte.hu> <1235080824.14523.19.camel@vayu> <20090220105640.GE28581@elte.hu> <1235156214.14523.54.camel@vayu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235156214.14523.54.camel@vayu>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> > So the question is, is an SFENCE there enough to serialize 
> > the WRMSR with previous memory-writes? It's not specified in 
> > the x2apic docs as far as i could see.
> 
> No. sfence is not enough (wrmsr to x2apic regs was still 
> passing ahead). We have done a small experiment to demonstrate 
> the issue and adding mfence fixes the issue but not sfence. We 
> need a serializing instruction or mfence. I will try to get 
> the SDM updated.

Fair enough!

	Ingo

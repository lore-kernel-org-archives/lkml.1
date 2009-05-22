Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbZEVKPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbZEVKPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 06:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbZEVKPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 06:15:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55175 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbZEVKPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 06:15:01 -0400
Date: Fri, 22 May 2009 12:14:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
	identical inherited contexts
Message-ID: <20090522101455.GD13482@elte.hu>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com> <18966.10666.517218.332164@cargo.ozlabs.ibm.com> <1242981131.26820.620.camel@twins> <20090522085716.GB13482@elte.hu> <1242982920.26820.622.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242982920.26820.622.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2009-05-22 at 10:57 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > On Fri, 2009-05-22 at 14:27 +1000, Paul Mackerras wrote:
> > > 
> > > > The equivalence of contexts is detected by keeping a pointer in
> > > > each cloned context pointing to the context it was cloned from.
> > > > To cope with the situation where a context is changed by adding
> > > > or removing counters after it has been cloned, we also keep a
> > > > generation number on each context which is incremented every time
> > > > a context is changed.  When a context is cloned we take a copy
> > > > of the parent's generation number, and two cloned contexts are
> > > > equivalent only if they have the same parent and the same
> > > > generation number.  In order that the parent context pointer
> > > > remains valid (and is not reused), we increment the parent
> > > > context's reference count for each context cloned from it.
> > > 
> > > > +	u32			generation;
> > > 
> > > Suppose someone writes a malicious proglet that inherits the 
> > > counters, puts the child to sleep, does 2^32 mods on the counter 
> > > set, and then wakes up the child.
> > > 
> > > Would that merely corrupt the results, or make the kernel explode?
> > 
> > i think it should be an u64.
> 
> So at to make the attack infeasible by death of the attacker and 
> burnout of the solar-system? :-)

Yeah. We only have to make it for the next 1 billion years anyway - 
then due to the sun being ~50% brighter the planet as we know it 
will be scorched up anyway. (Unless some entity puts it under 
massive space based shades until then, to preserve the ancient 
biosphere for nostalgic or museologic reasons or so.)

	Ingo

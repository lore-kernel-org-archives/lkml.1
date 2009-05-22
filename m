Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbZEVI5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbZEVI5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZEVI5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:57:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55097 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbZEVI5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:57:34 -0400
Date: Fri, 22 May 2009 10:57:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
	identical inherited contexts
Message-ID: <20090522085716.GB13482@elte.hu>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com> <18966.10666.517218.332164@cargo.ozlabs.ibm.com> <1242981131.26820.620.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242981131.26820.620.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2009-05-22 at 14:27 +1000, Paul Mackerras wrote:
> 
> > The equivalence of contexts is detected by keeping a pointer in
> > each cloned context pointing to the context it was cloned from.
> > To cope with the situation where a context is changed by adding
> > or removing counters after it has been cloned, we also keep a
> > generation number on each context which is incremented every time
> > a context is changed.  When a context is cloned we take a copy
> > of the parent's generation number, and two cloned contexts are
> > equivalent only if they have the same parent and the same
> > generation number.  In order that the parent context pointer
> > remains valid (and is not reused), we increment the parent
> > context's reference count for each context cloned from it.
> 
> > +	u32			generation;
> 
> Suppose someone writes a malicious proglet that inherits the 
> counters, puts the child to sleep, does 2^32 mods on the counter 
> set, and then wakes up the child.
> 
> Would that merely corrupt the results, or make the kernel explode?

i think it should be an u64.

	Ingo

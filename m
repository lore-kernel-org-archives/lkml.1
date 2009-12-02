Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbZLBJTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbZLBJTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 04:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZLBJTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 04:19:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50209 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbZLBJTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 04:19:20 -0500
Date: Wed, 2 Dec 2009 10:19:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sripathi Kodi <sripathik@in.ibm.com>
Cc: Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 0/2] Futex fault injection
Message-ID: <20091202091907.GA22654@elte.hu>
References: <20091201141642.398e7b7d@sripathi>
 <20091201103351.GA6685@elte.hu>
 <1259664883.1697.28.camel@laptop>
 <20091201125537.GA23382@elte.hu>
 <4B15414A.9040405@us.ibm.com>
 <20091201162359.GA1079@elte.hu>
 <20091202112801.51af65c0@sripathi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202112801.51af65c0@sripathi>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sripathi Kodi <sripathik@in.ibm.com> wrote:

> On Tue, 1 Dec 2009 17:23:59 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Darren Hart <dvhltc@us.ibm.com> wrote:
> > 
> > > I don't think the "butt-ugly" argument is enough to reject the patch. 
> > 
> > It is in my book - i dont ever apply ugly patches intentionally.
> > 
> > > It's a fairly subjective metric and I don't think the proposed 
> > > solution results in "pretty" code either. In fact the super long 
> > > function names and multi-line conditionals are arguably "ugly" (maybe 
> > > not "butt-ugly" though). :-)
> > >
> > > However, the arguments are solid and I understand wanting to introduce 
> > > a new feature in a particular way. Has there been any work done on 
> > > perf event injection up to this point or would this be a completely 
> > > new perf feature?
> > 
> > Yeah, it would be a brand new one.
> > 
> 
> Fault injection framework currently in the kernel provides an 
> infrastructure to set parameters like 'probability', 'interval', 
> 'times' as well as a task filter. I think a fault injection mechanism 
> using tracepoints-perf will also need to provide such a framework, 
> because without that the faults become too predictable. For example, 
> if there are 20 fault points in the kernel, we should be able to 
> trigger any one of them with a given probability, possibly for a 
> particular task alone. This infrastructure will have to be built in 
> perf tools in user space. Do you agree?

Yeah, definitely so. I think event injection is ultimately useful and 
should/could graduate/extend from its current rather limited debugfs 
based API to something syscall based (which perf could offer). App 
testsuites could programmatically inject faults, etc.

The act of logging/tracing/profiling events and the act of injecting 
events is ultimately connected.

Btw., 'perf task filter' is something inherent in perf events: you can 
define per task (or per cpu, or per task hierarchy) events.

	Ingo

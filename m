Return-Path: <linux-kernel-owner+w=401wt.eu-S1752115AbZLBF6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbZLBF6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 00:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZLBF6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 00:58:05 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:48816 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbZLBF6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 00:58:05 -0500
Date: Wed, 2 Dec 2009 11:28:01 +0530
From: Sripathi Kodi <sripathik@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 0/2] Futex fault injection
Message-ID: <20091202112801.51af65c0@sripathi>
In-Reply-To: <20091201162359.GA1079@elte.hu>
References: <20091201141642.398e7b7d@sripathi>
	<20091201103351.GA6685@elte.hu>
	<1259664883.1697.28.camel@laptop>
	<20091201125537.GA23382@elte.hu>
	<4B15414A.9040405@us.ibm.com>
	<20091201162359.GA1079@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009 17:23:59 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Darren Hart <dvhltc@us.ibm.com> wrote:
> 
> > I don't think the "butt-ugly" argument is enough to reject the patch. 
> 
> It is in my book - i dont ever apply ugly patches intentionally.
> 
> > It's a fairly subjective metric and I don't think the proposed 
> > solution results in "pretty" code either. In fact the super long 
> > function names and multi-line conditionals are arguably "ugly" (maybe 
> > not "butt-ugly" though). :-)
> >
> > However, the arguments are solid and I understand wanting to introduce 
> > a new feature in a particular way. Has there been any work done on 
> > perf event injection up to this point or would this be a completely 
> > new perf feature?
> 
> Yeah, it would be a brand new one.
> 

Fault injection framework currently in the kernel provides an
infrastructure to set parameters like 'probability', 'interval',
'times' as well as a task filter. I think a fault injection mechanism
using tracepoints-perf will also need to provide such a framework,
because without that the faults become too predictable. For example, if
there are 20 fault points in the kernel, we should be able to trigger
any one of them with a given probability, possibly for a particular
task alone. This infrastructure will have to be built in perf tools in
user space. Do you agree?

Thanks,
Sripathi.

> There's a couple of other usecases as well:
> 
>  - User space logging: apps want to define tracepoints and want to
>    inject events as they happen - mixed properly into the regular perf
>    events flow.
> 
>  - MCE logging: hw faults are so rare that injection is desired to make
>    sure the policy action chain is working properly.
> 
>  - Some of the other fault injection sites could be converted to
>    tracepoints + injection-conditions as well, perhaps. That would give
>    a more programmable interface and a generic event logging framework.
> 
> So it's nice and important work (and by no means trivial - that comes 
> with the territory) - in case you are interested.
> 
> Thanks,
> 
> 	Ingo

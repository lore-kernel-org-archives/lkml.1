Return-Path: <linux-kernel-owner+w=401wt.eu-S1761029AbXKNQkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029AbXKNQkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbXKNQkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:40:40 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:53532 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbXKNQkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:40:39 -0500
Date: Wed, 14 Nov 2007 08:34:01 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [perfmon] Re: conflict between tickless and perfmon2
Message-ID: <20071114163401.GN6557@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071109104438.GB18909@frankl.hpl.hp.com> <1194605991.6289.162.camel@twins> <alpine.LRH.0.999.0711091934210.1196@www.tglx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.0.999.0711091934210.1196@www.tglx.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Fri, Nov 09, 2007 at 07:40:31PM +0100, Thomas Gleixner wrote:
> On Fri, 9 Nov 2007, Peter Zijlstra wrote:
> 
> 
> > > It looks like a solution would be to change the implementation of
> > > timeout-based switching to use HR timers instead. Similar to what is
> > > done for ITIMER_REAL and ITIMER_VIRTUAL.
> 
> Using a hrtimer is perfrectly fine, I'd say it's preferred over hooks in 
> some code which has absoluty no guarantee of being executed periodically 
> or even executed at all. OTOH it seems rather stupid to measure stuff 
> while the system is idle and doing nothing.
> 
I managed to switch the perfmon2 code to use hrtimer(CLOCK_MONOTONIC)
for system-wide (per-cpu) measurements. The code is simple and this allowed
me to do some more cleanups. I think this was a good suggestion and I made
the change rapidly.

Now, I must admit I don't quite understand how to make this work for per-thread
measurements where the timer would have to operate like ITIMER_VIRTUAL,i.e., only
run when the thread runs. I looked at the setitimer() code and I admit it is
not clear to me. What about CLOCK_THREAD_CPUTIME_ID, would it do what I need from
inside the kernel?

Thanks.

-- 
-Stephane

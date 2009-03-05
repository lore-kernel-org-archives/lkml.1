Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbZCENPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbZCENPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZCENPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:15:46 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:57936 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbZCENPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:15:44 -0500
Date: Thu, 5 Mar 2009 18:45:38 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 11/11] ftrace plugin for kernel symbol tracing using HW
	Breakpoint interfaces
Message-ID: <20090305131538.GA32076@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090305043440.189041194@linux.vnet.ibm.com> <20090305044333.GM17747@in.ibm.com> <20090305063703.GB5359@nowhere> <20090305091611.GB16026@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305091611.GB16026@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 10:16:11AM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Thu, Mar 05, 2009 at 10:13:33AM +0530, prasad@linux.vnet.ibm.com wrote:
> > > This patch adds an ftrace plugin to detect and profile memory access over
> > > kernel variables. It uses HW Breakpoint interfaces to 'watch memory
> > > addresses.
> > > 
> > > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com> 
> > > ---
> > 
> > 
> > Hi,
> > 
> > Nice feature. And moreover the standardized hardware 
> > breakpoints could be helpful for tracing.
> 
> yeah. The feature is much more alive now.
> 
> > Just some comments below.
> 
> One other thing:
> 
> +#ifdef CONFIG_FTRACE_SELFTEST
> +int trace_selftest_startup_ksym(struct tracer *trace, struct trace_array *tr)
> +{
> +       /* TODO: Will be implemented later */
> +       return 0;
> +}
> +#endif /* CONFIG_FTRACE_SELFTEST */
> 
> This needs to be implemented before i can pick the code up into 
> tip:tracing, as otherwise we will not notice it fast enough if 
> some of this stuff breaks.
> 
> Basically the ftrace plugin will be the main usage vector of 
> this facility, so the self-test is a must-have.
> 
> Looks very nice otherwise.
> 
> 	Ingo

Thanks for the comments.

Test-cases for the hardware breakpoint interfaces can be the following:

- Basic sanity test to check if the API is intact
- Perform various types of memory accesses, like read, write (I/O and 
  others when implemented) on a dummy kernel variable and verify the 
  trigger of the exception handler.

While the above can be a part of trace_selftest_startup_ksym(),
rigorous testing would involve:

i) stressing the HW breakpoint infrastructure to confirm sane behaviour
when interoperated with other users of a)breakpoint register b)the
do_debug() exception. This will involve simultaneous use of kprobes,
hardware breakpoint interface and requests from user-space (say through
GDB).
ii) Verifying successful HB_NUM number of register_ requests.
iii) Verifying right priority resolution, and handling user-space
requests.

These, in my opinion, would better fit in a full-featured test-suite
such as LTP, as opposed to startup testing in ftrace.

I will implement trace_selftest_startup_ksym() to contain the first two
test-cases in the next iteration of this code.

Thanks,
K.Prasad


Thanks,
K.Prasad



Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbZCYIyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbZCYIyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbZCYIyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:54:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59520 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbZCYIyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:54:36 -0400
Date: Wed, 25 Mar 2009 09:54:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Anyone working on ftrace function graph support on ARM?
Message-ID: <20090325085418.GA2341@elte.hu>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <49C95EAF.7030901@gmail.com> <20090324224857.GE5975@nowhere> <20090325084248.GF4697@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325084248.GF4697@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Tue, Mar 24, 2009 at 11:48:58PM +0100, Frederic Weisbecker wrote:
> > On Tue, Mar 24, 2009 at 06:29:03PM -0400, Abhishek Sagar wrote:
> > > Instead of just restoring the old backed-up args, lr can be fixed up
> > > inside the entry hook to point to the return hook. So when the traced
> > > function returns, it actually returns to the return hook (where we can
> > > restore the original return address). This means that
> > > -finstrument-functions is not required at all. This is analogous to how
> > > kretprobes work. The only difference here is that instead of planting a
> > > kprobe at the function entry and redirecting the function return to the
> > > profiling exit routine, we can use mcount. This is slightly more
> > > complicated to implement but can be a very efficient alternative to
> > > kretprobes.
> > > --
> > > Abhishek
> > > 
> > 
> > Indeed, you need to override lr, that even the only solution.
> > I was still thinking in an x86 way with its on stack return address.
> 
> As pointed out in my previous mail, identifying where on the stack 
> the return address is stored is only possible for OABI with frame 
> pointers.
> 
> EABI will probably be possible with the stack unwinding code, but 
> it probably won't be cheap.  The EABI unwinder is scheduled for 
> merging during the present now-open merge window.

Unwinding is not realistic or desired for the function tracer - it 
runs in every kernel function so performance is paramount.

So, if i understood you correctly, an OABI_COMPAT and FRAME_POINTERS 
dependency has to be added to the ARM HAVE_FUNCTION_GRAPH_TRACER 
Kconfig rule.

	Ingo

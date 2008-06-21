Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbYFUSEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbYFUSEu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 14:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbYFUSEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 14:04:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbYFUSEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 14:04:41 -0400
Date: Sat, 21 Jun 2008 14:02:03 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Hideo AOKI <haoki@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][Patch 2/2] markers: example of irq regular kernel markers
Message-ID: <20080621180203.GA11804@redhat.com>
References: <20080620174529.GB10943@Krystal> <485C064E.5020705@redhat.com> <20080621190132.E835.KOSAKI.MOTOHIRO@jp.fujitsu.com> <Pine.LNX.4.58.0806211013300.32694@gandalf.stny.rr.com> <y0mwskiyh36.fsf@ton.toronto.redhat.com> <Pine.LNX.4.58.0806211058510.28481@gandalf.stny.rr.com> <1214064834.3223.231.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214064834.3223.231.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Sat, Jun 21, 2008 at 06:13:54PM +0200, Peter Zijlstra wrote:

> [...]  I think what Frank refers to here is why not scatter the
> kernel code with trace_mark()s on every conceivable location like
> you do with printk-style debugging.

It's not fair to caricaturize my suggestions this way ("every
conceivable location").

> Those trace marks might help out when $customer's kernel goes splat
> and you don't want to provide him with a custom kernel.

Right.

> I do think we must make a clear distinction between these cases because:
>
> 1) tracers provide a kernel<->user interface - and whilst we don't
> have a stable in-kernel API/ABI we are anal about the kernel/user
> boundary.  Andrew also greatly worries about this aspect.

Well, how to set Andrew's mind at ease then, beyond what we've already
said?  Back a few months ago, both systemtap and lttng guys - the
primary user-space clients - have said that we are fine with this
interface changing.  We each have mechanisms to adapt.

> 2) it highly uglyfies the code, Frank doesn't need to maintain it,
> so its easy for him to say. But IMHO its much harder to read code
> that is littered with debug statements that it is to read regular
> code.

Then don't put too many in, or hide them with inline functions.

>  3) it bloats the kernel,.. while it may not be fast path bloat, all
> that marker stuff does go somewhere.

That bloat has been quantified and appears negligible in space and time.

> So, while I see the value of 'stable' mark sites for 'stable'
> events, I'm dead-set against littering the kernel with markers just
> because we can, and hoping they might some day be useful for
> someone.

We're in violent agreement.  No one suggested "littering just because
we can".  The initial lttng suite of markers consisted of about one
hundred *in total*.  If some other subsystem maintainer runs amok and
adds thousands, please take it up with them, not with us.


- FChE

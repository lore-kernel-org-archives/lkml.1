Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbYGXPN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbYGXPN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757245AbYGXPNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:13:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37267 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbYGXPNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:13:48 -0400
Date: Thu, 24 Jul 2008 11:13:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 08/17] LTTng instrumentation - kernel
In-Reply-To: <20080724143009.GA8094@Krystal>
Message-ID: <Pine.LNX.4.58.0807241111560.14946@gandalf.stny.rr.com>
References: <20080715222604.331269462@polymtl.ca> <20080715222747.761260243@polymtl.ca>
 <Pine.LNX.4.58.0807240956350.14946@gandalf.stny.rr.com> <20080724143009.GA8094@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 24 Jul 2008, Mathieu Desnoyers wrote:
>
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> >
> >
> > On Tue, 15 Jul 2008, Mathieu Desnoyers wrote:
> > >
> > >  /*
> > >   * Low level drivers may need that to know if they can schedule in
> > > @@ -601,6 +603,7 @@ asmlinkage int printk(const char *fmt, .
> > >  	int r;
> > >
> > >  	va_start(args, fmt);
> > > +	trace_kernel_printk(__builtin_return_address(0));
> >
> > BTW, ftrace.h has macros that let you use CALLER_ADDR0 for
> > __builtin_return_address. It also converts it from a pointer to a long,
> > but makes the code look prettier.
> >
>
> include/linux/kernel.h:#define _RET_IP_   (unsigned long)__builtin_return_address(0)
>
> Hrm, did not see this one. So I guess we can both switch to it ?

Hmm, yeah, I forgot about that. Someplaces I do use CALLER_ADDR1 and
higher, but when it is just CALLER_ADDR0, then _RET_IP_ would probably be
better.

>
> Thanks for pointing this out,

-- Steve


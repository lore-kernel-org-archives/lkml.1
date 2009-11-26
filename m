Return-Path: <linux-kernel-owner+w=401wt.eu-S1751620AbZKZMlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbZKZMlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 07:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbZKZMlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 07:41:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36364 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbZKZMlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 07:41:05 -0500
Subject: Re: [PATCH 1/4 tip/sched/core] sched: rename preempt_notifier to
 sched_notifier and always enable it
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20091126115605.GA15189@elte.hu>
References: <20091126190018.88a6dd77.sfr@canb.auug.org.au>
	 <20091126081237.GA31034@elte.hu> <4B0E4741.10509@kernel.org>
	 <20091126092631.GA17253@elte.hu> <4B0E4EFB.2070705@kernel.org>
	 <20091126095154.GE32275@elte.hu> <4B0E5458.30303@kernel.org>
	 <20091126102936.GA1196@elte.hu> <1259231565.4273.31.camel@twins>
	 <1259234619.4273.32.camel@twins>  <20091126115605.GA15189@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 Nov 2009 13:40:59 +0100
Message-ID: <1259239259.4273.82.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 12:56 +0100, Ingo Molnar wrote:
> 
> I wouldnt mind some form of TRACE_EVENT_CALLBACK() thing whose callback 
> facility is always available, even if CONFIG_PERF_EVENTS and 
> CONFIG_TRACING is disabled.

CALLBACK_EVENT() would be my preferred name, and shouldn't live anywhere
near the regular tracing bits, the tracing bits could simply add another
callback in it when enabled.

> It might grow out of notifier.h - albeit i suspect the shorter path 
> would be to grow it from TRACE_EVENT().
> 
> ( The various pagefault notifiers in arch/x86/mm/fault.c could use this 
>   facility too. )
> 
> What we definitely dont want is the proliferation of callbacks.

Sure, a first approach would be to find something that can cover both
these extended preempt notifiers and the mmu notifier stuff, clearly
notifier.h isn't cutting it anymore, and rolling these things yourself
has obvious disadvantages like not being to add generic bits without
having to touch all of them.

The big downside from TRACE_EVENT() like things is the implementation,
its a horrid macro mess. They're nice enough when you don't have to
touch the implementation, but rather painful when you do have to.

But I guess there's just no real alternative..

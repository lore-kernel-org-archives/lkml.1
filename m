Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbZJGB4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbZJGB4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 21:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbZJGB4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 21:56:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47382 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162AbZJGB4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 21:56:36 -0400
Subject: Re: [PATCH 1/4] jump label - make init_kernel_text() global
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, ak@suse.de,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com
In-Reply-To: <20091003123900.GA22046@Krystal>
References: <cover.1253831945.git.jbaron@redhat.com>
	 <77d69d0f3c8e1f98a4c2392ea4e4f6c25ed177f4.1253831946.git.jbaron@redhat.com>
	 <20091001112003.GA2962@elte.hu> <20091001203905.GD2660@redhat.com>
	 <20091003104335.GB15919@elte.hu>  <20091003123900.GA22046@Krystal>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 06 Oct 2009 21:54:38 -0400
Message-Id: <1254880478.1696.104.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-03 at 08:39 -0400, Mathieu Desnoyers wrote:

> I might be missing a bit of context here, I just want to make sure we
> are on the same page: patching a jmp instruction is safe on UP, safe
> with stop_machine(), is very likely safe with the breakpoint-ipi

Hi Mathieu,

I've been reading through these threads (both this one and the immediate
one) and I'm still a bit confused. I really want to understand this in a
simple way, thus make sure everyone else understands it too.

>From what Arjan said here:

  http://lkml.org/lkml/2009/9/25/98

The issue is going back from the int3 to the old value. How does the
breakpoint-ipi work?

Supposedly, we can add an int3 to the code without any worry. If another
CPU at that same time hits that code path, it will either run the old
code, or take the interrupt. The breakpoint interrupt handler, will
handle that code path, and the execution continues.

Now what is the issues with removing the int3 and placing back the old
(or new) value. Is there an issue if another CPU is about to execute
that code path as we remove the int3? If so, how does sending an IPI
help the matter without adding more races?

Is there only an issue if we change the old value with something else,
and you just need to send the IPI after you modify the old code and
before removing the int3?

I may just be totally confused, which I usually am. But when I'm not
confused, I feel that the code is practical ;-)

-- Steve

 

> approach (but we need the confirmation from Intel, which hpa is trying
> to get), but is definitely _not_ safe if neither of these methods are
> used on a SMP system. If a non-aligned multi-word jump is modified while
> another CPU is fetching the instruction, bad things could happen.



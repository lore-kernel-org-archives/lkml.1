Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbZFPUbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbZFPUbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760245AbZFPUar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:30:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53953 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043AbZFPUap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:30:45 -0400
Message-ID: <4A380000.5090206@zytor.com>
Date: Tue, 16 Jun 2009 13:26:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain	support
 to use NMI-safe methods
References: <20090615215420.GE12919@Krystal> <4A36C953.8060906@zytor.com> <20090615223038.GA15903@Krystal> <4A36CCFC.8070908@zytor.com> <20090615224908.GA16661@Krystal> <4A36F520.6020604@zytor.com> <20090616030522.GA22162@Krystal> <20090616083343.GD16229@elte.hu> <20090616141956.GB6541@Krystal> <4A37B8CF.8090804@zytor.com> <20090616190634.GA16430@Krystal>
In-Reply-To: <20090616190634.GA16430@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * H. Peter Anvin (hpa@zytor.com) wrote:
>> Mathieu Desnoyers wrote:
>>> With respect to cr2, yes, this is the only window we care about.
>>> However, the rest of vmalloc_fault() must be audited for other non
>>> nmi-suitable data structure use (e.g. "current"), which I did in the
>>> past.
>>>
>>> My intent was just to respond to Peter's concerns by showing that the
>>> part of page fault handler which needs to be NMI-reentrant is really not
>>> that big.
>>>
>> Even if that is true now, you want it to be true for all future time,
>> and all to support an out-of-tree piece of code.  All of this is
>> virtually impossible to test for without said out-of-tree piece of code,
>> so I will object to it anyway.
>>
> 
> I think we are confusing two very distinct topics here :
> 
> LTTng is currently out-of-tree. Yes. It does not have to stay like this
> in the future. Or it can be a different tracer, like ftrace for
> instance.
> 
> LTTng can be built as modules. This is very likely to stay like this
> even if LTTng (or parts of) are merged. Or as a different tracer is
> merged. The reason why building a tracer as a module is convenient for
> users has been expressed in a previous mail.
> 
> So now you argue that it should not be made easy to implement
> tracers/profilers so they can be built as kernel modules because the
> LTTng tracer is out-of-tree. I'm sorry, but I really don't follow your
> line of reasoning.
> 
> So let's say we merge tracer or profiler code into the mainline kernel
> and permit that code to be built as module, hence enable testing within
> the mainline tree, would you be fine with this?
> 

I'm saying that imposing constraints on kernel code has cost.  The cost
may not be immediately evident, but it constraints the kernel
development going forward, potentially for all times.  It is
particularly obnoxious with out-of-tree users, because it is impossible
to fix up those users to deal with a new interface, or even know what
their constraints really are.

This is part of the fundamental problem that Xen causes, for example.

	-hpa

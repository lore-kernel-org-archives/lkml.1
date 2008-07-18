Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbYGRKbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbYGRKbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbYGRKbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:31:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34911 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbYGRKbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:31:17 -0400
Message-ID: <488070F1.9030903@firstfloor.org>
Date: Fri, 18 Jul 2008 12:31:13 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org,
       jbeulich@novell.com
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
 (part1: use kprobe symbol_name/offset instead of address)
References: <1216146802.3312.95.camel@localhost.localdomain>	 <87ej5rsgk4.fsf@basil.nowhere.org> <1216373009.5232.130.camel@twins>
In-Reply-To: <1216373009.5232.130.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  1) stap ought to use the kernel's infrastructure and not re-implement
> its own.
> 
>  2) if the kernel's infrastructure doesn't meet requirements, improve
> it.

No argument on either of those. Right now the kernel infrastructure
is only comparable to what systemtap overs at very high overhead
costs (see below)

> But while the x86 might not be perfect, its fairly ok these days. Its
> not the utter piece of shite x86_64 had for a long time 

Not sure what you're referring to with this. AFAIK the x86-64 unwinder
for a normal frame pointer less kernel was not any worse (or better)
than a i386 kernel without frame pointers.

- today's traces
> mostly make sense.

If you enable frame pointers? Making your complete kernel slower?
Generating much worse code on i386 by wasting >20% of its available
registers?  Getting pipeline stalls on each function call/exit on many CPUs?

Right now unfortunately there are a few rogue CONFIGs who select that
so more and more kernels have, but I found that always distateful because
enabling frame pointers has such a large impact on all kernel code, especially
on the register starved i386.

I still think the right solution eventually is to have a dwarf2 unwinder
by default for i386/x86-64 and get rid of all these nasty "select
FRAME_POINTER"s which have unfortunately sneaked in.

-Andi


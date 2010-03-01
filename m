Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab0CAQsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:48:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349Ab0CAQsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:48:16 -0500
Date: Mon, 1 Mar 2010 08:47:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/cpu changes for v2.6.34
In-Reply-To: <20100301131701.GA5562@nowhere>
Message-ID: <alpine.LFD.2.00.1003010843050.3616@localhost.localdomain>
References: <20100227150942.GA6394@elte.hu> <alpine.LFD.2.00.1002281205320.27475@localhost.localdomain> <alpine.LFD.2.00.1002281239550.3637@localhost.localdomain> <20100301080058.GA8049@elte.hu> <20100301131701.GA5562@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Mar 2010, Frederic Weisbecker wrote:

> On Mon, Mar 01, 2010 at 09:00:58AM +0100, Ingo Molnar wrote:
> > 
> > 	if (smp_processor_id() == 7)
> > 		ftrace_enabled = 1;
> > 
> > 	... bootup sequence ...
> > 
> > 	if (smp_processor_id() == 7)
> > 		ftrace_enabled = 0;

> So, after the boot you can look at /debug/tracing/per_cpu/cpu7/trace
> and the end of the trace should contain what you want.

Both of you seemed to miss the fact that it's not cpu7 that is 
particularly slow. See the original email from me in this thread: the jump 
was at some random point:

        [    0.245179] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
        [    0.265332]  #2
        [    0.353185] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
        [    0.373328]  #3
        [    2.193277] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
        [    2.213379]  #4

and the reason I grepped for "CPU 7" was that it's the _last_ CPU on this 
machine, so what I was grepping for was basically "how long did it take to 
bring up all CPU's".

So that particular really bad case apparently happened for CPU#3, but the 
two other slow cases happened for CPU#4.

Also, it seems to happen only about every fifth boot or so. Suggestions 
for something simple that can trace things like that?

		Linus

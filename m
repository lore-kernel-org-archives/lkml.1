Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbYIYUcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbYIYUcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbYIYUcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:32:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753421AbYIYUcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:32:04 -0400
Date: Thu, 25 Sep 2008 13:24:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <20080925201211.GA1878@elte.hu>
Message-ID: <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org>
References: <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org>
 <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251247010.27920@gandalf.stny.rr.com> <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org>
 <20080925195522.GA22248@elte.hu> <20080925201211.GA1878@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Sep 2008, Ingo Molnar wrote:
> 
> You seem to dismiss that angle by calling my arguments bullshit, but i 
> dont know on what basis you dismiss it. Sure, a feature and extra 
> complexity _always_ has a robustness cost. If your argument is that we 
> should move cpu_clock() to assembly to make it more dependable - i'm all 
> for it.

Umm. cpu_clock() isn't even cross-cpu synchronized, and has actually 
thrown away all the information that can make it so, afaik. At least the 
comments say "never more than 2 jiffies difference"). You do realize that 
if you want to order events across CPU's, we're not talking about 
"jiffies" here, we're talking about 50-100 CPU _cycles_.

You also ignore the early trace issues, and have apparently not used it 
for FTRACE. You also ignore the fact that without TSC, it goes into the 
same "crap mode" that is appropriate for the scheduler, but totally 
useless for tracing.

IOW, you say that I call your arguments BS without telling you why, but 
that's just because you apparently cut out all the things I _did_ tell you 
why about!

The fact is, people who do tracing will want better clocks - and have 
gotten with other infrastructure - than you have apparently cared about. 
You've worried about scheduler tracing, and you seem to want to just have 
everybody use a simple but known-bad approach that was good enough for 
you.

			Linus

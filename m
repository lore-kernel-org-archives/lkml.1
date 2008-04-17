Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbYDQT60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbYDQT60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 15:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYDQT6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 15:58:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754036AbYDQT6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 15:58:06 -0400
Date: Thu, 17 Apr 2008 12:57:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: hch@infradead.org, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, arjan@infradead.org,
       John Levon <levon@movementarian.org>,
       Philippe Elie <phil.el@wanadoo.fr>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417125701.83849f30.akpm@linux-foundation.org>
In-Reply-To: <20080417185158.GA26603@elte.hu>
References: <20080416202338.GA6007@elte.hu>
	<20080417002552.5742ad65.akpm@linux-foundation.org>
	<84144f020804170045s24cbb802u3358ec6b5d391a10@mail.gmail.com>
	<20080417012051.ed56f4ab.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0804171130090.4929@sbz-30.cs.Helsinki.FI>
	<84144f020804170134k4c98f022xc247442592fb1a44@mail.gmail.com>
	<20080417014217.ab0453a9.akpm@linux-foundation.org>
	<20080417114900.GA17033@infradead.org>
	<20080417110135.08b076ac.akpm@linux-foundation.org>
	<20080417185158.GA26603@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 20:51:58 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > afaik the sysprof-vs-oprofile issue still hasn't been settled.  Maybe 
> > it's no longer a relevant question with the new code - I just don't 
> > know. Everything went all quiet and then this stuff happened.
> 
> i dont think there's any big issue here. Sysprof is a time and stack 
> system-wide tracer/profiler, oprofile profiles CPU events - deep 
> stacktracing is an afterthought there. And how do you set up oprofile to 
> do precise time events?
> 
> with sysprof you can do:
> 
>   cd /sys/kernel/debug/tracing
>   echo sysprof > current_tracer
>   cat trace_pipe
> 
> and you'll see the trace events go by, live. The user-space bits of 
> sysprof have been ported over to ftrace/sysprof already and it's a 
> really nice tool that shows a deep stack-trace based hierarchical 
> "vertical" profile instead of the usual finegrained profile.

Well that's all good to hear but I don't know where you're getting your
information from.  In the past month and a half I've seen zero email from
Soeren and a single ftrace-related patch.

So right now I do not have enough information to understand what ftrace
does, let alone to compare it with oprofile.

And this is a problem.  I, probably more than anyone else, work with bug
reporters on kernel problems and I am not in a position to be able to
direct them to use an important new tool.  There isn't even a documentation
file I can point them at.

I'd imagine that a large number of the current kernel development team only
vaguely know of ftrace's existence, let alone how to use it and what its
advantages are.  So they just won't use it.

> It certainly helps that the author of the tracer plugin (Soeren 
> Sandmann) is the author of the userspace app too - so there's a rather 
> well-working feedback loop here ;-)
> 
> With oprofile all these things are rather indirect, the API is more 
> complex, it forces per-CPU buffers, etc. etc. I think for 
> instrumentation the driving force must be usability, and sysprof/ftrace 
> is hands down more usable - to me at least.

Well.  You know how to use it.

John, Phillippe: have you had a chance to take a look at the latest ftrace
code?

Thanks.

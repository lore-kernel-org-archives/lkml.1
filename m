Return-Path: <linux-kernel-owner+w=401wt.eu-S1761986AbZFKDTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986AbZFKDTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 23:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbZFKDS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 23:18:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754741AbZFKDSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 23:18:55 -0400
Date: Wed, 10 Jun 2009 20:18:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [GIT PULL] tracing/urgent for v2.6.31
In-Reply-To: <20090610230450.GA8964@elte.hu>
Message-ID: <alpine.LFD.2.01.0906102002260.6847@localhost.localdomain>
References: <20090610230450.GA8964@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Jun 2009, Ingo Molnar wrote:
>
> Let me know if we should instead avoid the conflict by backmerging 
> tracing/urgent more frequently.

No. So far, the merges from -tip this time around have been a pleasure.  
And I'd _much_ rather get a few conflicts, if that means that we can keep 
the things more separate, and have a more readable history. I think I had 
a total of two conflicts, and both of them were totally trivial.

[ Famous last words. Maybe I screwed them up. Whatever. They were simple 
  enough that even if I _did_ screw them up, it won't be anything serious ]

The only one that could have been better (modulo bugs or other 
misfeatures, of course - let's see how this merge window turns out) is the 
tracing one, which I really wish could have been split up more. That was a 
big half-meg diff, which meant that unlike the other ones, I couldn't 
really scan through it and feel like I got a feel for it. 

Aside from that one not being as obvious as the others, no big issues at 
least so far.

The only (small) complaint is that some new things seem to default to 'y', 
which I'm dubious about, but having several different and independent git 
trees, with small enough diffs that I can actually look at them, and with 
a history that is clearly "one area", makes it just _soo_ much easier for 
me to merge.

As to config options - why in the world does something like X86_PTRACE_BTS 
have a 'default y'? Yes, it got disabled again with a 'depends on BROKEN', 
but on the whole, that whole thing seems crazy. And I'm not talking about 
the code, I'm talking about whoever decided that it should have that 
strange 'default y' thing.

New features should _never_ default to 'y'.

I think defaulting CONFIG_FTRACE to 'y' is dubious too, but at least 
that's not a new feature as much as a new config option making other 
config options visible. But again, I do think it should likely default to 
off, even so.

Similarly, CONFIG_MARKERS seems to be forced to 'y' by something. Why?

Anyway - apart from small details like that, so far so good. If tracing is 
going to get this much churn in the future, I do wish that in the future 
different tracers be split up. But the merges have been way more readable 
this time. Good job.

		Linus

PS. Ok, I also do hate the prefix "ds". It tells nothing. There's a lot of 
new global functions etc that have that prefix. Sure, if you read the 
intel debug documentation, the whole "debug store" thing makes sense, but 
I think prefixes like that should be longer and more telling.

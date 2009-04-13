Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbZDMVbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbZDMVbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbZDMVbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:31:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39217 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbZDMVbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:31:31 -0400
Date: Mon, 13 Apr 2009 23:31:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC 0/3] Improvements to the tracing documentation
Message-ID: <20090413213124.GB8514@elte.hu>
References: <1239479479-2603-1-git-send-email-tytso@mit.edu> <20090412092524.GA30349@elte.hu> <20090412121533.GB10547@mit.edu> <20090412130105.GB20281@elte.hu> <20090412172344.GC10547@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090412172344.GC10547@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Tso <tytso@mit.edu> wrote:

> On Sun, Apr 12, 2009 at 03:01:05PM +0200, Ingo Molnar wrote:
> > Btw., you mention ext4 and jbd2 new-style tracepoints in the text. 
> > Does this mean you already have them coded up (i havent seen any 
> > patch posting from you), just that you cannot push it upstream yet 
> > because ext4 can be a module? We'll have modular new-style 
> > tracepoints soon.
> 
> Yes, I coded them up recently.  I wanted to do some performance 
> measurements, and being able to interleave the ext4 tracepoint 
> logs with the block I/o tracer was definitely handy.  Also, not 
> having to fight with balky userspace tools (whether it is 
> out-of-tree kernel support code, or random graphical userspace 
> libraries when I could really care less about a GUI interface) was 
> definitely a big win.

Cool. [ And i guess you'll like the per tracepoint filter 
expressions too :-) ]

> I only had two real problems.  One is that the block I/O tracer 
> only traces "real" devices, and not device mapper devices --- I 
> could user the blktrace userspace tool, but then the results 
> wouldn't be properly interleaved with the ext4 tracepoint logs.

Ok - i forwarded your mail to Li Zefan and he already posted a draft 
patch to attempt to solve this. "Cannot trace the primary block 
device my filesystem is using" is IMO a showstopper in your tracing 
work-flow critical path, so it needs some sort of quick solution.

> The second is that ext4 has its localized header files in 
> fs/ext4/*.h, and not in include/linux/*.h, and that was 
> problematic given that the trace code snippets in 
> include/trace/ext4_event_types.h needed access to some internal 
> ext4 data structures.  I ultimately solved the latter by creating 
> a include/linux/ext4_tracing_types.h, but I suspect this problem 
> will go away when you have modular new-style tracepoints --- if 
> not, I'd appreciately greatly if folks could consider whether or 
> not this support could be added.

I'd expect these problems to go away with Steve's module support and 
TRACE_EVENT()-simplification/cleanup series, yes.

> I'll attach the patches as replies to this mail thread so you can 
> see what I've done.  Any comments of anything I might have done 
> "wrong" would be greatly appreciated.

I dont think you can do anything "wrong" at this stage - the event 
tracer is still fresh out of the oven. It was shaped based on the 
needs of a few select core kernel non-modular subsystems (scheduler, 
irqs, etc.). Feedback from people like you with non-trivial 
independent tracing bits (you have a handful of useful-looking 
markers in ext4) is very much needed to shape and complete it.

So we'll sure try to address all your feedback and it would be 
extremely useful if you labeled all the steps that you found 
unintuitive, unnecessary, over-complicated or redundant or painful 
in any way. Please dont hold any of your punches ;-)

	Ingo

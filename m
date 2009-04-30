Return-Path: <linux-kernel-owner+w=401wt.eu-S1764408AbZD3QDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764408AbZD3QDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764271AbZD3QDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:03:22 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:50605 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754884AbZD3QDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:03:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsFAGln+UlMQW1W/2dsb2JhbACBUM5vg38F
Date: Thu, 30 Apr 2009 12:03:16 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>,
       Christoph Lameter <cl@linux.com>, thomas.pi@arcor.dea,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090430160316.GA12926@Krystal>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <alpine.DEB.1.10.0904300921290.22262@qirst.com> <20090430133859.GB8329@elte.hu> <20090430135005.GA5922@Krystal> <20090430143215.GE14696@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090430143215.GE14696@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:01:39 up 61 days, 12:27,  1 user,  load average: 2.33, 1.45,
	0.91
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Ingo Molnar (mingo@elte.hu) wrote:
> > > 
> > > * Christoph Lameter <cl@linux.com> wrote:
> > > 
> > > > On Wed, 29 Apr 2009, Mathieu Desnoyers wrote:
> > > > 
> > > > > to have a good look at the memory accounting code. We could 
> > > > > probably benefit of Christoph Lameter's cpu ops (using segment 
> > > > > registers to address per-cpu variables with atomic inc/dec) in 
> > > > > there. Or at least removing interrupt disabling by using preempt 
> > > > > disable and local_t variables for the per-cpu counters could 
> > > > > bring some benefit.
> > > > 
> > > > Guess we are ready for atomic per cpu ops now that the new per cpu 
> > > > allocator is in? Segment register issues with the PDA are also 
> > > > solved right?
> > > 
> > > it's all done, implemented and upstream already. You are a bit late 
> > > to the party ;-)
> > > 
> > > 	Ingo
> > 
> > Or way too early, depending on the point of view. :-)
> > 
> > e.g.
> > http://lkml.org/lkml/2008/5/30/3
> > 
> > I think Christoph deserves credits for pioneering this area with fresh
> > ideas.
> 
> Ok, i didnt want to go there - but let me correct this version of 
> history.
> 
> Christoph's zero-based x86 percpu patches were incomplete and never 
> worked reliably - Christoph unfortunately never addressed the 
> bugs/crashes i reported. (and Mike Travis and me injected quite a 
> bit of testing into it) There were two failed attempts to productize 
> them and the patches just bitrotted for more than a year.
> 
> Tejun on the other hand fixed those problems (four of Christoph's 
> patches survived more or less and were credited to Christoph) and 
> did more than 50 highly delicate patches of far larger complexity to 
> solve the _whole_ problem range - within a two months timeframe.
> 
> Ideas and half-done patches covering <10% of the work needed are not 
> enough. Being able to implement it and productize it is the real 
> deal, in my book.
> 
> Thanks goes to Christoph (and Rusty) for coming up with the idea, 
> but it would be manifestly unfair to not send 90% of the kudos to 
> Tejun for turning it all into reality and fixing all the other 
> problems and redesigning almost all the x86 percpu code in the 
> process! ;-)
> 

Then thanks to Christoph, Rusty and to Tejun for the respective effort
they did. My goal is surely only to recognise their respective credit.

Mathieu

> 	Ingo
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

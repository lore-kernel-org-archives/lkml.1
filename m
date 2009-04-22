Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZDVHWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZDVHWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 03:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZDVHWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 03:22:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57803 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbZDVHWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 03:22:37 -0400
Date: Wed, 22 Apr 2009 09:26:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka@firstfloor.org
Subject: Re: [PATCH 2/8] tracing: create automated trace defines
Message-ID: <20090422072605.GC14687@one.firstfloor.org>
References: <49E69E76.9030608@goop.org> <20090416234410.GA20513@Krystal> <87zlebpzmk.fsf@basil.nowhere.org> <20090421155106.GE3792@Krystal> <49EDFFE6.1080401@goop.org> <alpine.DEB.2.00.0904211320440.10097@gandalf.stny.rr.com> <20090421202828.GB32179@basil> <alpine.DEB.2.00.0904211711260.10097@gandalf.stny.rr.com> <20090422060701.GB14687@one.firstfloor.org> <alpine.DEB.2.00.0904220215530.9714@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904220215530.9714@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 02:24:17AM -0400, Steven Rostedt wrote:
> 
> On Wed, 22 Apr 2009, Andi Kleen wrote:
> 
> > > I think it was Ingo that let out the idea, and I'm starting to like it.
> > > 
> > > Perhaps we should fork off gcc and ship Linux with its own compiler. This 
> > > way we can optimize it for the kernel and not worry about any userland 
> > > optimizations.
> > > 
> > > I would like to do something like:
> > > 
> > > 	if (unlikely(err)) {
> > > 		__section__(".error_sect") {
> > 
> > 
> > gcc already supports that, you don't need to fork anything. It's called
> > hot/cold partitioning. Basically it splits functions into hot and cold
> > and unlikely parts and all the cold/unlikely parts go into a separate 
> > sections.
> > 
> > I think it's normally not enabled by default on x86 though, probably because
> > it doesn't help too much.
> > 
> > By default (unless you specify -fno-reorder-blocks) it does the same
> > without sections, just moving unlikely code out of line.
> 
> The unlikely code does not always get moved out that far. It still sits 
> inside a function, and looking at the tracepoint code it did not move it 
> far enough.

That's because you didn't enable the hot/cold partioning as I wrote.
These are separate options. By default it doesn't use partitions on x86,
but it can.

> If gcc can indeed move "unlikely" code completely out of the fast path, 
> and put it into its own sections, then I think we should go through the 
> kernel and start removing all "likely" and "unlikely"s that are not 99% 
> accurate. Then we can enable the separate section cold paths and perhaps 
> see a performance benefit.

iirc there wasn't much for using separate partitions with the usual
user space benchmarks (SpecCPU etc.) on x86. It helped a bit on POWER
apparently though.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

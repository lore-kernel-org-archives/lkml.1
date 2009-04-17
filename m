Return-Path: <linux-kernel-owner+w=401wt.eu-S1761307AbZDQOQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761307AbZDQOQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759795AbZDQOQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:16:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49689 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbZDQOQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:16:23 -0400
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0904170941020.11877@qirst.com>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com>
	 <1239951613.23397.4107.camel@laptop>
	 <alpine.DEB.1.10.0904170941020.11877@qirst.com>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 16:16:16 +0200
Message-Id: <1239977776.23397.4590.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 09:42 -0400, Christoph Lameter wrote:
> On Fri, 17 Apr 2009, Peter Zijlstra wrote:
> 
> > This has never been true afaikt, as long as we have a task running, we
> > take the interrupt, I just looked at the .22 code and that certainly
> > expects the scheduler_tick() to be called when there is a running
> > process.
> >
> > Also, look at /proc/interrupts if you want to determine interrupt
> > frequency.
> 
> I am mainly interested in limited the number and length of cpu holdoffs.
> 
> If the timer interrupt is always taken then it must take less than 1 usec
> in certain versions of the kernel in order to not show up in the
> statistics gathered.

Such a test as you had is pretty useless for anything. 

If you want to measure something I'd suggest making a histogram of tsc
values in 10ns buckets or something, and seeing if there are a few
predominant spikes above the noise.

With something like that you could say, the jiffy tick went from 0.8+-.1
to 1.1+-.1 us or somesuch.

After that, you could possibly use oprofile or readprofile or
perf-counters to get an idea where the time is spend. I did a quick
profile on one of my machines, and about half the kernel time spend in a
while(1) loop comes from __do_softirq().

Really, I should not have to tell you this...


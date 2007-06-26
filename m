Return-Path: <linux-kernel-owner+w=401wt.eu-S1758443AbXFZRQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbXFZRQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 13:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757029AbXFZRP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 13:15:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59789 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756678AbXFZRP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 13:15:57 -0400
Date: Tue, 26 Jun 2007 10:14:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
Message-Id: <20070626101440.8f9ab65b.akpm@linux-foundation.org>
In-Reply-To: <20070626152629.GA3342@elte.hu>
References: <20070625200601.GA18980@elte.hu>
	<200706252309.47467.zippel@linux-m68k.org>
	<20070625151508.86fa3778.akpm@linux-foundation.org>
	<20070626152629.GA3342@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 17:26:29 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > > the patch improves the sysbench OLTP macrobenchmark significantly:
> > > 
> > > Has that any real practical relevance?
> > 
> > Interesting question. [...]
> 
> i'm missing the <sarcastic> tag i guess ;-)
> 
> <sarcastic> Oh my, does database macro-performance have any relevance to 
> Linux bread and butter markets in general. Boggle, it is a really 
> difficult question i suspect. </sarcastic>
> 
> If we ignore those few million database and web server Linux boxes on
> the market and concentrate purely on the few m68k boxes that are still
> in existance, _then_ we might be doubtful about this question ;-)

On my machine, time(2) doesn't do any syscall at all - it uses the vsyscall
page.  I'd be surprised if a database uses sys_time() either.

> > [...] The patch adds a new test-n-branch to gettimeofday() so if 
> > gettimeofday() is used much more frequently than time(), we lose.
> 
> given that the cost to sys_gettimeofday() is less than a cycle (we test
> a value already in a register, with an unlikely hint), and the benefit
> to sys_time() is around 6000 cycles (or more), sys_gettimeofday() would
> have to be used thousands of times more frequently than sys_time() -
> which it clearly isnt. As a test i just triggered a really X-intense
> workload and for that gettimeofday-dominated landscape there was still 1
> sys_time() call for every 50 gettimeofday calls - so it's a small win
> even for this X workload.

So something in X is somehow calling sys_time()?  How come, and is that an
outlier?  How generalisable is this observation?


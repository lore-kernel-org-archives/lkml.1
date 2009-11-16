Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbZKPSaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbZKPSaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 13:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbZKPSaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 13:30:05 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41941 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751458AbZKPSaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 13:30:04 -0500
Date: Mon, 16 Nov 2009 18:31:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Stijn Devriendt <highguy@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrea Arcangeli <andrea@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] observe and act upon workload parallelism:
 PERF_TYPE_PARALLELISM (Was: [RFC][PATCH] sched_wait_block: wait for blocked
 threads)
Message-ID: <20091116183117.48a02426@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0911160945470.9384@localhost.localdomain>
References: <1258311859-6189-1-git-send-email-HIGHGuY@gmail.com>
	<20091116083521.GC20672@elte.hu>
	<alpine.LFD.2.01.0911160945470.9384@localhost.localdomain>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Nov 2009 10:02:50 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 16 Nov 2009, Ingo Molnar wrote:
> > 
> > Regarding the API and your patch, i think we can and should do something 
> > different and more capable - while still keeping your basic idea:
> 
> Actually, I'd suggest exactly the reverse.
> 
> Yes, do something different, but _less_ capable, and much simpler: 
> introduce the notion of "grouped thread scheduling", where a _group_ of 
> threads gets scheduled as one thread.

And preferably expose it so it can be used by groups of processes as well
as just "threads" in the userspace shared pid etc sense. There are quite
a few applications where both "only run one of us" and "don't pre-empt
within the group" are a useful semantic (you often don't want the
pre-empting within the group of threads because it messes up all the
improved locking opportunities). In particular the usual buzz locks don't
mix well with "only run one of us".

Alan

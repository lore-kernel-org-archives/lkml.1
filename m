Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbXA1T3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbXA1T3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 14:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932772AbXA1T3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 14:29:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42795 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbXA1T3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 14:29:04 -0500
Date: Sun, 28 Jan 2007 20:26:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@hill9.org>
Subject: Re: lockmeter
Message-ID: <20070128192634.GA25370@elte.hu>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128144325.GB16552@infradead.org> <20070128152404.GB9196@elte.hu> <45BCD4C9.2030302@mbligh.org> <20070128170407.GA1526@infradead.org> <45BCDF88.2020504@mbligh.org> <20070128180132.GA1647@gnuppy.monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128180132.GA1647@gnuppy.monkey.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bill Huey <billh@gnuppy.monkey.org> wrote:

> > ISTR we still thought dcache scalability was a significant problem 
> > last time anyone looked at it seriously - just never got fixed. 
> > Dipankar?
> 
> My lock stat stuff shows dcache to a be a problem under -rt as well. 
> [...]

yeah, it shows up frequently, but it's hard to fix.

for a well-cached kernel rebuild on a system with lots of RAM and lots 
of CPUs, files_lock is the leading lock. (because the dcache is mostly 
populated already) files_lock is even more of a problem for workloads 
that do lots of open()/close() [Apache comes to mind].

	Ingo

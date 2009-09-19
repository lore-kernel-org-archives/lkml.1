Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbZISIGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbZISIGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 04:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbZISIGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 04:06:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35654 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbZISIGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 04:06:15 -0400
Date: Sat, 19 Sep 2009 10:06:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ian Schram <ischram@telenet.be>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xiaoguangrong@cn.fujitsu.com, Paul Mackerras <paulus@samba.org>
Subject: Re: perf_copy_attr pointer arithmetic weirdness
Message-ID: <20090919080609.GA10748@elte.hu>
References: <4AB3DEE2.3030600@telenet.be> <1253303868.10538.60.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253303868.10538.60.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2009-09-18 at 21:26 +0200, Ian Schram wrote:
> > There is some -to me at least- weird code in per_copy_attr. Which supposedly
> > checks that all bytes trailing a struct are zero.
> > 
> > It doesn't seem to get pointer arithmetic right. Since it increments
> > an iterating pointer by sizeof(unsigned long) rather than 1.
> > 
> > I believe this has an impact on the exploitability of the recent buffer overflow
> > in the perf_copy_attr function. I'm pretty sure I'm not the only one who noticed
> > this, but i couldn't find it being mentioned. For some reason people prefer
> > mmaping something at zero these days?
> > 
> > I have appended a patch locating the issue. The PTR_ALIGN stuff right above it
> > doesn't seem to take any boundary conditions into account which is probably not
> > a good thing either.
> 
> sizeof(struct perf_counter_attr) should always be a multiple of u64, and
> we can indeed read beyond the tail boundary, but that should be ok,
> worst that can happen is that we fail the read..
> 
> Ugh on the ptr arith, one wonders how many stupid bugs one can make in
> such a piece of code... :/
> 
> > signed-of-by Ian Schram <ischram@telenet.be>
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Ian, you meant Signed-off-by, not signed-of-by, right?

	Ingo

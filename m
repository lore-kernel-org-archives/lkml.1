Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbZGGPlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbZGGPlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbZGGPlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:41:18 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:20635 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbZGGPlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:41:17 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/3] Increase lockdep limits: MAX_LOCK_DEPTH
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <a5d9929e0907070836s1d75d874p65323b1b62eb63c3@mail.gmail.com>
References: <a5d9929e0907070825q41de40eeo5e337a4885615909@mail.gmail.com>
	 <1246980592.9777.0.camel@twins>
	 <a5d9929e0907070836s1d75d874p65323b1b62eb63c3@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 17:41:12 +0200
Message-Id: <1246981272.9777.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: Because we read from top to bottom, left to right.
Q: Why should I start my reply below the quoted text?

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?   

A: The lost context.
Q: What makes top-posted replies harder to read than bottom-posted?


On Tue, 2009-07-07 at 16:36 +0100, Joao Correia wrote:

> On Tue, Jul 7, 2009 at 4:29 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> > On Tue, 2009-07-07 at 16:25 +0100, Joao Correia wrote:
> >> (Applies to current Linus tree, as of 2.6.31-rc2)
> >>
> >> As a result of increasing MAX_STACK_TRACE_ENTRIES on the previous
> >> patch, another limit surfaced as being hit too soon.
> >> This patch increases MAX_LOCK_DEPTH, being hit by false positives, and
> >> turning off the locking correctness validator.
> >>
> >> The new value is arbitrary, but I believe the old one was too. Given
> >> the amount of changes happening with regards to the usage of lockdep,
> >> the previous limit is just too low and keeping it that way would
> >> defeat the purpose of lockdep.
> >>
> >>
> >> Signed-off-by: Joao Correia <joaomiguelcorreia@gmail.com>
> >
> > NAK, find the site that triggers this and fix it. holding more than 48
> > locks at any one time is silly.

> Im running into this in places as diverse as modprobe, swapper, udevd 
> and ip6tables-restore. It doesnt happen always on the same one, and
> the stack traces dont point to an (apparent) common point, hence me
> flagging this as a limit that is just being triggered due to increased
> lockdep usage.

This particular one will only trigger on the sites where you do indeed
hold >48 locks. If that triggers on multiple sites we really have a
problem.

> >> ---
> >>  include/linux/sched.h |    2 +-
> >>  1 files changes, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/include/linux/sched.h b/include/linux/sched.h
> >> index 0085d75..304231b 100644
> >> --- a/include/linux/sched.h
> >> +++ b/include/linux/sched.h
> >> @@ -1367,7 +1367,7 @@ struct task_struct {
> >>         int softirq_context;
> >>  #endif
> >>  #ifdef CONFIG_LOCKDEP
> >> -# define MAX_LOCK_DEPTH 48UL
> >> +# define MAX_LOCK_DEPTH 96UL
> >>         u64 curr_chain_key;
> >>         int lockdep_depth;
> >>         unsigned int lockdep_recursion;
> >> ---
> >
> >


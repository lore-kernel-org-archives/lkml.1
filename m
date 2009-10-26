Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbZJZFIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbZJZFIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 01:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbZJZFIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 01:08:53 -0400
Received: from mail.gmx.net ([213.165.64.20]:36997 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754188AbZJZFIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 01:08:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/IjPN057HI0Lfl81J7Q4SVsKD/5BeQkKHO9PGQPD
	c3b4XjgIZ+QHOS
Subject: Re: [PATCH 3/3] sched: Disable affine wakeups by default
From: Mike Galbraith <efault@gmx.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091025215225.05ac9ac9@infradead.org>
References: <20091024125853.35143117@infradead.org>
	 <20091024130432.0c46ef27@infradead.org>
	 <20091024130728.051c4d7c@infradead.org>
	 <1256453725.12138.40.camel@marge.simson.net>
	 <20091025095109.449bac9e@infradead.org>
	 <1256492289.14241.40.camel@marge.simson.net>
	 <20091025123319.2b76bf69@infradead.org>
	 <1256508287.17306.14.camel@marge.simson.net>
	 <1256522035.7356.19.camel@laptop>
	 <1256531907.7117.31.camel@marge.simson.net>
	 <20091025215225.05ac9ac9@infradead.org>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 06:08:54 +0100
Message-Id: <1256533734.7117.45.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-25 at 21:52 -0700, Arjan van de Ven wrote:
> On Mon, 26 Oct 2009 05:38:27 +0100
> Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Mon, 2009-10-26 at 02:53 +0100, Peter Zijlstra wrote:
> > > On Sun, 2009-10-25 at 23:04 +0100, Mike Galbraith wrote:
> > > >                 if (want_affine && (tmp->flags & SD_WAKE_AFFINE)
> > > > &&
> > > > -                   cpumask_test_cpu(prev_cpu,
> > > > sched_domain_span(tmp))) {
> > > > +                               (level == SD_LV_SIBLING || level
> > > > == SD_LV_MC)) {
> > > 
> > > quick comment without actually having looked at the patch, we should
> > > really get rid of sd->level and encode properties of the sched
> > > domains in sd->flags.
> > 
> > Yeah, sounds right, while writing that, it looked kinda ugly.  I
> > suppose arch land needs to encode cache property somehow if I really
> > want to be able to target cache on multicore.  Booting becomes..
> > exciting when I tinker down there.
> 
> or we just use SD_WAKE_AFFINE / SD_BALANCE_WAKE for this...

I don't see how.  Oh, you mean another domain level, top level being
cache property, and turn off when degenerating?  That looks like it'd be
a problem, but adding SD_CACHE_SIBLING or whatnot should work.  Problem
is how to gain knowledge of whether multicores share a cache or not.

	-Mike


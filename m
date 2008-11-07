Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbYKGVsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbYKGVsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 16:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYKGVsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 16:48:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56150 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYKGVsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 16:48:13 -0500
Subject: Re: 2.6.26.6-rt11: BUGs (sleeping function called from invalid
	context)
From: Peter Zijlstra <peterz@infradead.org>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1226093710.20569.23.camel@localhost.localdomain>
References: <1226083858.20569.14.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0811071400570.3711@gandalf.stny.rr.com>
	 <1226085407.31966.58.camel@lappy.programming.kicks-ass.net>
	 <1226093710.20569.23.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 22:47:51 +0100
Message-Id: <1226094472.31966.93.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 13:35 -0800, Fernando Lopez-Lezcano wrote:
> On Fri, 2008-11-07 at 20:16 +0100, Peter Zijlstra wrote:
> > On Fri, 2008-11-07 at 14:01 -0500, Steven Rostedt wrote:
> > > Peter, I think we've seen this before. It is the highmem code sleeping.
> > 
> > I've been working on an alternative kmap_atomic implementation for -rt,
> > the below has been build and booted but not stressed, anybody care to
> > give it a spin ?
> 
> I'll give it a try. Anything in particular I should try to do? Or not
> do? Or watch for?

Lots of I/O should stress the i386 highmem stuff. If all is well it
works, if not, crashes and splats.

> -- Fernando
> 
> 
> > ---
> >  arch/x86/mm/highmem_32.c  |  130 ++++++++++++++++++++++++++++++++++++++++++---
> >  include/asm-x86/highmem.h |   11 ----
> >  include/linux/sched.h     |    5 ++
> >  kernel/sched.c            |   10 ++++
> >  4 files changed, 137 insertions(+), 19 deletions(-)
> >  [MUNCH]
> 
> 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbZGHMzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbZGHMzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 08:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbZGHMz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 08:55:29 -0400
Received: from ru.mvista.com ([213.79.90.228]:46106 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750718AbZGHMz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 08:55:29 -0400
Date: Wed, 8 Jul 2009 16:55:27 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] sched: Remove SYSTEM_RUNNING checks from
 cond_resched*()
Message-ID: <20090708125527.GA11963@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090707235812.GA12824@oksana.dev.rtsoft.ru>
 <20090708005000.GA12380@redhat.com>
 <1247034263.9777.24.camel@twins>
 <20090708120302.GA6341@oksana.dev.rtsoft.ru>
 <1247055145.9777.52.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1247055145.9777.52.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 02:12:25PM +0200, Peter Zijlstra wrote:
> On Wed, 2009-07-08 at 16:03 +0400, Anton Vorontsov wrote:
> > On Wed, Jul 08, 2009 at 08:24:23AM +0200, Peter Zijlstra wrote:
> > > On Wed, 2009-07-08 at 02:50 +0200, Oleg Nesterov wrote:
> > > 
> > > > 	/*
> > > > 	 * It is valid to assume CPU-locality during early bootup:
> > > > 	 */
> > > > 	if (system_state != SYSTEM_RUNNING)
> > > > 		goto out;
> > > > 
> > > > this doesn't look right, smp_init() is called before we set
> > > > SYSTEM_RUNNING.
> > > 
> > > The thing is, there's also ton's of code that might end up calling
> > > cond_resched() and co before the scheduler is fully initialized.
> > 
> > Hm. Speaking of cond_resched*() only, then it should be pretty
> > safe to convert the SYSTEM_RUNNING checks to scheduler_running,
> > no? scheduler_running is set after sched_init().
> 
> Hmm, that might work, I'd have to audit sched_init_smp() as it seems to
> do way too much...

sched_init_smp() is called from the kernel_thread(), so
if the scheduler is not functional prior to kernel_thread(),
you're in trouble anyway, no? The point is that a lot of
code is calling schedule() prior to sched_init_smp()
(e.g. msleep(), mutexes), and there are no issues. So
should be no issues with cond_resched()?

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

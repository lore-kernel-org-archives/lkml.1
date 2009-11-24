Return-Path: <linux-kernel-owner+w=401wt.eu-S933818AbZKXS1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933818AbZKXS1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933754AbZKXS1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:27:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34793 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055AbZKXS1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:27:22 -0500
Subject: Re: [patch] sched: fix b5d9d734 blunder in task_new_fair()
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259086901.15249.121.camel@marge.simson.net>
References: <1258891664.14325.30.camel@marge.simson.net>
	 <1259070683.4531.1476.camel@laptop>
	 <1259082449.15249.90.camel@marge.simson.net>
	 <1259084140.4531.1710.camel@laptop>  <1259085280.4531.1730.camel@laptop>
	 <1259086901.15249.121.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 19:27:25 +0100
Message-ID: <1259087245.4531.1767.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 19:21 +0100, Mike Galbraith wrote:
> On Tue, 2009-11-24 at 18:54 +0100, Peter Zijlstra wrote:
> > On Tue, 2009-11-24 at 18:35 +0100, Peter Zijlstra wrote:
> > > On Tue, 2009-11-24 at 18:07 +0100, Mike Galbraith wrote:
> > > > >       if (p->sched_class->task_new) {
> > > > >               /* can detect migration through: task_cpu(p) != smp_processor_id() */
> > > > 
> > > > What if the parent was migrated before we got here?
> > > 
> > > Well, the only case it really matters for is the child_runs_first crap,
> > > which is basically broken on SMP anyway, so I don't think we care too
> > > much if we race here.
> > > 
> > > Unless I missed some detail that is ;-)
> > 
> > 
> > Also, we're running all this from the parent context, and we have
> > preemption disabled, we're not going anywhere.
> 
> In sched_fork() and wake_up_new_process(), but in between?

Hmm, right, back to the previous argument then ;-)


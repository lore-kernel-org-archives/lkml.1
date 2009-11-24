Return-Path: <linux-kernel-owner+w=401wt.eu-S933714AbZKXRyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714AbZKXRyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 12:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933553AbZKXRyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 12:54:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668AbZKXRym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 12:54:42 -0500
Subject: Re: [patch] sched: fix b5d9d734 blunder in task_new_fair()
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259084140.4531.1710.camel@laptop>
References: <1258891664.14325.30.camel@marge.simson.net>
	 <1259070683.4531.1476.camel@laptop>
	 <1259082449.15249.90.camel@marge.simson.net>
	 <1259084140.4531.1710.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 18:54:40 +0100
Message-ID: <1259085280.4531.1730.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 18:35 +0100, Peter Zijlstra wrote:
> On Tue, 2009-11-24 at 18:07 +0100, Mike Galbraith wrote:
> > >       if (p->sched_class->task_new) {
> > >               /* can detect migration through: task_cpu(p) != smp_processor_id() */
> > 
> > What if the parent was migrated before we got here?
> 
> Well, the only case it really matters for is the child_runs_first crap,
> which is basically broken on SMP anyway, so I don't think we care too
> much if we race here.
> 
> Unless I missed some detail that is ;-)


Also, we're running all this from the parent context, and we have
preemption disabled, we're not going anywhere.


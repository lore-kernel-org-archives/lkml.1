Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbZIITsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbZIITsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 15:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbZIITsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 15:48:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51283 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbZIITst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 15:48:49 -0400
Date: Wed, 9 Sep 2009 21:48:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Theodore Tso <tytso@mit.edu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Turn off child_runs_first
Message-ID: <20090909194849.GA499@atrey.karlin.mff.cuni.cz>
References: <1252486344.28645.18.camel@marge.simson.net> <tip-2bba22c50b06abe9fd0d23933b1e64d35b419262@git.kernel.org> <20090909175724.GY22901@mit.edu> <20090909180856.GA7323@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909180856.GA7323@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > It hurts 'optimal' make -j<NR_CPUS> workloads as make jobs
> > > get preempted by child tasks, reducing parallelism.
> > 
> > Wasn't one of the reasons why we historically did child_runs_first 
> > was so that for fork/exit workloads, the child has a chance to 
> > exec the new process?  If the parent runs first, then more pages 
> > will probably need to be COW'ed.
> 
> That kind of workload should be using vfork() anyway, and be even 
> faster because it can avoid the fork overhead, right?

Well.. one should not have to update userspace to keep
performance.... and vfork is extremely ugly interface.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

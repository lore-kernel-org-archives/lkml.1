Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbZIIR56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbZIIR56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbZIIR55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:57:57 -0400
Received: from thunk.org ([69.25.196.29]:58544 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbZIIR55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:57:57 -0400
Date: Wed, 9 Sep 2009 13:57:24 -0400
From: Theodore Tso <tytso@mit.edu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Turn off child_runs_first
Message-ID: <20090909175724.GY22901@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, mingo@redhat.com,
	hpa@zytor.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
	efault@gmx.de, tglx@linutronix.de, mingo@elte.hu,
	linux-tip-commits@vger.kernel.org
References: <1252486344.28645.18.camel@marge.simson.net> <tip-2bba22c50b06abe9fd0d23933b1e64d35b419262@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-2bba22c50b06abe9fd0d23933b1e64d35b419262@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 03:37:07PM +0000, tip-bot for Mike Galbraith wrote:
> Commit-ID:  2bba22c50b06abe9fd0d23933b1e64d35b419262
> Gitweb:     http://git.kernel.org/tip/2bba22c50b06abe9fd0d23933b1e64d35b419262
> Author:     Mike Galbraith <efault@gmx.de>
> AuthorDate: Wed, 9 Sep 2009 15:41:37 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 9 Sep 2009 17:30:05 +0200
> 
> sched: Turn off child_runs_first
> 
> Set child_runs_first default to off.
> 
> It hurts 'optimal' make -j<NR_CPUS> workloads as make jobs
> get preempted by child tasks, reducing parallelism.

Wasn't one of the reasons why we historically did child_runs_first was
so that for fork/exit workloads, the child has a chance to exec the
new process?  If the parent runs first, then more pages will probably
need to be COW'ed.

					- Ted

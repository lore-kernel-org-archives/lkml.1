Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbZBKJ2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbZBKJ2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 04:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZBKJ15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 04:27:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35953 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbZBKJ1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 04:27:54 -0500
Date: Wed, 11 Feb 2009 10:27:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29-rc3: BUG: scheduling while atomic: udevd/917/0x10000100
Message-ID: <20090211092745.GB14265@elte.hu>
References: <19f34abd0902110009g4cdb1754na1cbf0acb6a93cce@mail.gmail.com> <20090211083217.GC21105@elte.hu> <1234342189.23438.113.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234342189.23438.113.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2009-02-11 at 09:32 +0100, Ingo Molnar wrote:
> 
> > There's a fourth possibility:
> > 
> >  - Given that it's udevd that does it - maybe we leaked a softirq preempt
> >    count in some rare sysfs file, and it did not get discovered until the
> >    next innocent piece of kernel code preempted?
> > 
> > But i thought lockdep would already warn if we exited a syscall with locks
> > held or with a preempt count elevated - Peter?
> 
> From a quick look it only checks task->lockdep_depth, in lockdep_sys_exit().

That could be broadened then i guess - there's never a good excuse for exiting a 
syscall with an elevated preempt count.

	Ingo

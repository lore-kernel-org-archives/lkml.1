Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbZBPV0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbZBPV0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbZBPVZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:25:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42735 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbZBPVZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:25:54 -0500
Date: Mon, 16 Feb 2009 22:22:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] generic-smp: remove single ipi fallback for
	smp_call_function_many()
Message-ID: <20090216212221.GA8048@redhat.com>
References: <20090216163847.431174825@chello.nl> <20090216164114.433430761@chello.nl> <20090216191008.GA1521@redhat.com> <1234813292.30178.327.camel@laptop> <20090216203055.GA5135@redhat.com> <1234817701.30178.380.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234817701.30178.380.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Peter Zijlstra wrote:
>
> On Mon, 2009-02-16 at 21:30 +0100, Oleg Nesterov wrote:
> >
> > Yes I see. But if we change generic_smp_call_function_interrupt() to
> > re-check cpumask_test_cpu(cpu, data->cpumask) under data->lock then
> > we don't have to wait for quiescent state, afaics. And we have to
> > take this lock anyway.
>
> Suppose entries A,B,C,D are queued, and some cpu1 is traversing the list
> to execute C and is currently at B waiting for data->lock. Concurrently
> cpu2 has completed B and removes it from the list, when cpu3 takes B and
> inserts it at the end.

Ah indeed, I see. Thanks Peter.

Oleg.


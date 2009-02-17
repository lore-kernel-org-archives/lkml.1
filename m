Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZBQUsC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZBQUsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 15:48:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbZBQUrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 15:47:53 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35849 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbZBQUrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 15:47:52 -0500
Date: Tue, 17 Feb 2009 21:44:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v4] generic-ipi: remove kmalloc()
Message-ID: <20090217204436.GA10050@redhat.com>
References: <20090216163847.431174825@chello.nl> <20090216164114.433430761@chello.nl> <1234885258.4744.153.camel@laptop> <20090217172113.GA26459@redhat.com> <1234892420.4744.158.camel@laptop> <1234898958.4744.225.camel@laptop> <20090217200247.GA8158@redhat.com> <1234901512.4744.230.camel@laptop> <1234901777.4744.233.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234901777.4744.233.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17, Peter Zijlstra wrote:
>
> On Tue, 2009-02-17 at 21:11 +0100, Peter Zijlstra wrote:
> >
> > > As for the previous version. I am almost sure I missed something
> > > again, but do we really need both CSD_FLAG_WAIT and CSD_FLAG_LOCK
> > > flags? smp_call_function_many(wait => 1) can just wait for
> > > !CSD_FLAG_LOCK.
> >
> > I suppose we can.
>
> Ah, no, that would mean we cannot distinguish between the sync and async
> case in generic_exec_single().

Yes, generic_exec_single() needs the "bool wait" argument, it can't
use (data->flags & CSD_SINGLE_FLAG) as "should we wait or not".

In any case, even if this change is worthwhile it needs a separate
patch, please forget for now.

Oleg.


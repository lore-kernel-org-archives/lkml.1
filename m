Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZBQUQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZBQUQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 15:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZBQUQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 15:16:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:51833 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbZBQUQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 15:16:34 -0500
Subject: Re: [PATCH -v4] generic-ipi: remove kmalloc()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1234901512.4744.230.camel@laptop>
References: <20090216163847.431174825@chello.nl>
	 <20090216164114.433430761@chello.nl> <1234885258.4744.153.camel@laptop>
	 <20090217172113.GA26459@redhat.com> <1234892420.4744.158.camel@laptop>
	 <1234898958.4744.225.camel@laptop>  <20090217200247.GA8158@redhat.com>
	 <1234901512.4744.230.camel@laptop>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 21:16:17 +0100
Message-Id: <1234901777.4744.233.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 21:11 +0100, Peter Zijlstra wrote:
> 
> > As for the previous version. I am almost sure I missed something
> > again, but do we really need both CSD_FLAG_WAIT and CSD_FLAG_LOCK
> > flags? smp_call_function_many(wait => 1) can just wait for
> > !CSD_FLAG_LOCK.
> 
> I suppose we can.

Ah, no, that would mean we cannot distinguish between the sync and async
case in generic_exec_single().


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbZBRQGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbZBRQGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 11:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbZBRQG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 11:06:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59344 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbZBRQG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:06:26 -0500
Date: Wed, 18 Feb 2009 17:05:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/4] generic-smp: remove kmalloc usage
Message-ID: <20090218160535.GD23989@elte.hu>
References: <20090216163847.431174825@chello.nl> <1234859071.4744.10.camel@laptop> <20090217094359.GA1231@elte.hu> <200902181520.17504.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902181520.17504.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Tuesday 17 February 2009 20:13:59 Ingo Molnar wrote:
> > We should not bend backwards trying to preserve that kmalloc() 
> > [and prove that it's safe and race-free] - i.e. the burden of 
> > proof is on the person insisting that it's needed, not on the 
> > person wanting to remove it.
> 
> Respectfully disagree.  The kmalloc has been there for a very long time,
> and doing fine AFAICT.

The kmalloc(GFP_ATOMIC) has been in kernel/smp.c for about half 
a year, since:

 |  commit 3d4422332711ef48ef0f132f1fcbfcbd56c7f3d1
 |  Author: Jens Axboe <jens.axboe@oracle.com>
 |  Date:   Thu Jun 26 11:21:34 2008 +0200
 |  Subject: [PATCH] Add generic helpers for arch IPI function calls

Which introduced kernel/smp.c to begin with. It got merged on 
July 15.

The precedecessor mechanism, smp_call_function*() on x86, used 
an on-kernel-stack buffer (and a half-wait mechanism), even in 
the async case, not a kmalloc().

I'm not sure where the "kmalloc has been there for a very long 
time" statement comes from. Are we talking about the same thing?

	Ingo

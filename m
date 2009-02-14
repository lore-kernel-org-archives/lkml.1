Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbZBNVRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbZBNVRX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbZBNVOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:14:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:46193 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbZBNVOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:14:41 -0500
Subject: Re: [PATCH 1.5/2] generic-smp: fix initial quiesent count.
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <1234622792.4698.31.camel@laptop>
References: <20090212223200.979433820@chello.nl>
	 <20090212223750.295581470@chello.nl>  <1234622474.4698.25.camel@laptop>
	 <1234622792.4698.31.camel@laptop>
Content-Type: text/plain
Date: Sat, 14 Feb 2009 22:14:16 +0100
Message-Id: <1234646056.4695.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-14 at 15:46 +0100, Peter Zijlstra wrote:
> first compile, then send out...
> 
> ---
> Subject: generic-smp: fix initial quiesent count.
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Sat Feb 14 15:36:07 CET 2009
> 
> If we start with a quiesent sequence count of 0, we'll match the initial stamp
> values of the cfd_data, and never make any progress.
> 
> To avoid getting stuck in this situation, start out with an increased quiesent
> sequence count.

OK, so this is not going to fix the problem in generic. Its still
possible to end up with the original issue.

We'd need a callback list to free used entries, much like regular RCU,
this quiesent sequence count's wrapping just seems too brittle.



Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbZC2JZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbZC2JZO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 05:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbZC2JY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 05:24:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:33050 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbZC2JY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 05:24:59 -0400
Subject: Re: [PATCH 1/9] perf_counter: unify and fix delayed counter wakeup
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Eric Dumazet <dada1@cosmosbay.com>
In-Reply-To: <1238318201.23852.17.camel@twins>
References: <20090328194359.426029037@chello.nl>
	 <20090328194929.451591360@chello.nl>
	 <18894.48499.125187.92480@cargo.ozlabs.ibm.com>
	 <1238318201.23852.17.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 29 Mar 2009 11:25:10 +0200
Message-Id: <1238318710.23852.38.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-29 at 11:16 +0200, Peter Zijlstra wrote:
> On Sun, 2009-03-29 at 11:14 +1100, Paul Mackerras wrote:
> > Peter Zijlstra writes:
> > 
> > > While going over the wakeup code I noticed delayed wakeups only work
> > > for hardware counters but basically all software counters rely on
> > > them.
> > 
> > Hmmm, I don't like the extra latency this introduces, particularly
> > since on powerpc we already have a good way to avoid the latency.
> 
> Right, so I can re-instate the powerpc bits and have it call
> perf_counter_do_pending() whenever it finds the per-cpu pending bit set.
> 
> I'd have to look into the fancy new per-cpu stuff for the x86 bits, but
> I'm reasonably sure something like that should be doable.

In a perfect world, I'd introduce a self-ipi on UP and use that. Also,
in that same perfect world, all arches would support cmpxchg()/xchg() so
we could put the whole thing in generic code.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762403AbZFQXYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762403AbZFQXYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758189AbZFQXYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:24:10 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:46563 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758056AbZFQXYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:24:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19001.31402.236289.767105@cargo.ozlabs.ibm.com>
Date: Thu, 18 Jun 2009 09:22:18 +1000
From: Paul Mackerras <paulus@samba.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>, benh@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] perf_counter: powerpc: Enable use of software counters on 32-bit powerpc
In-Reply-To: <A731338A-E954-46D9-8BF7-6E74C797209C@kernel.crashing.org>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
	<A731338A-E954-46D9-8BF7-6E74C797209C@kernel.crashing.org>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala writes:

> On Jun 17, 2009, at 6:50 AM, Paul Mackerras wrote:

> > +config PPC_HAVE_PMU_SUPPORT
> > +       bool
> 
> what does this mean?

At the moment it means that arch/powerpc/kernel/perf_counters.c works
for at least some processors in the selected processor family.

> > +
> > +config PPC_PERF_CTRS
> > +       def_bool y
> > +       depends on PERF_COUNTERS && PPC_HAVE_PMU_SUPPORT
> > +       help
> > +         This enables the powerpc-specific perf_counter back-end.
> 
> Can we distinguish between the two different architected perf counters  
> programming models to start with.  Maybe something like:
> 
> PPC_BOOK3S_PERF_CTRS and PPC_BOOK3E_PERF_CTRS (or  
> PPC_SERVER_PERF_CTRS / PPC_EMB_PERF_CTRS)

We can do that once we have code to support the Freescale embedded PMU
and we know how much of arch/powerpc/kernel/perf_counters.c is or
isn't useful there.  We don't have to get to the final state in one
patch.  I'd rather put this patch in as-is and then see a patch series
that adds the Freescale embedded PMU support and makes whatever
Kconfig changes are necessary later.

Paul.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbZENJrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbZENJrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 05:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZENJrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 05:47:15 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:55155 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbZENJrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 05:47:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18955.59546.713452.302649@cargo.ozlabs.ibm.com>
Date: Thu, 14 May 2009 19:47:06 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/3] perf_counter: allow arch to supply event misc
 flags and instruction pointer
In-Reply-To: <1242283534.26820.42.camel@twins>
References: <18955.36913.304477.712583@drongo.ozlabs.ibm.com>
	<1242283534.26820.42.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> On Thu, 2009-05-14 at 13:29 +1000, Paul Mackerras wrote:

> >  #define PERF_EVENT_MISC_KERNEL		(1 << 0)
> >  #define PERF_EVENT_MISC_USER		(1 << 1)
> >  #define PERF_EVENT_MISC_OVERFLOW	(1 << 2)
> > +#define PERF_EVENT_MISC_HYPERVISOR	(1 << 3)
> 
> Ah, I think I've taught userspace that either !USER && !KERNEL or USER
> && KERNEL is HV information, since neither really makes sense :-)

OK, should we do something like this?

#define PERF_EVENT_MISC_CPUMODE_MASK	(3 << 0)
#define PERF_EVENT_MISC_CPUMODE_UNKNOWN	(0 << 0)
#define PERF_EVENT_MISC_USER		(1 << 0)
#define PERF_EVENT_MISC_KERNEL		(2 << 0)
#define PERF_EVENT_MISC_HYPERVISOR	(3 << 0)

Paul.

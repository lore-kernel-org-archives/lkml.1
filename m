Return-Path: <linux-kernel-owner+w=401wt.eu-S1760782AbZDCIv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782AbZDCIv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 04:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbZDCIvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 04:51:19 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:57806 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZDCIvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 04:51:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18901.52735.579687.568717@cargo.ozlabs.ibm.com>
Date: Fri, 3 Apr 2009 19:51:11 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: perf_counter: request for three more sample data options
In-Reply-To: <1238745077.798.17.camel@twins>
References: <49D56A7E.80908@linux.vnet.ibm.com>
	<1238742064.798.8.camel@twins>
	<49D5B9E7.1020400@linux.vnet.ibm.com>
	<1238745077.798.17.camel@twins>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> What I was thinking of was re-using some of the cpu_clock()
> infrastructure. That provides us with a jiffy based GTOD sample,
> cpu_clock() then uses TSC and a few filters to compute a current
> timestamp.
> 
> I was thinking about cutting back those filters and thus trusting the
> TSC more -- which on x86 can do any random odd thing. So provided the
> TSC is not doing funny the results will be ok-ish.
> 
> This does mean however, that its not possible to know when its gone bad.

I would expect that perfmon would be just reading the TSC and
recording that.  If you can read the TSC and do some correction then
we're ahead. :)

> The question to Paul is, does the powerpc sched_clock() call work in NMI
> -- or hard irq disable -- context?

Yes - timekeeping is one area where us powerpc guys can be smug. :)
We have a per-core, 64-bit timebase register which counts at a
constant frequency and is synchronized across all cores.  So
sched_clock works in any context on powerpc - all it does is read the
timebase and do some simple integer arithmetic on it.

Paul.

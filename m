Return-Path: <linux-kernel-owner+w=401wt.eu-S1759835AbZF3AFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835AbZF3AFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 20:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbZF3AFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 20:05:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59899 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302AbZF3AFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 20:05:42 -0400
Date: Tue, 30 Jun 2009 02:05:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
Subject: Re: [numbers] perfmon/pfmon overhead of 17%-94%
Message-ID: <20090630000540.GC5869@elte.hu>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy> <20090624151010.GA12799@elte.hu> <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy> <Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy> <20090627060432.GB16200@elte.hu> <20090627064404.GA19368@elte.hu> <Pine.LNX.4.64.0906291354380.1404@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906291354380.1404@pianoman.cluster.toy>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vince@deater.net> wrote:

>> workloads? [ In fact in one of the scheduler-tests perfmon has a 
>> whopping measurement overhead of _nine billion_ cycles, it 
>> increased total runtime of the workload from 3.3 seconds to 6.6 
>> seconds. (!) ]
>
> I'm sure the perfmon2 people would welcome any patches you have to 
> fix this problem.

I think this flaw of perfmon is unfixable, because perfmon (by 
design) uses a _way_ too low level and way too opaque and 
structure-less abstraction for the PMU, which disallows the kind of 
high-level optimizations that perfcounters can do.

We werent silent about this - to the contrary. Last November Thomas 
and me _did_ take a good look at perfmon patches (we are maintaining 
the code areas affected by perfmon), we saw that it has unfixable 
problems and came up with objections and later on came up with 
patches that fix these problems: the perfcounters subsystem.

>> That's an about 94% measurement overhead, or about 9.2 _billion_ 
>> cycles overhead on this test-system.
>
> I'm more interested in very CPU-intensive benchmarks.  I ran some 
> experiments with gcc and equake from the spec2k benchmark suite.

The workloads i cited are _all_ 100% CPU-intensive benchmarks:

 - hackbench
 - loop-pipe-1-million

But i could add 'lat_tcp localhost', 'bw_tcp localhost' or sysbench 
to the list - all show very significant overhead under perfmon. 
These are all important workloads and important benchmarks. A kernel 
based performance analysis facility that is any good must handle 
them transparently.

	Ingo

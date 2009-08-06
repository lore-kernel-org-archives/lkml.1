Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbZHFQ7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbZHFQ7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 12:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbZHFQ7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 12:59:35 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:64580
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752833AbZHFQ7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 12:59:34 -0400
X-IronPort-AV: E=Sophos;i="4.43,334,1246831200"; 
   d="scan'208";a="32155241"
Message-ID: <4A7B0C02.7060704@inria.fr>
Date: Thu, 06 Aug 2009 18:59:46 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [perf] howto switch from pfmon
References: <4A3FEF75.2020804@inria.fr> <20090623131450.GA31519@elte.hu> <20090623134749.GA6897@elte.hu> <4A40DFF5.7010207@inria.fr> <20090623143601.GA13415@elte.hu> <4A40F31F.4030609@inria.fr> <20090629192913.GA29295@elte.hu>
In-Reply-To: <20090629192913.GA29295@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Update: based on your feedback the latest perfcounters tree includes 
> the following new perf record features:
>
>     -s, --stat            per thread counts
>     -n, --no-samples      don't sample
>
> --stat instructs the kernel to gather precise per task/thread stats 
> and emits those counts to the data file. Via --no-samples one can do 
> non-profiling runs - i.e. only statistics collection.
>
> The 'perf stat' pretty printing side is not fully implemented yet - 
> right now you can only see these stats if you look for 
> PERF_EVENT_READ counts in the raw event log:
>
>    perf report -D | grep PERF_EVENT_READ
>   

Ok I am getting remote/local accesses for my threads now. But I am not
sure which line corresponds to which event.

$ /mnt/scratch/bgoglin/cpunode/linux-2.6.31/tools/perf/perf record -f -s
-e r1000001e0 -e r1000002e0 -e r1000004e0 -e r1000008e0 ./stream
[...]
$ /mnt/scratch/bgoglin/cpunode/linux-2.6.31/tools/perf/perf report -D |
grep PERF_EVENT_READ
0x7cd0 [0x30]: PERF_EVENT_READ: 4651 4651 210827
0x7388 [0x30]: PERF_EVENT_READ: 4651 4651 241742
0x8cf0 [0x30]: PERF_EVENT_READ: 4651 4651 315938
0x9da0 [0x30]: PERF_EVENT_READ: 4651 4651 9461794
0x7208 [0x30]: PERF_EVENT_READ: 4651 4652 24954
0x8c90 [0x30]: PERF_EVENT_READ: 4651 4652 408056
0x7ca0 [0x30]: PERF_EVENT_READ: 4651 4652 8962423
0x9ce0 [0x30]: PERF_EVENT_READ: 4651 4652 9117
0x7df0 [0x30]: PERF_EVENT_READ: 4651 4653 21645
0x9d70 [0x30]: PERF_EVENT_READ: 4651 4653 23606
0x7358 [0x30]: PERF_EVENT_READ: 4651 4653 29266
0x8e70 [0x30]: PERF_EVENT_READ: 4651 4653 9339173
[...]

I can easily sort them by thread id, but I don't know how to match my 4
events with each group of 4 line.

Maybe perf report earned some better way to show per-thread statistics
in the meantime?

Brice


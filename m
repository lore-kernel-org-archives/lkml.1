Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbYLPReY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbYLPReY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 12:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbYLPReP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 12:34:15 -0500
Received: from smtpauth01.csee.onr.siteprotect.com ([64.26.60.145]:44945 "EHLO
	smtpauth01.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078AbYLPReP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 12:34:15 -0500
Date: Tue, 16 Dec 2008 12:38:59 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
Subject: Re: [patch] Performance Counters for Linux, v4
In-Reply-To: <20081214212829.GA9435@elte.hu>
Message-ID: <Pine.LNX.4.64.0812161232170.6249@pianoman.cluster.toy>
References: <20081214212829.GA9435@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm trying to evaluate this new proposal for the kind of workloads I use 
performance counters for, and even the simplest tests don't work.

I'm trying to do a simple aggragate count for some benchmarks here using 
timec and I'm getting poor results.

Are any of the problems I'm reporting going to be fixed?

In any case, I was testing aggregate counts on a longer running benchmark, 
this time equake from the spec2k benchmark suite, still on the q6600.

If I only count retired instructions, I get consistent results:

   timec -e 1

       119175255369  instructions         (events)
       119175255561  instructions         (events)
       119175255383  instructions         (events)


however the minute I add another count, say cycles so I can calculate 
CPI/IPC the results for instructions are suddenly off by 33%.

Needless to say, perfmon can handle reading both cycles and instructions 
at the same time.


   timec -e 0, -e 1
        91758816320  cycles               (events)
        79428247907  instructions         (events)

        91849140396  cycles               (events)
        79449560742  instructions         (events)


It gets worse when trying to look at cache statistics:

    timec -e 1 -e 2 -e 3

        59611457943  instructions         (events)
         1872499771  cache references     (events)
           97471971  cache misses         (events)

        59601907232  instructions         (events)
         1871766376  cache references     (events)
           97435199  cache misses         (events)

and so on

    timec -e1 -e2 -e3 -e4


        47671703285  instructions         (events)
         1498246999  cache references     (events)
           77838085  cache misses         (events)
         3394839360  branches             (events)

        47666131604  instructions         (events)
         1497069685  cache references     (events)
           78065325  cache misses         (events)
         3393244879  branches             (events)



So apparently this performance counter infrastructure will always be 
useless for trying to get plain aggregate counts?  It's the simplest case 
to get right, so it makes me wonder about the design of the rest of the 
infrastructure.

Vince

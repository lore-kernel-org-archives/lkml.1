Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbZHNCBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbZHNCBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 22:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbZHNCBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 22:01:34 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:41336 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbZHNCBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 22:01:33 -0400
Date: Fri, 14 Aug 2009 07:31:23 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "menage@google.com" <menage@google.com>, xemul@openvz.org,
       prarit@redhat.com, andi.kleen@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [UPDATED][PATCH][mmotm] Help Root Memory Cgroup Resource
	Counters Scale Better (v5)
Message-ID: <20090814020122.GL5087@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090813065504.GG5087@balbir.in.ibm.com> <20090813162640.fe2349e9.nishimura@mxp.nes.nec.co.jp> <20090813080206.GH5087@balbir.in.ibm.com> <20090813083524.GC21389@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090813083524.GC21389@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2009-08-13 10:35:24]:

> 
> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > Without Patch
> > 
> >  Performance counter stats for '/home/balbir/parallel_pagefault':
> > 
> >   5826093739340  cycles                   #    809.989 M/sec
> >    408883496292  instructions             #      0.070 IPC
> >      7057079452  cache-references         #      0.981 M/sec
> >      3036086243  cache-misses             #      0.422 M/sec
> 
> > With this patch applied
> > 
> >  Performance counter stats for '/home/balbir/parallel_pagefault':
> > 
> >   5957054385619  cycles                   #    828.333 M/sec
> >   1058117350365  instructions             #      0.178 IPC
> >      9161776218  cache-references         #      1.274 M/sec
> >      1920494280  cache-misses             #      0.267 M/sec
> 
> Nice how the instruction count and the IPC value incraesed, and the 
> cache-miss count decreased.
> 
> Btw., a 'perf stat' suggestion: you can also make use of built-in 
> error bars via repeating parallel_pagefault N times:
> 
>   aldebaran:~> perf stat --repeat 3 /bin/ls

Ingo, with the repeat experiements I see

7192354.545647  task-clock-msecs         #     23.955 CPUs    ( +- 0.002% )
         425627  context-switches         #      0.000 M/sec  ( +- 0.333% )
            155  CPU-migrations           #      0.000 M/sec  ( +- 10.897% )
       95336481  page-faults              #      0.013 M/sec  ( +- 0.085% )
  5951929070187  cycles                   #    827.536 M/sec  ( +- 0.009% )
  1058312583796  instructions             #      0.178 IPC    ( +- 0.076% )
     9616609083  cache-references         #      1.337 M/sec  ( +- 2.536% )
     1952367514  cache-misses             #      0.271 M/sec  ( +- 0.156% )

  300.246532761  seconds time elapsed   ( +-   0.002% )

Except for the CPU migrations and the cache references, all the other
parameters seem to be well within an acceptable error range.


-- 
	Balbir

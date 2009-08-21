Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbZHUCXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbZHUCXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 22:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZHUCXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 22:23:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50487 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbZHUCXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 22:23:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 21 Aug 2009 11:20:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Blanchard <anton@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       balbir@linux.vnet.ibm.com, Bharata B Rao <bharata@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       balajirrao@gmail.com, dhaval@linux.vnet.ibm.com, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [PATCH] better align percpu counter (Was Re: [tip:sched/core]
 sched: cpuacct: Use bigger percpu counter batch values for stats counters
Message-Id: <20090821112054.1e6bc4e6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090820100403.GB29093@elte.hu>
References: <20090512193656.D647.A69D9226@jp.fujitsu.com>
	<20090716081010.GB3134@in.ibm.com>
	<20090716083948.GA2950@kryten>
	<20090820051038.GF21100@kryten>
	<20090820052605.GC26265@balbir.in.ibm.com>
	<1250747579.8282.110.camel@twins>
	<20090820060528.GG21100@kryten>
	<20090820151017.2ba95d6e.kamezawa.hiroyu@jp.fujitsu.com>
	<20090820062451.GH21100@kryten>
	<20090820174123.afa43c48.kamezawa.hiroyu@jp.fujitsu.com>
	<20090820100403.GB29093@elte.hu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009 12:04:03 +0200
Ingo Molnar <mingo@elte.hu> wrote:
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > with your program
> > before patch.
> > cpuacct off : 414000-416000 ctsw per sec.
> > cpuacct on  : 401000-404000 ctsw per sec.
> > 
> > after patch
> > cpuacct on  : 412000-413000 ctsw per sec.
> > 
> > Maybe I should check cache-miss late ;)
> 
> Btw., in latest upstream you can do that via:
> 
>   cd tools/perf/
>   make -j install
> 
>   perf stat --repeat 5 -- taskset -c 1 ./context_switch
> 

tried. (on 8cpu/2socket host). It seems cache-miss decreases.
But IPC ..?
==
/root/bin/perf stat --repeat 5 -a -e cycles,instructions,cache-misses,L1-dcache-load-misses,L1-dcache-store-misses -- ./ctxt_sw.sh
[Before] patch
 Performance counter stats for './ctxt_sw.sh' (5 runs):

  1511260148530  cycles                     ( +-   0.025% )  (scaled from 63.49%             )
   470690642181  instructions             #      0.311 IPC     ( +-   0.098% )(scaled from 79.49%)
     1210051728  cache-misses               ( +-   0.629% )  (scaled from 79.00%             )
     3202978828  L1-dcache-load-misses      ( +-   1.118% )  (scaled from 78.00%             )
     1803963907  L1-dcache-store-misses     ( +-   0.728% )  (scaled from 42.99%             )

   60.161941918  seconds time elapsed   ( +-   0.029% )

[After] patch
 Performance counter stats for './ctxt_sw.sh' (5 runs):

  1511961867506  cycles                     ( +-   0.018% )  (scaled from 71.50%)
   448724406149  instructions             #      0.297 IPC     ( +-   0.133% )  (scaled from 75.49%)
     1184548041  cache-misses               ( +-   0.136% )  (scaled from 75.50%)
     3086357048  L1-dcache-load-misses      ( +-   0.822% )  (scaled from 77.50%)
     1708375493  L1-dcache-store-misses     ( +-   0.328% )  (scaled from 47.00%)

   60.179814774  seconds time elapsed   ( +-   0.052% )

Thanks,
-Kame


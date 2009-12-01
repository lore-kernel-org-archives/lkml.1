Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbZLAIyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbZLAIyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbZLAIyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:54:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:28425 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbZLAIys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:54:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,319,1257148800"; 
   d="scan'208";a="751668842"
From: "Ma, Ling" <ling.ma@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
CC: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 1 Dec 2009 16:54:04 +0800
Subject: RE: [PATCH RFC] [X86] Compile Option Os versus O2 on latest x86
 platform
Thread-Topic: [PATCH RFC] [X86] Compile Option Os versus O2 on latest x86
 platform
Thread-Index: AcpufcZ50tnLAtcuQOCCkylZXtVTkgD4mrag
Message-ID: <8FED46E8A9CA574792FC7AACAC38FE7714FED213BE@PDSMSX501.ccr.corp.intel.com>
References: <1259222752-8161-1-git-send-email-ling.ma@intel.com>
 <20091126094930.GD32275@elte.hu>
In-Reply-To: <20091126094930.GD32275@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo

Thanks for your correction, so we use perf stat --repeat 3 to test volano, tbench, and kbuild,
Because netperf has multiple items we may send out later.

volano_Os:

Performance counter stats for '/bm/bin/runs -t volano -r /bm/recipes/lkp-ne02.recipe' (3 runs):

 6386111.436735  task-clock-msecs         #     13.554 CPUs    ( +-   0.336% )
      914192633  context-switches         #      0.143 M/sec   ( +-   0.046% )
       49186605  CPU-migrations           #      0.008 M/sec   ( +-   0.962% )
         768344  page-faults              #      0.000 M/sec   ( +-   0.338% )
 18680627716893  cycles                   #   2925.196 M/sec   ( +-   0.339% )
  7247421283541  instructions             #      0.388 IPC     ( +-   0.124% )
   226838591574  cache-references         #     35.521 M/sec   ( +-   0.971% )
     9420427393  cache-misses             #      1.475 M/sec   ( +-   0.897% )

  471.172398867  seconds time elapsed   ( +-   1.292% )

volano_O2:

Performance counter stats for '/bm/bin/runs -t volano -r /bm/recipes/lkp-ne02.recipe' (3 runs):

 5873675.998422  task-clock-msecs         #     13.447 CPUs    ( +-   0.338% )
      916070728  context-switches         #      0.156 M/sec   ( +-   0.050% )
       48759104  CPU-migrations           #      0.008 M/sec   ( +-   0.614% )
         738964  page-faults              #      0.000 M/sec   ( +-   0.082% )
 17145170491943  cycles                   #   2918.985 M/sec   ( +-   0.288% )
  7324126478801  instructions             #      0.427 IPC     ( +-   0.090% )
   219064318074  cache-references         #     37.296 M/sec   ( +-   0.792% )
     9491237013  cache-misses             #      1.616 M/sec   ( +-   0.439% )

  436.806579899  seconds time elapsed   ( +-   0.392% )

O2 is better than Os for volano

tbench_Os:

Performance counter stats for '/bm/bin/runs -t tbench -r /bm/recipes/lkp-ne02.recipe' (3 runs):

 11630970.099215  task-clock-msecs         #     15.476 CPUs    ( +-   1.285% )
     1162148139  context-switches         #      0.100 M/sec   ( +-   0.372% )
          39772  CPU-migrations           #      0.000 M/sec   ( +-   0.502% )
        1536289  page-faults              #      0.000 M/sec   ( +-   0.020% )
 33408973681696  cycles                   #   2872.415 M/sec   ( +-   0.028% )
 14229765107716  instructions             #      0.426 IPC     ( +-   0.113% )
   290717607018  cache-references         #     24.995 M/sec   ( +-  10.425% )
     2525058529  cache-misses             #      0.217 M/sec   ( +-   1.798% )

  751.537009428  seconds time elapsed   ( +-   0.173% )

tbench_O2:

Performance counter stats for '/bm/bin/runs -t tbench -r /bm/recipes/lkp-ne02.recipe' (3 runs):

 12093825.537708  task-clock-msecs         #     16.084 CPUs    ( +-   6.363% )
     1235837814  context-switches         #      0.102 M/sec   ( +-   0.857% )
          42363  CPU-migrations           #      0.000 M/sec   ( +-   3.968% )
        1535481  page-faults              #      0.000 M/sec   ( +-   0.350% )
 33028312063911  cycles                   #   2731.006 M/sec   ( +-   0.908% )
 15535465986643  instructions             #      0.470 IPC     ( +-   0.058% )
   280118529329  cache-references         #     23.162 M/sec   ( +-   0.695% )
     2866275183  cache-misses             #      0.237 M/sec   ( +-   0.893% )

  751.921568581  seconds time elapsed   ( +-   0.182% )

O2 is not different with Os for tbench

kbuild_Os:

Performance counter stats for '/bm/bin/runs -t kbuild -r /bm/recipes/lkp-ne02.recipe' (3 runs):

  886426.102100  task-clock-msecs         #      1.053 CPUs    ( +-   1.712% )
         980944  context-switches         #      0.001 M/sec   ( +-   1.149% )
         285613  CPU-migrations           #      0.000 M/sec   ( +-   1.543% )
       81244856  page-faults              #      0.092 M/sec   ( +-   1.611% )
  2610381816839  cycles                   #   2944.839 M/sec   ( +-   1.696% )
  2907701964460  instructions             #      1.114 IPC     ( +-   1.726% )
    14758764510  cache-references         #     16.650 M/sec   ( +-   1.581% )
     3212068899  cache-misses             #      3.624 M/sec   ( +-   1.729% )

  841.492770793  seconds time elapsed   ( +-   0.209% )

kbuild_O2:

Performance counter stats for '/bm/bin/runs -t kbuild -r /bm/recipes/lkp-ne02.recipe' (3 runs):

  897281.428095  task-clock-msecs         #      1.062 CPUs    ( +-   0.524% )
         964812  context-switches         #      0.001 M/sec   ( +-   1.630% )
         287443  CPU-migrations           #      0.000 M/sec   ( +-   0.532% )
       82509345  page-faults              #      0.092 M/sec   ( +-   0.071% )
  2635837258275  cycles                   #   2937.581 M/sec   ( +-   0.150% )
  2955626723788  instructions             #      1.121 IPC     ( +-   0.117% )
    14939108242  cache-references         #     16.649 M/sec   ( +-   0.609% )
     3267365744  cache-misses             #      3.641 M/sec   ( +-   0.066% )

  844.891541856  seconds time elapsed   ( +-   0.468% )
O2 is not different with Os for kbuild 

Thanks
Ling

> -----Original Message-----
> From: Ingo Molnar [mailto:mingo@elte.hu]
> Sent: Thursday, November 26, 2009 5:50 PM
> To: Ma, Ling; Arjan van de Ven; Dave Jones
> Cc: hpa@zytor.com; tglx@linutronix.de; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH RFC] [X86] Compile Option Os versus O2 on latest x86
> platform
> 
> 
> * ling.ma@intel.com <ling.ma@intel.com> wrote:
> 
> > Benchmarks:                          improvement
> > volano                                8%
> > netperf                               6.7%
> > tbench                                6.45%
> > Kbuild                                5.5% (3 time test, average
> improvement)
> 
> that Kbuild result looks suspicious. A kbuild only uses 25% of system
> time, so an 5.5% improvement means that system utilization dropped from
> 25% to 19.5%, a 28% improvement in the kernel! That looks rather
> unlikely.
> 
> Could you please post before/after 'perf stat --repeat 3' results so
> that we can see the noise level?
> 
> Thanks,
> 
> 	Ingo

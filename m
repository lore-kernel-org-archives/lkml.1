Return-Path: <linux-kernel-owner+w=401wt.eu-S932576AbZHLK4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576AbZHLK4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 06:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932480AbZHLK4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 06:56:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48742 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932472AbZHLK4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 06:56:04 -0400
Message-ID: <4A829F1B.4060205@redhat.com>
Date: Wed, 12 Aug 2009 06:53:15 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyu@jp.fujitsu.com,
       nishimura@mxp.nes.nec.co.jp, kosaki.motohiro@jp.fujitsu.com,
       menage@google.com, andi.kleen@intel.com, xemul@openvz.org,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Help Resource Counters Scale better (v4.1)
References: <20090811144405.GW7176@balbir.in.ibm.com> <20090811163159.ddc5f5fd.akpm@linux-foundation.org> <20090812045716.GH7176@balbir.in.ibm.com>
In-Reply-To: <20090812045716.GH7176@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Balbir Singh wrote:
> Hi, Andrew,
>
> Does this look better, could you please replace the older patch with
> this one.
>
> 1. I did a quick compile test
> 2. Ran scripts/checkpatch.pl
>
>
>   

Andi Kleen suggested I use kernbench to profile the kernel.

2.6.31-rc5-git2 w/ CONFIG_RESOURCE_COUNTERS on

Tue Aug 11 13:45:14 EDT 2009
2.6.31-rc5-git2-resources
Average Half load -j 32 Run (std deviation):
Elapsed Time 622.588 (119.243)
User Time 4820.8 (962.286)
System Time 9807.63 (2669.55)
Percent CPU 2324 (167.236)
Context Switches 2009606 (368703)
Sleeps 1.24949e+06 (118210)

Average Optimal load -j 256 Run (std deviation):
Elapsed Time 770.97 (90.8685)
User Time 5068.42 (750.933)
System Time 21499.8 (12822.3)
Percent CPU 3660 (1425.28)
Context Switches 2.86467e+06 (971764)
Sleeps 1.32784e+06 (129048)

Average Maximal load -j Run (std deviation):
Elapsed Time 757.018 (22.8371)
User Time 4958.85 (644.65)
System Time 24916.5 (11454.3)
Percent CPU 4046.93 (1279.6)
Context Switches 3.04894e+06 (826687)
Sleeps 1.26053e+06 (146073)


2.6.31-rc5-git2 w/ CONFIG_RESOURCE_COUNTERS off

Tue Aug 11 17:58:58 EDT 2009
2.6.31-rc5-git2-no-resources
Average Half load -j 32 Run (std deviation):
Elapsed Time 280.176 (21.1131)
User Time 3558.51 (389.488)
System Time 2393.87 (142.692)
Percent CPU 2122.6 (50.5104)
Context Switches 1.20474e+06 (131112)
Sleeps 1062507 (59366.3)

Average Optimal load -j 256 Run (std deviation):
Elapsed Time 223.192 (42.7007)
User Time 4243.19 (967.575)
System Time 2649.57 (344.462)
Percent CPU 2845.5 (856.217)
Context Switches 1.52187e+06 (391821)
Sleeps 1.28862e+06 (274222)

Average Maximal load -j Run (std deviation):
Elapsed Time 216.942 (45.4824)
User Time 3860.46 (966.452)
System Time 2782.17 (344.154)
Percent CPU 2862.47 (720.904)
Context Switches 1.43379e+06 (341021)
Sleeps 1184325 (269392)

2.6.31-rc5-git2 w/ CONFIG_RESOURCE_COUNTERS on + patch

Tue Aug 11 20:58:31 EDT 2009
2.6.31-rc5-git2-mem-patch
Average Half load -j 32 Run (std deviation):
Elapsed Time 285.788 (18.577)
User Time 3483.14 (346.56)
System Time 2426.37 (132.015)
Percent CPU 2066.8 (80.3754)
Context Switches 1.16588e+06 (134701)
Sleeps 1048810 (59891.2)

Average Optimal load -j 256 Run (std deviation):
Elapsed Time 239.81 (14.0759)
User Time 3797.7 (422.118)
System Time 2622.74 (225.361)
Percent CPU 2480.9 (446.735)
Context Switches 1.37301e+06 (238886)
Sleeps 1195957 (161659)

Average Maximal load -j Run (std deviation):
Elapsed Time 203.884 (8.59151)
User Time 3578.02 (482.79)
System Time 2759.9 (273.03)
Percent CPU 2663.53 (450.476)
Context Switches 1.33907e+06 (199658)
Sleeps 1119205 (172089)


... The odd thing is that the run with the patch is still less than the 
run with CONFIG_RESOURCE_COUNTERS off.  It was so odd that I double 
checked that I actually built in RESOURCE_COUNTERS and had applied the 
patch, both of which I had done.

P.

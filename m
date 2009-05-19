Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbZESHKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbZESHKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 03:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbZESHKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 03:10:08 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46162 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbZESHKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 03:10:07 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Zhang, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
Cc: kosaki.motohiro@jp.fujitsu.com, "Wu, Fengguang" <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <4D05DB80B95B23498C72C700BD6C2E0B2EF6E313@pdsmsx502.ccr.corp.intel.com>
References: <20090519125744.4EC3.A69D9226@jp.fujitsu.com> <4D05DB80B95B23498C72C700BD6C2E0B2EF6E313@pdsmsx502.ccr.corp.intel.com>
Message-Id: <20090519141050.4ED5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 May 2009 16:09:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> >>> >>Now, it was breaked. What should we do?
> >>> >>Yanmin, We know 99% linux people use intel cpu and you are one of
> >>> >>most hard repeated testing
> >>> [YM] It's very easy to reproduce them on my machines. :) Sometimes, because
> >>the
> >>> issues only exist on machines with lots of cpu while other community
> >>developers
> >>> have no such environments.
> >>>
> >>>
> >>>  guy in lkml and you have much test.
> >>> >>May I ask your tested machine and benchmark?
> >>> [YM] Usually I started lots of benchmark testing against the latest kernel,
> >>but
> >>> as for this issue, it's reported by a customer firstly. The customer runs
> >>apache
> >>> on Nehalem machines to access lots of files. So the issue is an example of
> >>file
> >>> server.
> >>
> >>hmmm.
> >>I'm surprised this report. I didn't know this problem. oh..
> [YM] Did you run file server workload on such NUMA machine with
>  zone_reclaim_mode=1? If all nodes have the same memory, the behavior is
> obvious.

I missed your point. I agree file server case is obvious. but I don't
think anybody oppose this.



> >>Actually, I don't think apache is only file server.
> >>apache is one of killer application in linux. it run on very widely
> >>organization.
> [YM] I know that. Apache could support document, ecommerce, and lots of other
> usage models. What I mean is one of customers hit it with their
> workload.

hmhm, ok.


> >>you think large machine don't run apache? I don't think so.
> >>
> >>
> >>
> >>> BTW, I found many test cases of fio have big drop after I upgraded BIOS of
> >>one
> >>> Nehalem machine. By checking vmstat data, I found almost a half memory is
> >>always free. It's also related to zone_reclaim_mode because new BIOS changes
> >>the node
> >>> distance to a large value. I use numactl --interleave=all to walkaround the
> >>problem temporarily.
> >>>
> >>> I have no HPC environment.
> >>
> >>Yeah, that's ok. I and cristoph have. My worries is my unknown workload become
> >>regression.
> >>so, May I assume you run your benchmark both zonre reclaim 0 and 1 and you
> >>haven't seen regression by non-zone reclaim mode?
> [YM] what is non-zone reclaim mode? When zone_reclaim_mode=0?
> I didn't do that intentionally. Currently I just make sure FIO has a big drop
>  when zone_reclaim_mode=1. I might test it with other benchmarks on 2 Nehalem machines.

May I ask what is FIO?
File IO?


> >>if so, it encourage very much to me.
> >>
> >>if zone reclaim mode disabling don't have regression, I'll pushing to
> >>remove default zone reclaim mode completely again.
> [YM] I run lots of benchmarks, but it doesn't mean I run all benchmarks, especially
> no HPC. 

Of cource. nobody can run all benchmark in the world :)



> >>> >>if zone_reclaim=0 tendency workload is much than zone_reclaim=1 tendency
> >>> >>workload,
> >>> >> we can drop our afraid and we would prioritize your opinion, of cource.
> >>> So it seems only file servers have the issue currently.
> 




Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbXD0OHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbXD0OHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbXD0OHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:07:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45504 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897AbXD0OF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:05:26 -0400
Date: Fri, 27 Apr 2007 16:05:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: hechacker1 <hechacker1@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: "REPORT: sd-0.46 vs cfs-v6 vs mainline 2.6.21-rc7 Beryl + Video + Audio"
Message-ID: <20070427140520.GA27854@elte.hu>
References: <6700d24e0704262101v132bec29nf9fd6c93fe8748a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6700d24e0704262101v132bec29nf9fd6c93fe8748a@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* hechacker1 <hechacker1@gmail.com> wrote:

> "REPORT: sd-0.46 vs cfs-v6 vs mainline 2.6.21-rc7 Beryl + Video + Audio"

thanks for testing it out.

one immediate observation i have is that you used a 2msec granularity 
setting on CFS, but even that did not cause context-switching as high as 
SD's rr_interval==2 setting:

> cfs-v6:
> 700m kernel # cat sched_granularity_ns
> 2000000
> r  b   swpd   free   buff  cache    si   so    bi    bo   in   cs us sy id
> 1  0      0 100412     44 1519364    0    0     0     0 7426 7634 62  4 34  
> 4  0      0 100288     44 1519364    0    0     0     0 7039 7442 60  6 34  

> sd-0.46:
> 700m kernel # cat rr_interval
> 2
> r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id
> 5  0      0 918052    536 832840    0    0   411     0 2387 15242 89 11  0  
> 4  1      0 915600    536 834908    0    0   388     0 2283 15428 90 10  0  

so SD context-switched twice as much and saturated the CPU fully, while 
under cfs-v6 there was 34% idle time left. That double context-switch 
rate and higher CPU utilization could easily result in you experiencing 
a 'smoother' desktop (and smoother video playback) on SD.

could you try to maximize the preemption ratio on CFS by using a 
sched_granularity_ns of 0? Does that result in a higher context-switch 
rate and in better CPU utilization? Thanks,

	Ingo

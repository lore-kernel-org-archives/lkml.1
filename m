Return-Path: <linux-kernel-owner+w=401wt.eu-S1767344AbXECDIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767344AbXECDIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 23:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767345AbXECDIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 23:08:09 -0400
Received: from dodo.cs.umass.edu ([128.119.242.12]:57421 "EHLO
	dodo.cs.umass.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767344AbXECDII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 23:08:08 -0400
Message-ID: <4639520E.8020807@cs.umass.edu>
Date: Wed, 02 May 2007 23:07:58 -0400
From: Ting Yang <tingy@cs.umass.edu>
Reply-To: tingy@cs.umass.edu
Organization: ALI Lab, CS Dept, UMASS
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: "Li, Tong N" <tong.n.li@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [patch] CFS scheduler, -v8
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu> <1178131340.25170.24.camel@tongli.jf.intel.com>
In-Reply-To: <1178131340.25170.24.camel@tongli.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Li, Tong N wrote:
> Thanks for the excellent explanation. I think EEVDF and many algs alike
> assume global ordering of all tasks in the system (based on virtual
> time), whereas CFS does so locally on each processor and relies on load
> balancing to achieve fairness across processors. It'd achieve strong
> fairness locally, but I'm not sure about its global fairness properties
> in an MP environment. If ideally the total load weight on each processor
> is always the same, then local fairness would imply global fairness, but
> this is a bin packing problem and is intractable ...
First, I am not assuming a global ordering of all tasks. As the current 
implementation, EEVDF should maintain virtual time locally for each CPU. 
EEVDF is a proportional  time share scheduler, therefore the relative 
weight and actual cpu share for each task varies when tasks join and 
leave. There will be not bin-pack problem for such systems.

I understand that bin-pack problem does exist in Real-time world. 
Suppose in a system has 2 cpus,  there a 3 tasks, all of which needs to 
finish 30ms work within a window of 50ms. Any 2 of them stay together 
will exceeds the bandwidth of one cpu. There is a bin-pack problem, 
unless the system has to be clever enough to break one of them down into 
2 requests of 15ms/25ms, and execute them on different cpus at different 
time without overlap, which is quite difficult :-)

In the proportional world, weights and cpu share are scale to fit with 
the bandwidth of a cpu. Therefore putting 2 of them on one cpu is fine, 
and the fairness for each cpu is preserved. On the other hand, moving 
one task back and forth among 2 cpus do give better throughput and 
better global fairness. I have not dig into the load balancing 
algorithms of SMP yet, so I leave it aside for now, first thing first :-)

Thanks !

Ting

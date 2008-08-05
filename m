Return-Path: <linux-kernel-owner+w=401wt.eu-S1764740AbYHEUbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764740AbYHEUbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764478AbYHEUav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:30:51 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47298 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764817AbYHEUat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:30:49 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5354"; a="5338464"
Message-ID: <4898B873.6000308@qualcomm.com>
Date: Tue, 05 Aug 2008 13:30:43 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (2.6.27-rc1)
References: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>	<20080802063900.6615e5ca.pj@sgi.com>	<48948C3A.6050805@qualcomm.com>	<20080802225127.2b0d138b.pj@sgi.com>	<4895F3ED.4020805@qualcomm.com>	<20080804010033.0d1b0549.pj@sgi.com>	<48977E81.4040207@qualcomm.com> <20080804225636.541527e8.pj@sgi.com>
In-Reply-To: <20080804225636.541527e8.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max wrote:
>> Actually it is appropriate, and there is one more user of the
>> arch_reinit_sched_domains() which is S390 topology updates.
>> Those things (mc_power and topology updates) have to update domain flags based
>> on the mc/smt power and current topology settings.
> 
> Hmmm ... ok I suppose.
> 
> Could we have the kernel/sched.c code, in this case, call the
> kernel/cpuset.c routine async_rebuild_sched_domains(), rather
> than the synchronous rebuild_sched_domains() call (in your naming)
> which required details of the get_online_cpus() and put_online_cpus()
> wrapping to leak into kernel/sched.c:arch_reinit_sched_domains()
> routine?

It could I guess. But the questions is why ?
I mean the only reason we've introduced workqueue is because lock 
nesting got too complicated. Otherwise in all those paths we're already 
in a process context and there is no need to schedule a workqueue.

I see your point about get_online_cpus() thing. But it is similar to 
partition_sched_domains() which is an external (from the sched pov) 
interface and must be called within get_online_cpus() ... put_online_cpus().

Max



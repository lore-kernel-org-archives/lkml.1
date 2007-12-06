Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbXLFQ3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbXLFQ3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbXLFQ3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:29:33 -0500
Received: from ccs17.jlab.org ([129.57.35.82]:38795 "EHLO ccs17.jlab.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbXLFQ3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:29:32 -0500
Message-ID: <47582367.6060602@jlab.org>
Date: Thu, 06 Dec 2007 11:29:27 -0500
From: Jie Chen <chen@jlab.org>
Organization: Jefferson Lab
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Simon Holm Th??gersen <odie@cs.aau.dk>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
References: <20071205154014.GA6491@elte.hu> <4756D058.1070500@jlab.org> <20071205164723.GA25641@elte.hu> <4756E44E.8080607@jlab.org> <20071205200343.GA14570@elte.hu> <475708A7.4030708@jlab.org> <20071205204645.GC25694@elte.hu> <47570F83.6040601@jlab.org> <20071205210222.GA30089@elte.hu> <47572353.4040606@jlab.org> <20071206104318.GB30838@elte.hu>
In-Reply-To: <20071206104318.GB30838@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jie Chen <chen@jlab.org> wrote:
> 
>>> not "BARRIER time". I've re-read the discussion and found no hint 
>>> about how to build and run a barrier test. Either i missed it or it's 
>>> so obvious to you that you didnt mention it :-)
>>>
>>> 	Ingo
>> Hi, Ingo:
>>
>> Did you do configure --enable-public-release? My qmt is for qcd 
>> calculation (one type of physics code) [...]
> 
> yes, i did exactly as instructed.
> 
>> [...]. Without the above flag one can only test PARALLEL overhead. 
>> Actually the PARALLEL benchmark has the same behavior as the BARRIER. 
>> Thanks.
> 
> hm, but PARALLEL does not seem to do that much context switching. So 
> basically you create the threads and do a few short runs to establish 
> overhead? Threads do not get fork-balanced at the moment - but turning 
> it on would be easy. Could you try the patch below - how does it impact 
> your results? (and please keep affinity setting off)
> 
> 	Ingo
> 
> ----------->
> Subject: sched: reactivate fork balancing
> From: Ingo Molnar <mingo@elte.hu>
> 
> reactivate fork balancing.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/topology.h |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux/include/linux/topology.h
> ===================================================================
> --- linux.orig/include/linux/topology.h
> +++ linux/include/linux/topology.h
> @@ -103,6 +103,7 @@
>  	.forkexec_idx		= 0,			\
>  	.flags			= SD_LOAD_BALANCE	\
>  				| SD_BALANCE_NEWIDLE	\
> +				| SD_BALANCE_FORK	\
>  				| SD_BALANCE_EXEC	\
>  				| SD_WAKE_AFFINE	\
>  				| SD_WAKE_IDLE		\
> @@ -134,6 +135,7 @@
>  	.forkexec_idx		= 1,			\
>  	.flags			= SD_LOAD_BALANCE	\
>  				| SD_BALANCE_NEWIDLE	\
> +				| SD_BALANCE_FORK	\
>  				| SD_BALANCE_EXEC	\
>  				| SD_WAKE_AFFINE	\
>  				| SD_WAKE_IDLE		\
> @@ -165,6 +167,7 @@
>  	.forkexec_idx		= 1,			\
>  	.flags			= SD_LOAD_BALANCE	\
>  				| SD_BALANCE_NEWIDLE	\
> +				| SD_BALANCE_FORK	\
>  				| SD_BALANCE_EXEC	\
>  				| SD_WAKE_AFFINE	\
>  				| BALANCE_FOR_PKG_POWER,\
Hi, Ingo:

I did patch the header file and recompiled the kernel. I observed no 
difference (two threads overhead stays too high). Thank you.

-- 
###############################################
Jie Chen
Scientific Computing Group
Thomas Jefferson National Accelerator Facility
12000, Jefferson Ave.
Newport News, VA 23606

(757)269-5046 (office) (757)269-6248 (fax)
chen@jlab.org
###############################################


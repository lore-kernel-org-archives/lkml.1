Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbYCBUHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbYCBUHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 15:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbYCBUHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 15:07:30 -0500
Received: from el-out-1112.google.com ([209.85.162.180]:27208 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbYCBUH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 15:07:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=kaDagF8WgNoZdVrspG1QNMB30pPHJptY5uHglCEDi4RRgi1YWBm+mBp7kmihvctig6EUfFEQQe3WiJFRNWWHNXP2vmLSnHZkU1i//F/RU0UGucthxp/lT/ZZZhaol7IE4ywB1GALveBSLLasZcnT66lOkvI78FIh69SjMTjQ5TI=
Message-ID: <47CB08E4.8020007@gmail.com>
Date: Sun, 02 Mar 2008 14:07:00 -0600
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Allan Menezes <amenezes007@sympatico.ca>, linux-kernel@vger.kernel.org
Subject: Re: HPL Benchmark performance degradation of kernel 2.6.24.3 vs 2.6.23.14
References: <47CA3C60.8080402@sympatico.ca> <47CAF675.7010305@cosmosbay.com>
In-Reply-To: <47CAF675.7010305@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Allan Menezes a écrit :
>> Hi,
>>    I have a five node intel Q6600 quad core cluster and I benchmarked 
>> it with open source open mpi software using fc8 and it's supplied 
>> kernels recompiled and that of kernel.org with kernel 2.6.23.14 and 
>> 2.6.24.3.
>> With GotoBlas v 1.24 and open mpi beta both cases (v 1.3a) for kernels 
>> 2.6.23.14 with web100 i get 158GFlops.
>> But when i recompile with web100 for kernel 2.6.24 / without web100 
>> and having 6gig DDR2800MHz ram on each node i get only 28GFLOPS AND 
>> 22GFLOPS  for 5 nodes whereas with or without web 100 for kernel 
>> 2.6.23.14 i get 156-8 GfLOPS. wITH OR WITHOUT web 100 i get for kernel 
>> 2.6.24.3 22- 28 Gflops for 5 nodes.!
>> Why is there a performance drop in kernel 2.6.24.3 All else hardware 
>> is the same!
>> For inter node communication i use three pci express gig eth cards ( 2 
>> intel and one syskonnect ) per node and using nptcp of netpipe their 
>> performance of intel and syskonnect cards in both kernels measured 
>> point to point is 880MBPS approx for all three cards with measured 
>> using netpipe for tcp with kernel 2.6.24.3 and 2.6.23.14 . I am also 
>> using three switches gigabit with high bisection b/w for these eth 
>> cards (copper) with 3 different subnets
>> Yet I am getting a substantial performance drop keeping the hardware 
>> and openmpi and hpl and gotoblas same. Can some one help me figure out 
>> why?
>> Please find attached my kernel's .config
> 
> Hi Allan
> 
> Your setup is quite complex, so you should give more information if you 
> want some help here.
> 
> Is this benchmark stressing disk IO, task scheduler, network stack, 
> memory, swap... hard to tell in fact.
> 
> Examining your .config, I would point out CONFIG_SLUB_DEBUG=y
> You really should disable this expensive option.
> (and possibly use CONFIG_SLAB instead of CONFIG_SLUB)
> 
> You probably should try to use oprofile tool, because its results are 
> probably a good way to give hints about bad configuration, or kernel 
> regressions.
> 
> opcontrol --vmfile=/boot/vmlinux-2.6.24.3 --start
> <benchmarking>
> opreport -l /boot/vmlinux-2.6.24.3

I am not the original reporter, to get good numbers HPL tests cpu and mostly
networking speed (if more than one machine is being used), if local it
test whichever interprocess communication is being used.

It is floating point with communications to sync the different processes
together.

Generally if it is abnormally slow, you either have a errant process
on a machine, a problem with one machine, or a problem with networking
latency, or possibly a problem with some other latency.

I have never seen the scheduler make a big difference (unless the scheduler is 
really really broken), and it if configured for speed it does little or no swap 
(but I have seem machines that were tuned to page out early cause slight slow 
downs in the numbers when things should have nicely fit in memory), and it does 
little or no disk IO in the timed speed calculation areas.

It is pretty much all network latency and floating point speed.


                               Roger

                             Roger


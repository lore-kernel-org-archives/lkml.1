Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbYCBSsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbYCBSsq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 13:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYCBSsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 13:48:39 -0500
Received: from neuf-infra-smtp-out-sp604007av.neufgp.fr ([84.96.92.120]:55833
	"EHLO neuf-infra-smtp-out-sp604007av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbYCBSsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 13:48:37 -0500
Message-ID: <47CAF675.7010305@cosmosbay.com>
Date: Sun, 02 Mar 2008 19:48:21 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Allan Menezes <amenezes007@sympatico.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: HPL Benchmark performance degradation of kernel 2.6.24.3 vs 2.6.23.14
References: <47CA3C60.8080402@sympatico.ca>
In-Reply-To: <47CA3C60.8080402@sympatico.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allan Menezes a écrit :
> Hi,
>    I have a five node intel Q6600 quad core cluster and I benchmarked it 
> with open source open mpi software using fc8 and it's supplied kernels 
> recompiled and that of kernel.org with kernel 2.6.23.14 and 2.6.24.3.
> With GotoBlas v 1.24 and open mpi beta both cases (v 1.3a) for kernels 
> 2.6.23.14 with web100 i get 158GFlops.
> But when i recompile with web100 for kernel 2.6.24 / without web100 and 
> having 6gig DDR2800MHz ram on each node i get only 28GFLOPS AND 
> 22GFLOPS  for 5 nodes whereas with or without web 100 for kernel 
> 2.6.23.14 i get 156-8 GfLOPS. wITH OR WITHOUT web 100 i get for kernel 
> 2.6.24.3 22- 28 Gflops for 5 nodes.!
> Why is there a performance drop in kernel 2.6.24.3 All else hardware is 
> the same!
> For inter node communication i use three pci express gig eth cards ( 2 
> intel and one syskonnect ) per node and using nptcp of netpipe their 
> performance of intel and syskonnect cards in both kernels measured point 
> to point is 880MBPS approx for all three cards with measured using 
> netpipe for tcp with kernel 2.6.24.3 and 2.6.23.14 . I am also using 
> three switches gigabit with high bisection b/w for these eth cards 
> (copper) with 3 different subnets
> Yet I am getting a substantial performance drop keeping the hardware and 
> openmpi and hpl and gotoblas same. Can some one help me figure out why?
> Please find attached my kernel's .config

Hi Allan

Your setup is quite complex, so you should give more information if you want 
some help here.

Is this benchmark stressing disk IO, task scheduler, network stack, memory, 
swap... hard to tell in fact.

Examining your .config, I would point out CONFIG_SLUB_DEBUG=y
You really should disable this expensive option.
(and possibly use CONFIG_SLAB instead of CONFIG_SLUB)

You probably should try to use oprofile tool, because its results are probably 
a good way to give hints about bad configuration, or kernel regressions.

opcontrol --vmfile=/boot/vmlinux-2.6.24.3 --start
<benchmarking>
opreport -l /boot/vmlinux-2.6.24.3

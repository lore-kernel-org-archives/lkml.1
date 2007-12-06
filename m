Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbXLFKoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbXLFKoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 05:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbXLFKo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 05:44:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46404 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbXLFKo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 05:44:28 -0500
Date: Thu, 6 Dec 2007 11:43:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jie Chen <chen@jlab.org>
Cc: Simon Holm Th??gersen <odie@cs.aau.dk>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
Message-ID: <20071206104318.GB30838@elte.hu>
References: <20071205154014.GA6491@elte.hu> <4756D058.1070500@jlab.org> <20071205164723.GA25641@elte.hu> <4756E44E.8080607@jlab.org> <20071205200343.GA14570@elte.hu> <475708A7.4030708@jlab.org> <20071205204645.GC25694@elte.hu> <47570F83.6040601@jlab.org> <20071205210222.GA30089@elte.hu> <47572353.4040606@jlab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47572353.4040606@jlab.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jie Chen <chen@jlab.org> wrote:

>> not "BARRIER time". I've re-read the discussion and found no hint 
>> about how to build and run a barrier test. Either i missed it or it's 
>> so obvious to you that you didnt mention it :-)
>>
>> 	Ingo
>
> Hi, Ingo:
>
> Did you do configure --enable-public-release? My qmt is for qcd 
> calculation (one type of physics code) [...]

yes, i did exactly as instructed.

> [...]. Without the above flag one can only test PARALLEL overhead. 
> Actually the PARALLEL benchmark has the same behavior as the BARRIER. 
> Thanks.

hm, but PARALLEL does not seem to do that much context switching. So 
basically you create the threads and do a few short runs to establish 
overhead? Threads do not get fork-balanced at the moment - but turning 
it on would be easy. Could you try the patch below - how does it impact 
your results? (and please keep affinity setting off)

	Ingo

----------->
Subject: sched: reactivate fork balancing
From: Ingo Molnar <mingo@elte.hu>

reactivate fork balancing.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/topology.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/include/linux/topology.h
===================================================================
--- linux.orig/include/linux/topology.h
+++ linux/include/linux/topology.h
@@ -103,6 +103,7 @@
 	.forkexec_idx		= 0,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_NEWIDLE	\
+				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_IDLE		\
@@ -134,6 +135,7 @@
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_NEWIDLE	\
+				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_IDLE		\
@@ -165,6 +167,7 @@
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_NEWIDLE	\
+				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
 				| SD_WAKE_AFFINE	\
 				| BALANCE_FOR_PKG_POWER,\

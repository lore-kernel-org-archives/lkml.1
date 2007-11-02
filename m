Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbXKBQfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbXKBQfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 12:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbXKBQfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 12:35:43 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38848 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbXKBQfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 12:35:43 -0400
Message-ID: <472B51D1.7010708@linux.vnet.ibm.com>
Date: Fri, 02 Nov 2007 22:05:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix delay accounting regression
References: <20071102142220.24166.49046.sendpatchset@balbir-laptop> <20071102155358.GA32116@elte.hu>
In-Reply-To: <20071102155358.GA32116@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Fix the delay accounting regression introduced by commit 
>> 75d4ef16a6aa84f708188bada182315f80aab6fa. rq no longer has sched_info 
>> data associated with it. task_struct sched_info structure is used by 
>> delay accounting to provide back statistics to user space.
> 
> no, this really is broken code. sched_clock() is not a generally 
> reliable time source so at a minimum the rq->clock fix i mentioned is 
> needed. What user-space tools are utilizing delay-accounting by the way? 

Applications I can think of are

1. iotop
2. Some typical applications are mentioned in
   https://ols2006.108.redhat.com/2007/Reprints/nagar-Reprint.pdf

> We have most of this data available under SCHEDSTATS - how about 
> consolidating CONFIG_TASK_DELAY_ACCT into CONFIG_SCHEDSTATS?
> 
> 	Ingo


Yes, we do use schedstats - except for two cases that I know of?

1. To accumulate information in taskstats to share with user space
   (we copy the data from schedstats into taskstats)
2. We accumulate the data for dead threads in a thread group

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

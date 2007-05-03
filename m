Return-Path: <linux-kernel-owner+w=401wt.eu-S2993254AbXECPTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993254AbXECPTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993263AbXECPTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:19:13 -0400
Received: from dodo.cs.umass.edu ([128.119.242.12]:63152 "EHLO
	dodo.cs.umass.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993254AbXECPTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:19:11 -0400
Message-ID: <4639FD68.1060500@cs.umass.edu>
Date: Thu, 03 May 2007 11:19:04 -0400
From: Ting Yang <tingy@cs.umass.edu>
Reply-To: tingy@cs.umass.edu
Organization: ALI Lab, CS Dept, UMASS
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu> <20070503085015.GA20516@elte.hu> <20070503142618.GB25479@in.ibm.com>
In-Reply-To: <20070503142618.GB25479@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Srivatsa Vaddagiri wrote:
> On Thu, May 03, 2007 at 10:50:15AM +0200, Ingo Molnar wrote:
>  
>> - EEVDF concentrates on real-time (SCHED_RR-alike) workloads where they
>>   know the length of work units
>>     
>
> This is what I was thinking when I wrote earlier that EEVDF expects each
> task will specify "length of each new request"
> (http://lkml.org/lkml/2007/5/2/339).
>   
This is not very true based on my understanding of EEVDF, please look at 
the email I just sent out to Ingo for explanation.
> The other observation that I have of EEVDF is that it tries to be fair
> in the virtual time scale (each client will get 'wi' real units in 1
> virtual unit), whereas sometimes fairness in real-time scale also 
> matters?
> For ex: a multi-media app would call scheduler fair to it, it it recvs
> atleast 1 ms cpu time every 10 *real* milleseconds (frame-time). A rogue
> user (or workload) that does a fork bomb may skew this fairness for that
> multi-media app in real-time scale under EEVDF?
>   
First of all, CFS does not seems to address this issue to. This is a 
typical real-time or soft real-time question, that is not only the 
bandwidth of a task has to be fixed, i.e. 10% of cpu bandwidth (which 
proportional shared system, like CFS, EEVDF does not do), and the work 
need to satisfy a deadline.
In both CFS, EEVDF, the scheduler have keep tweaking weights to give a 
fixed bandwidth to application. Authors of EEVDF claims this can be 
done, but never implemented :-(

Ting

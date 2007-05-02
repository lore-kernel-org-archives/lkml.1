Return-Path: <linux-kernel-owner+w=401wt.eu-S1767251AbXEBXmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767251AbXEBXmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 19:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767252AbXEBXmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 19:42:00 -0400
Received: from dodo.cs.umass.edu ([128.119.242.12]:56000 "EHLO
	dodo.cs.umass.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767251AbXEBXl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 19:41:59 -0400
Message-ID: <463921B6.5050400@cs.umass.edu>
Date: Wed, 02 May 2007 19:41:42 -0400
From: Ting Yang <tingy@cs.umass.edu>
Reply-To: tingy@cs.umass.edu
Organization: ALI Lab, CS Dept, UMASS
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: vatsa@in.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu> <20070502173634.GA11308@in.ibm.com>
In-Reply-To: <20070502173634.GA11308@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:
> I briefly went thr' the paper and my impression is it expect each task
> to specify the length of each new request it initiates. Is that correct?
>   
No, the timeslice l_i here serves as a granularity control w.r.t 
responsiveness (or latency depends on how you interpret it). As wli said 
it can be express as a function of the priority, as we do for weight 
now. It is not related with the length of each new request. A request 
may be 1 seconds long, but the scheduler may still process it using 10ms 
timeslice. Smaller timeslice leads to more accuracy, i.e. closer to 
ideal case.
However, the maximum of timeslice l_i used by all active tasks 
determines the total responsiveness of the system, which I will explain 
in detail later.
> There is also p->wait_runtime which is taken into account when
> calculating p->fair_key. So if p3 had waiting in runqueue for long
> before, it can get to run quicker than 10ms later.
Consider if p3 is a newly started task or waked up task and carries no 
p->wait_runtime.

Ting

Return-Path: <linux-kernel-owner+w=401wt.eu-S938793AbXG1CsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938793AbXG1CsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 22:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761261AbXG1Cry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 22:47:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761096AbXG1Cry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 22:47:54 -0400
Message-ID: <46AAAE39.4070905@redhat.com>
Date: Fri, 27 Jul 2007 22:47:21 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: tim.c.chen@linux.intel.com
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: Volanomark slows by 80% under CFS
References: <1185573687.19777.44.camel@localhost.localdomain>
In-Reply-To: <1185573687.19777.44.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Chen wrote:
> Ingo,
> 
> Volanomark slows by 80% with CFS scheduler on 2.6.23-rc1.  
> Benchmark was run on a 2 socket Core2 machine.
> 
> The change in scheduler treatment of sched_yield 
> could play a part in changing Volanomark behavior.
> In CFS, sched_yield is implemented
> by dequeueing and requeueing a process .  The time a process 
> has spent running probably reduced the the cpu time due it 
> by only a bit. The process could get re-queued pretty close
> to head of the queue, and may get scheduled again pretty
> quickly if there is still a lot of cpu time due.  

I wonder if this explains the 30% drop in top performance
seen with the MySQL sysbench benchmark when the scheduler
changed to CFS...

See http://people.freebsd.org/~jeff/sysbench.png

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.

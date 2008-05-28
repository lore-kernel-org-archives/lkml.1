Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbYE1SsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbYE1SsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 14:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYE1Srz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 14:47:55 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:38181 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752436AbYE1Sry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 14:47:54 -0400
Date: Thu, 29 May 2008 00:17:38 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       a.p.zijlstra@chello.nl, pj@sgi.com, Balbir Singh <balbir@in.ibm.com>,
       aneesh.kumar@linux.vnet.ibm.com
Subject: Re: fair group scheduler not so fair?
Message-ID: <20080528184738.GA17326@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <4834B75A.40900@nortel.com> <20080527171528.GD30285@linux.vnet.ibm.com> <483C4F5A.2010104@nortel.com> <20080528163318.GG30285@linux.vnet.ibm.com> <483DA5E7.5050600@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483DA5E7.5050600@nortel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 12:35:19PM -0600, Chris Friesen wrote:
> Srivatsa Vaddagiri wrote:
>
>> We seem to be skipping the last element in the task list always. In your
>> case, the lone task in Group a/b is always skipped because of this.
>
>> Updated patch (on top of 2.6.26-rc3 +
>> http://programming.kicks-ass.net/kernel-patches/sched-smp-group-fixes/)
>> below.  Pls let me know how it fares!
>
> Looking much better, but still some fairness issues with more complex 
> setups.
>
> pid 2477 in A, others in B
> 2477	99.5%
> 2478	49.9%
> 2479	49.9%
>
> move 2478 to A
> 2479	99.9%
> 2477	49.9%
> 2478	49.9%
>
> So far so good.  I then created C, and moved 2478 to it.  A 3-second "top" 
> gave almost a 15% error from the desired behaviour for one group:
>
> 2479	76.2%
> 2477	72.2%
> 2478	51.0%
>
>
> A 10-sec average was better, but we still see errors of 6%:

So it is converging to a fair state. How does it look
across say 20 or 30 seconds your side?

> 2478	72.8%
> 2477	64.0%
> 2479	63.2%
>
>
> I then set up a scenario with 3 tasks in A, 2 in B, and 1 in C.  A 
> 10-second "top" gave errors of up to 6.5%:
> 2500	60.1%
> 2491	37.5%
> 2492	37.4%
> 2489	25.0%
> 2488	19.9%
> 2490	19.9%
>
> a re-test gave errors of up to 8.1%:
>
> 2534	74.8%
> 2533	30.1%
> 2532	30.0%
> 2529	25.0%
> 2530	20.0%
> 2531	20.0%
>
> Another retest gave perfect results initially:
>
> 2559	66.5%
> 2560	33.4%
> 2561	33.3%
> 2564	22.3%
> 2562	22.2%
> 2563	22.1%
>
> but moving 2564 from group A to C and then back to A disturbed the perfect 
> division of time and resulted in almost the same utilization pattern as 
> above:
>
> 2559	74.9%
> 2560	30.0%
> 2561	29.6%
> 2564	25.3%
> 2562	20.0%
> 2563	20.0%
>

This is over a longer duration or a 10 second duration?

-- 
regards,
Dhaval

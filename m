Return-Path: <linux-kernel-owner+w=401wt.eu-S1767346AbXECDS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767346AbXECDS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 23:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767348AbXECDS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 23:18:58 -0400
Received: from dodo.cs.umass.edu ([128.119.242.12]:57541 "EHLO
	dodo.cs.umass.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767346AbXECDS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 23:18:57 -0400
Message-ID: <46395495.3020802@cs.umass.edu>
Date: Wed, 02 May 2007 23:18:45 -0400
From: Ting Yang <tingy@cs.umass.edu>
Reply-To: tingy@cs.umass.edu
Organization: ALI Lab, CS Dept, UMASS
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu> <20070502173634.GA11308@in.ibm.com> <20070502174829.GX19966@holomorphy.com>
In-Reply-To: <20070502174829.GX19966@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Wed, May 02, 2007 at 11:06:34PM +0530, Srivatsa Vaddagiri wrote:
>   
>> There is also p->wait_runtime which is taken into account when
>> calculating p->fair_key. So if p3 had waiting in runqueue for long
>> before, it can get to run quicker than 10ms later.
>>     
>
> Virtual time is time from the task's point of view, which it has spent
> executing. ->wait_runtime is a device to subtract out time spent on the
> runqueue but not running from what would otherwise be virtual time to
> express lag, whether deliberately or coincidentally. ->wait_runtime
> would not be useful for EEVDF AFAICT, though it may be interesting to
> report.
I just want to point out that ->wait_runtime, in fact, stores the lag of 
each task in CFS, except that it is also used by other things, and 
occasionally tweaked (heuristically ?). Under normal cases the sum of 
lags of all active tasks in such a system, should be a constant 0. The 
lag information is equally important to EEVDF, when some tasks leave the 
system (becomes inactive) carrying certain amount of lag. The key point 
here is that we have to spread the lag (either negative or positive) to 
all remaining task, so that the fairness of the system is preserved. I 
thinks CFS implementation does not seems to handle this properly.

I am running out time today :-( I will write an email about CFS -v8 
tomorrow, describing 2 issues in CFS I found related to this.

Ting

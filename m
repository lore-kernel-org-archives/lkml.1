Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbYE0SOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbYE0SOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbYE0SN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:13:56 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:61802 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342AbYE0SNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:13:55 -0400
Message-ID: <483C4F5A.2010104@nortel.com>
Date: Tue, 27 May 2008 12:13:46 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       pj@sgi.com, Balbir Singh <balbir@in.ibm.com>,
       aneesh.kumar@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com
Subject: Re: fair group scheduler not so fair?
References: <4834B75A.40900@nortel.com> <20080527171528.GD30285@linux.vnet.ibm.com>
In-Reply-To: <20080527171528.GD30285@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2008 18:13:50.0814 (UTC) FILETIME=[6A3377E0:01C8C025]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:

> But first, note that Groups "a" and "b" share bandwidth with all tasks
> in /dev/cgroup/tasks.

Ah, good point.  I've switched over to your group setup for testing.

> The following experimental patch (on top of 2.6.26-rc3 +
> http://programming.kicks-ass.net/kernel-patches/sched-smp-group-fixes/) seems 
> to fix the problem.

> Can you check if this makes a difference for you as well?

Initially it looked promising.  I put pid 2498 in group A, and pids 2499 
and 2500 in group B.  2498 got basically a full cpu, and the other two 
got 50% each.

However, I then moved pid 2499 from group B to group A, and the system 
got stuck in the following behaviour:

2498 cfriesen  20   0  3800  392  336 R 99.7  0.0   3:00.22 cat
2500 cfriesen  20   0  3800  392  336 R 66.7  0.0   1:39.10 cat
2499 cfriesen  20   0  3800  392  336 R 33.0  0.0   1:24.31 cat

I reproduced this a number of times.

Chris

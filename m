Return-Path: <linux-kernel-owner+w=401wt.eu-S937344AbYEVAAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937344AbYEVAAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbYEUX7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:59:46 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:40282 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758499AbYEUX7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:59:45 -0400
Message-ID: <4834B75A.40900@nortel.com>
Date: Wed, 21 May 2008 17:59:22 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, pj@sgi.com
Subject: fair group scheduler not so fair?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2008 23:59:26.0440 (UTC) FILETIME=[B31E6680:01C8BB9E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just downloaded the current git head and started playing with the fair 
group scheduler.  (This is on a dual cpu Mac G5.)

I created two groups, "a" and "b".  Each of them was left with the 
default share of 1024.

I created three cpu hogs by doing "cat /dev/zero > /dev/null".  One hog 
(pid 2435) was put into group "a", while the other two were put into 
group "b".

After giving them time to settle down, "top" showed the following:

2438 cfriesen  20   0  3800  392  336 R 99.5  0.0   4:02.82 cat 

2435 cfriesen  20   0  3800  392  336 R 65.9  0.0   3:30.94 cat 

2437 cfriesen  20   0  3800  392  336 R 34.3  0.0   3:14.89 cat 



Where pid 2435 should have gotten a whole cpu worth of time, it actually 
only got 66% of a cpu. Is this expected behaviour?



I then redid the test with two hogs in one group and three hogs in the 
other group.  Unfortunately, the cpu shares were not equally distributed 
within each group.  Using a 10-sec interval in "top", I got the following:


2522 cfriesen  20   0  3800  392  336 R 52.2  0.0   1:33.38 cat 

2523 cfriesen  20   0  3800  392  336 R 48.9  0.0   1:37.85 cat 

2524 cfriesen  20   0  3800  392  336 R 37.0  0.0   1:23.22 cat 

2525 cfriesen  20   0  3800  392  336 R 32.6  0.0   1:22.62 cat 

2559 cfriesen  20   0  3800  392  336 R 28.7  0.0   0:24.30 cat 


Do we expect to see upwards of 9% relative unfairness between processes 
within a class?

I tried messing with the tuneables in /proc/sys/kernel 
(sched_latency_ns, sched_migration_cost, sched_min_granularity_ns) but 
was unable to significantly improve these results.

Any pointers would be appreciated.

Thanks,

Chris

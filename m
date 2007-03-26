Return-Path: <linux-kernel-owner+w=401wt.eu-S933283AbXCZBAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283AbXCZBAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 21:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933290AbXCZBAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 21:00:51 -0400
Received: from mail22.syd.optusnet.com.au ([211.29.133.160]:59275 "EHLO
	mail22.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933283AbXCZBAu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 21:00:50 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: rSDl cpu scheduler version 0.34-test patch
Date: Mon, 26 Mar 2007 11:00:21 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703261100.22467.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is just for testing at the moment! The reason is the size of this patch.

In the interest of evolution, I've taken the RSDL cpu scheduler and increased 
the resolution of the task timekeeping to nanosecond resolution. This removes 
the need for the runqueue rotation component entirely out of RSDL. The design 
basically is mostly unchanged, minus over 150 lines of code for the rotation, 
yet should be slightly better performing. It should be indistinguishable in 
usage from v0.33.

Other changes from v0.33:
-rr interval was not being properly scaled with HZ
-fix possible race in checking task_queued in task_running_tick
-scale down rr interval for niced tasks if HZ can tolerate it
-cull list_splice_tail

What does this mean for the next version of RSDL?

Assuming all works as expected on these test patches, it will be cleanest to 
submit a new series of patches for -mm with the renamed Staircase-Deadline 
scheduler and new documentation (when it's done).


So for testing here are full rollups for 2.6.20.4 and 2.6.21-rc4:
http://ck.kolivas.org/patches/staircase-deadline/2.6.20.4-sd-0.34-test.patch
http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc4-sd-0.34-test.patch

The patches available also include a rollup of sched: accurate user accounting 
as this code touches the same area and it is most convenient to include them 
together.

(incrementals in each subdir of staircase-deadline/ for those interested).

Thanks Mike for continuing to attempt to use the cluebat on me on this one. 
>From the start I wasn't sure if this was necessary or not but ends up being 
less code than RSDL.

While I'm still far from being well, luckily I am in much better shape to be 
able to spend the time at the pc to have done this. Thanks to all those who 
expressed their concern.

-- 
-ck

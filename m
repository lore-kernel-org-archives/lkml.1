Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbXECHWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbXECHWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbXECHWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:22:46 -0400
Received: from holomorphy.com ([66.93.40.71]:49714 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009AbXECHWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:22:45 -0400
Date: Thu, 3 May 2007 00:23:23 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: Re: [ck] [REPORT] 2.6.21.1 vs 2.6.21-sd046 vs 2.6.21-cfs-v6
Message-ID: <20070503072323.GD19966@holomorphy.com>
References: <200705030211.39345.a1426z@gawab.com> <200705030651.43865.a1426z@gawab.com> <20070503043541.GC19966@holomorphy.com> <200705030942.51301.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705030942.51301.a1426z@gawab.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> William Lee Irwin III wrote:
On Thu, May 03, 2007 at 09:42:51AM +0300, Al Boldi wrote:
>         sched_rr_get_interval(0, &ts);
>         printf("pid %d, prio %3d, interval of %d nsec\n", getpid(), getpriority(PRIO_PROCESS, 0), ts.tv_nsec);

Oh dear. What are you trying to figure out from the task's timeslice?
That's not even meaningful in cfs.


On Thu, May 03, 2007 at 09:42:51AM +0300, Al Boldi wrote:
>         start = last = stamp();
>         while(1) {
>                 cur = stamp();
>                 delta = cur-last;
>                 if (delta > thresh_ticks) {
> 			act = last - start;
>                         printf("pid %d, prio %3d, out for %4llu ms, ran for %4llu ms, load %3llu%\n"
> 			, getpid(), getpriority(PRIO_PROCESS, 0), delta/1000, act/1000,(act*100)/(cur-start));
>                         start = cur = stamp();
>                 }
>                 last = cur;
>         }
> 
>         return 0;
> }

This is looking for scheduling latencies, which are necessarily O(tasks).
This is not the way to do it.


-- wli

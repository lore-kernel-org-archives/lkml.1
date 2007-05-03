Return-Path: <linux-kernel-owner+w=401wt.eu-S1161256AbXECH5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161256AbXECH5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbXECH5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:57:21 -0400
Received: from [212.12.190.248] ([212.12.190.248]:33048 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755242AbXECH5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:57:19 -0400
From: Al Boldi <a1426z@gawab.com>
To: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [ck] [REPORT] 2.6.21.1 vs 2.6.21-sd046 vs 2.6.21-cfs-v6
Date: Thu, 3 May 2007 11:01:14 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
References: <200705030211.39345.a1426z@gawab.com> <200705030942.51301.a1426z@gawab.com> <20070503072323.GD19966@holomorphy.com>
In-Reply-To: <20070503072323.GD19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705031101.14600.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> On Thu, May 03, 2007 at 09:42:51AM +0300, Al Boldi wrote:
> >         sched_rr_get_interval(0, &ts);
> >         printf("pid %d, prio %3d, interval of %d nsec\n", getpid(),
> > getpriority(PRIO_PROCESS, 0), ts.tv_nsec);
>
> Oh dear. What are you trying to figure out from the task's timeslice?

chew.c is general purpose.  It's not specific to cfs.

> That's not even meaningful in cfs.
>
> On Thu, May 03, 2007 at 09:42:51AM +0300, Al Boldi wrote:
> >         start = last = stamp();
> >         while(1) {
> >                 cur = stamp();
> >                 delta = cur-last;
> >                 if (delta > thresh_ticks) {
> > 			act = last - start;
> >                         printf("pid %d, prio %3d, out for %4llu ms, ran
> > for %4llu ms, load %3llu%\n" , getpid(), getpriority(PRIO_PROCESS, 0),
> > delta/1000, act/1000,(act*100)/(cur-start)); start = cur = stamp();
> >                 }
> >                 last = cur;
> >         }
> >
> >         return 0;
> > }
>
> This is looking for scheduling latencies, which are necessarily O(tasks).

This exposes the actual proc latency/waittime and runtime and cpu load 
irrespective of being O(tasks) or not.

> This is not the way to do it.

You'll need to boot into /bin/sh and run two or more chew.c's to see any 
reasonable results.

Then tell me whether this is the way to do it or not.


Thanks!

--
Al


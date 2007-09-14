Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbXINKHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbXINKHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 06:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbXINKGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 06:06:47 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:64607 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbXINKGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 06:06:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Duf/f3CFkLEXeJxBoQqf3RurlhEZvJjwhura+pK2k4KOcQUCnVANROc4WoDxa9dE7ZkxSvc1UwQDvJLlSXJkuDidfViM+Gd080DZsmyYCHQI0EVvo4UFvGcyvEUiG1jykSqAhd0eRYjaHF0jTC2BM9ZedWBvz2p1q6gFxX0bDf0=
Message-ID: <a781481a0709140306k3faf3585haae26853fe81381c@mail.gmail.com>
Date: Fri, 14 Sep 2007 15:36:42 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: CFS: some bad numbers with Java/database threading
Cc: "Antoine Martin" <antoine@nagafix.co.uk>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20070914083246.GA20514@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46E871FE.9010908@nagafix.co.uk> <20070913112427.GA20686@elte.hu>
	 <20070914083246.GA20514@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antoine, Ingo,


On 9/14/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
> > hm, could you try the patch below ontop of 2.6.23-rc6 and do:
> >
> >  echo 1 > /proc/sys/kernel/sched_yield_bug_workaround
> >
> > does this improve the numbers?

Hmm, I know diddly about Java, and I don't want to preempt Antoine's next
test, but I noticed that he uses Thread.sleep() in his testcode and not the
Thread.yield() so it would be interesting if Antoine can test with this patch
and report if something shows up ...


> the patch i sent was against CFS-devel. Could you try the one below,
> which is against vanilla -rc6, does it improve the numbers? (it should
> have an impact) Keep CONFIG_SCHED_DEBUG=y to be able to twiddle the
> sysctl.


On 9/13/07, Antoine Martin <antoine@nagafix.co.uk> wrote:
>
> All the 2.6.23-rc kernels performed poorly (except -rc3!):

This is an interesting data point, IMHO ... considering these tests are long,
I suspect you ran them only once each per kernel. So I wonder how reliable
that -rc3 testpoint is. If this oddity is reproducible, it would be great if you
could git-bisect:

1. between 23-rc1 and 23-rc3, and find out which commit led to the
  improvement in performance, and,
2. between 23-rc3 and 23-rc6, and find out which commit brought down
  the numbers again.

[ http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html,
  git-bisect is easy and amazingly helpful on certain occasions. ]


> Notes about the tests and setup:
> * environment is:
> Dual Opteron 252 with 3GB ram, scsi disk, etc..
> Sun Java 1.6
> MySQL 5.0.44
> Junit + ant + my test code (devloop.org.uk)
> * java threads are created first and the data is prepared, then all the
> threads are started in a tight loop. Each thread runs multiple queries
> with a 10ms pause (to allow the other threads to get scheduled)

Don't know much about CFS either, but does that constant "10 ms" sleep
somehow lead to evil synchronization issues between the test threads?
Does randomizing that time (say from 2-20 ms) lead to different numbers?


> * load average is divided by the number of cpus (2)
> * more general information (which also covers some irrelevant
> information about some other tests I have published) is here:
> http://devloop.org.uk/documentation/database-performance/Setup/


Thanks,

Satyam

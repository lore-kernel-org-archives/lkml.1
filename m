Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbXG1U01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbXG1U01 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 16:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbXG1U0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 16:26:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340AbXG1U0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 16:26:17 -0400
Date: Sat, 28 Jul 2007 16:26:00 -0400
From: Dave Jones <davej@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: tim.c.chen@linux.intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: Volanomark slows by 80% under CFS
Message-ID: <20070728202600.GA7487@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Rik van Riel <riel@redhat.com>, tim.c.chen@linux.intel.com,
	mingo@elte.hu, linux-kernel@vger.kernel.org
References: <1185573687.19777.44.camel@localhost.localdomain> <46AAAE39.4070905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AAAE39.4070905@redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 10:47:21PM -0400, Rik van Riel wrote:
 > Tim Chen wrote:
 > > Ingo,
 > > 
 > > Volanomark slows by 80% with CFS scheduler on 2.6.23-rc1.  
 > > Benchmark was run on a 2 socket Core2 machine.
 > > 
 > > The change in scheduler treatment of sched_yield 
 > > could play a part in changing Volanomark behavior.
 > > In CFS, sched_yield is implemented
 > > by dequeueing and requeueing a process .  The time a process 
 > > has spent running probably reduced the the cpu time due it 
 > > by only a bit. The process could get re-queued pretty close
 > > to head of the queue, and may get scheduled again pretty
 > > quickly if there is still a lot of cpu time due.  
 > 
 > I wonder if this explains the 30% drop in top performance
 > seen with the MySQL sysbench benchmark when the scheduler
 > changed to CFS...
 > 
 > See http://people.freebsd.org/~jeff/sysbench.png

 From the authors blog when he did that graph:
 http://jeffr-tech.livejournal.com/10103.html

"So I updated the image for the second time today to include Ingo's cfs
 scheduler. This kernel is from the rpm on his website. I double checked
 that it was not using tcmalloc at the time and switching back to a
 2.6.21 kernel returned to the expected perf.

 Basically, it has the same performance as the FreeBSD 4BSD scheduler
 now. Which is to say the peak is terrible but it has virtually no
 dropoff and performs better under load than the default 2.6.21
 scheduler. "



	Dave

-- 
http://www.codemonkey.org.uk

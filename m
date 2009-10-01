Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbZJAQox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbZJAQox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbZJAQow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:44:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:50870 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511AbZJAQon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:44:43 -0400
Message-ID: <4AC4DC46.70907@kernel.org>
Date: Fri, 02 Oct 2009 01:43:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       jeff@garzik.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed	workqueue
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <20091001084040.GA15345@elte.hu>
In-Reply-To: <20091001084040.GA15345@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 16:43:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Ingo Molnar wrote:
> Ok, this looks fairly interesting - and the way you reused scheduler 
> classes to auto-regulate with no impact on regular performance is quite 
> an ingenious idea as well. (KVM's preempt notifiers should probably use 
> this trick too, instead of an ugly notifier in the scheduler hotpath)
> 
> This mechanism could be used to implement threadlets/syslets too btw., 
> and other forms of asynchronous IO.
> 
> My main worry is that in practice workqueues arent all that performance 
> critical - so we are shooting to optimize something that doesnt 
> necessarily use all the potential goodness inherent in this approach.

The scheduler code was pretty nice to hook into.  But as Jens said,
this patchset is more about getting the async framework which can
scale and be used universally.  Performance-wise, I was mainly aiming
for not introducing noticeable slow down as I expect workqueues to be
used more widely with this change.  Workqueue is already pretty
heavily used in certain paths - ie. block IO completion path with SSDs
and any signficant overhead would be noticeable.  With mixture of
different works of different run time, I think the net effect would be
positive.  It should be able to achieve better latency and throughput.
I don't have any numbers to back my rather optimistic projection yet
tho.

Thanks.

-- 
tejun

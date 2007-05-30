Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbXE3Csg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbXE3Csg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 22:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbXE3Cs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 22:48:28 -0400
Received: from holomorphy.com ([66.93.40.71]:42620 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbXE3Cs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 22:48:27 -0400
Date: Tue, 29 May 2007 19:48:15 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: vatsa@in.ibm.com, Kirill Korotaev <dev@sw.ru>,
       Nick Piggin <nickpiggin@yahoo.com.au>, tingy@cs.umass.edu,
       ckrm-tech@lists.sourceforge.net, Balbir Singh <balbir@in.ibm.com>,
       efault@gmx.de, kernel@kolivas.org, linux-kernel@vger.kernel.org,
       tong.n.li@intel.com, containers@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070530024815.GA6909@holomorphy.com>
References: <20070525082951.GA25280@elte.hu> <4656DF0C.9090306@sw.ru> <20070525153450.GA4679@in.ibm.com> <46570C70.4050209@sw.ru> <20070525180850.GA26884@in.ibm.com> <46577CA6.8000807@bigpond.net.au> <20070526154112.GA31925@holomorphy.com> <4658DF0F.5020208@bigpond.net.au> <20070529104805.GC31925@holomorphy.com> <465CC0B8.8050507@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465CC0B8.8050507@bigpond.net.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> Lag is the deviation of a task's allocated CPU time from the CPU time
>> it would be granted by the ideal fair scheduling algorithm (generalized
>> processor sharing; take the limit of RR with per-task timeslices
>> proportional to load weight as the scale factor approaches zero).

On Wed, May 30, 2007 at 10:09:28AM +1000, Peter Williams wrote:
> Over what time period does this operate?

Over a period of time while the task is runnable.


William Lee Irwin III wrote:
>> Negative lag reflects receipt of excess CPU time. A close-to-canonical
>> "fairness metric" is the maximum of the absolute values of the lags of
>> all the tasks on the system. The "signed minimax pseudonorm" is the
>> largest lag without taking absolute values; it's a term I devised ad
>> hoc to describe the proposed algorithm.

On Wed, May 30, 2007 at 10:09:28AM +1000, Peter Williams wrote:
> So what you're saying is that you think dynamic priority (or its 
> equivalent) should be used for load balancing instead of static priority?

It doesn't do much in other schemes, but when fairness is directly
measured by the dynamic priority, it is a priori more meaningful.
This is not to say the net effect of using it is so different.


William Lee Irwin III wrote:
>> I've presented a coherent
>> algorithm. It may be that there's no demonstrable problem to solve.
>> On the other hand, if there really is a question as to how to load
>> balance in the presence of tasks pinned to cpus, I just answered it.
> 
On Wed, May 30, 2007 at 10:09:28AM +1000, Peter Williams wrote:
> Unless I missed something there's nothing in your suggestion that does 
> anything more about handling pinned tasks than is already done by the 
> load balancer.

There are two things, both of which are relatively subtle and
coincidentally happen to some extent. The first is the unpinned lag,
which behaves much differently from unpinned load weight even if it's
not so different in concept, but apparently achieves a similar result.
The second is the relativistic point of view, which happens somewhat by
coincidence anyway, but isn't formalized anywhere at all as a basis for
handling tasks pinned to cpus. The first difference is minor and the
second formalizing something that mostly or completely already happens.


William Lee Irwin III wrote:
>> There was a second issue raised to which I responded. I didn't stray
>> per se. I addressed a second topic in the post.

On Wed, May 30, 2007 at 10:09:28AM +1000, Peter Williams wrote:
> OK.
> To reiterate, I don't think that my suggestion is really necessary.  I 
> think that the current load balancing (stand fast a small bug that's 
> being investigated) will come up with a good distribution of tasks to 
> CPUs within the constraints imposed by any CPU affinity settings.

It's sort of like performance. If the numbers are already good enough,
my algorithm on that front need not be bothered with either.


-- wli

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762302AbXE1Qb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762302AbXE1Qb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbXE1QbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:31:20 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35609 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbXE1QbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:31:19 -0400
Date: Mon, 28 May 2007 22:09:19 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, tingy@cs.umass.edu,
       ckrm-tech@lists.sourceforge.net, Balbir Singh <balbir@in.ibm.com>,
       efault@gmx.de, pwil3058@bigpond.net.au, kernel@kolivas.org,
       linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>, containers@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070528163919.GA28054@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070523164859.GA6595@in.ibm.com> <20070523180316.GY19966@holomorphy.com> <20070525161424.GA5162@in.ibm.com> <1180113298.28264.24.camel@tongli.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180113298.28264.24.camel@tongli.jf.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 10:14:58AM -0700, Li, Tong N wrote:
> Nice work, Vatsa. When I wrote the DWRR algorithm, I flattened the
> hierarchies into one level, so maybe that approach can be applied to
> your code as well. What I did is to maintain task and task group weights
> and reservations separately from the scheduler, while the scheduler only
> sees one system-wide weight per task and does not concern about which
> group a task is in. The key here is the system-wide weight of each task
> should represent an equivalent share to the share represented by the
> group hierarchies. To do this, the scheduler looks up the task and group
> weights/reservations it maintains, and dynamically computes the
> system-wide weight *only* when it need a weight for a given task while
> scheduling. The on-demand weight computation makes sure the cost is
> small (constant time). The computation itself can be seen from an
> example: assume we have a group of two tasks and the group's total share
> is represented by a weight of 10. Inside the group, let's say the two
> tasks, P1 and P2, have weights 1 and 2. Then the system-wide weight for
> P1 is 10/3 and the weight for P2 is 20/3. In essence, this flattens
> weights into one level without changing the shares they represent.

What do these task weights control? Timeslice primarily? If so, I am not
sure how well it can co-exist with cfs then (unless you are planning to
replace cfs with a equally good interactive/fair scheduler :)

I would be very interested if this weight calculation can be used for
smpnice based load balancing purposes too ..

-- 
Regards,
vatsa

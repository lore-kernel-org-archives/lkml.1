Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbZLUPUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbZLUPUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 10:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZLUPUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 10:20:10 -0500
Received: from mga06.intel.com ([134.134.136.21]:34196 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752340AbZLUPUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 10:20:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,431,1257148800"; 
   d="scan'208";a="478023961"
Message-ID: <4B2F9212.3000407@linux.intel.com>
Date: Mon, 21 Dec 2009 16:19:46 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org> <1261143924.20899.169.camel@laptop> <20091218135033.GB8678@basil.fritz.box> <4B2B9949.1000608@linux.intel.com> <20091221091754.GG4489@kernel.dk> <4B2F57E6.7020504@linux.intel.com> <4B2F768C.1040704@kernel.org> <4B2F7DD2.2080902@linux.intel.com> <4B2F83F6.2040705@kernel.org>
In-Reply-To: <4B2F83F6.2040705@kernel.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2009 15:19, Tejun Heo wrote:
>
> Ah... okay, there are two aspects cmwq invovles the scheduler.
>
> A. Concurrency management.  This is achieved by the scheduler
>     callbacks which watches how many workers are working.
>
> B. Deadlock avoidance.  This requires migrating rescuers to CPUs under
>     allocation distress.  The problem here is that
>     set_cpus_allowed_ptr() doesn't allow migrating tasks to CPUs which
>     are online but !active (CPU_DOWN_PREPARE).

why would you get involved in what-runs-where at all? Wouldn't the scheduler
load balancer be a useful thing ? ;-)


>
> For A, it's far more efficient and robust with scheduler callbacks.
> It's conceptually pretty simple too.

Assuming you don't get tasks that do lots of cpu intense work and that need
to get preempted etc...like raid5/6 sync but also the btrfs checksumming etc etc.
That to me is the weak spot of the scheduler callback thing. We already have
a whole thing that knows how to load balance and preempt tasks... it's called "scheduler".
Let the scheduler do its job and just give it insight in the work (by having a runnable thread)

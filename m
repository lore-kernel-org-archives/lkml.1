Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbYH1QTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbYH1QTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYH1QTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:19:12 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25376 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYH1QTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:19:11 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5372"; a="6103717"
Message-ID: <48B6CFFD.2050801@qualcomm.com>
Date: Thu, 28 Aug 2008 09:19:09 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
References: <20080819103301.787700742@chello.nl> <alpine.LFD.1.10.0808262228030.3243@apollo.tec.linutronix.de> <874p57s873.fsf@basil.nowhere.org> <200808272008.16106.nickpiggin@yahoo.com.au> <20080828105408.GA4488@elte.hu> <20080828110923.GL26610@one.firstfloor.org> <1219922353.6443.14.camel@twins> <20080828115035.GM26610@one.firstfloor.org>
In-Reply-To: <20080828115035.GM26610@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Thu, Aug 28, 2008 at 01:19:13PM +0200, Peter Zijlstra wrote:
>> On Thu, 2008-08-28 at 13:09 +0200, Andi Kleen wrote:
>>>> Even if the system has multiple CPUs, and even if just a single CPU is
>>>> fully utilized by an RT task, without the rt-limit the system will still
>>>> lock up in practice due to various other factors: workqueues and tasks
>>>> being 'stuck' on CPUs that host an RT hog.
>>> The load balancer will not notice that a particular CPU is busy
>>> with real time tasks?
>> Not currently, working on that though.
> 
> I wonder if it would make sense to break affinities in extreme case?
> With that even the workqueues would work again.

Please lets not break affinity :).

I'm going to submit patches (soonish) that convert drivers/etc to use 
cancel_work_sync()/flush_work() instead of flush_scheduled_work().
That takes care of the
     "machine getting stuck because workqueue thread is starved"
case.

Max

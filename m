Return-Path: <linux-kernel-owner+w=401wt.eu-S1030901AbXDMX54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030901AbXDMX54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030903AbXDMX5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:57:55 -0400
Received: from holomorphy.com ([66.93.40.71]:36458 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030901AbXDMX5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:57:55 -0400
Date: Fri, 13 Apr 2007 16:58:12 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070413235812.GY2986@holomorphy.com>
References: <20070413202100.GA9957@elte.hu> <20070413222151.GD8915@holomorphy.com> <20070413225216.GA11384@elte.hu> <20070413233049.GW2986@holomorphy.com> <20070413234444.GA23575@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413234444.GA23575@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* William Lee Irwin III <wli@holomorphy.com> wrote:
>> Where it gets complex is when the behavior patterns vary, e.g. they're 
>> not entirely CPU-bound and their desired in-isolation CPU utilization 
>> varies, or when nice levels vary, or both vary. [...]

On Sat, Apr 14, 2007 at 01:44:44AM +0200, Ingo Molnar wrote:
> yes. I tested things like 'massive_intr.c' (attached, written by Satoru 
> Takeuchi) which starts N tasks which each work for 8msec then sleep 
> 1msec:
[...]
> another related test-utility is one i wrote:
>   http://people.redhat.com/mingo/scheduler-patches/ring-test.c
> this is a ring of 100 tasks each doing work for 100 msecs and then 
> sleeping for 1 msec. I usually test this by also running a CPU hog in 
> parallel to it, and checking whether it gets ~50.0% of CPU time under 
> CFS. (it does)

These are both tremendously useful. The code is also in rather good
shape so only minimal modifications (for massive_intr.c I'm not even
sure if any are needed at all) are needed to plug them into the test
harness I'm aware of. I'll queue them both for me to adjust and send
over to testers I don't want to burden with hacking on testcases I
myself am asking them to add to their suites.


-- wli

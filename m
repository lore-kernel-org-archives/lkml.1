Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbYH1LG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbYH1LG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 07:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYH1LGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 07:06:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52803 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYH1LGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 07:06:51 -0400
Date: Thu, 28 Aug 2008 13:09:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Message-ID: <20080828110923.GL26610@one.firstfloor.org>
References: <20080819103301.787700742@chello.nl> <alpine.LFD.1.10.0808262228030.3243@apollo.tec.linutronix.de> <874p57s873.fsf@basil.nowhere.org> <200808272008.16106.nickpiggin@yahoo.com.au> <20080828105408.GA4488@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828105408.GA4488@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Even if the system has multiple CPUs, and even if just a single CPU is 
> fully utilized by an RT task, without the rt-limit the system will still 
> lock up in practice due to various other factors: workqueues and tasks 
> being 'stuck' on CPUs that host an RT hog. 

The load balancer will not notice that a particular CPU is busy
with real time tasks?

> While there's obviously CPU 
> time available on other CPUs, you cannot run 'top', the desktop will 
> freeze, work flows of the system can be stuck, etc, etc..

I had such a situation at least once in the past (not due
run away RT but due a kernel bug) and even with 2 out of 4 CPUs blocked 
the system was still quite usable. top/kill definitely worked.  The system 
didn't have a desktop, but I didn't notice many problems in shell use. 
Ok it's just one sample.

That said I don't think having such a limit by default is a bad idea actually.

Just handling it in the scheduler anyways is also probably good because
it can happen even due to other issues than just run away RT tasks.

-Andi

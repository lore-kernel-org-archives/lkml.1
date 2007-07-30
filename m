Return-Path: <linux-kernel-owner+w=401wt.eu-S967847AbXG3UEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967847AbXG3UEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967382AbXG3UEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:04:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:12002 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763715AbXG3UEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:04:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,200,1183359600"; 
   d="scan'208";a="111522877"
Subject: Re: [patch] sched: yield debugging
From: Tim Chen <tim.c.chen@linux.intel.com>
Reply-To: tim.c.chen@linux.intel.com
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070729173735.GA4041@elte.hu>
References: <1185573687.19777.44.camel@localhost.localdomain>
	 <20070729173735.GA4041@elte.hu>
Content-Type: text/plain
Organization: Intel
Date: Mon, 30 Jul 2007 11:10:52 -0700
Message-Id: <1185819052.19777.52.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-29 at 19:37 +0200, Ingo Molnar wrote:
> Tim,
> 
> * Tim Chen <tim.c.chen@linux.intel.com> wrote:
> 

> 
> Could you try the patch below? It does not change the default behavior 
> of yield but introduces 2 other yield strategies which you can activate 
> runtime (if CONFIG_SCHED_DEBUG=y) via:
> 
>   # default one:
>   echo 0 > /proc/sys/kernel/sched_yield_bug_workaround
> 
>   # always queues the current task next to the next task:
>   echo 1 > /proc/sys/kernel/sched_yield_bug_workaround
> 
>   # NOP:
>   echo 2 > /proc/sys/kernel/sched_yield_bug_workaround
> 
> does variant '1' improve Java's VolanoMark performance perhaps?
> 

Here's a summary of Volanomark performance numbers:
Variant 0 is 80% down from 2.6.22
Variant 1 is 20% down from 2.6.22  (this is indeed helped)
Variant 2 is 89% down from 2.6.22

> i'm also wondering, which JDK is this, and where does Java make use of 
> sys_sched_yield()? It's a voefully badly defined (and thus unreliable) 
> system call, IMO Java should stop using it ASAP and use a saner locking 
> model.

I am using a JRockit JDK.

Thanks.
Tim

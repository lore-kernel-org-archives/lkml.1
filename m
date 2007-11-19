Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbXKSPyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbXKSPyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbXKSPyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:54:11 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52085 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529AbXKSPyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:54:09 -0500
Date: Mon, 19 Nov 2007 21:36:47 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 2/2] sched: Improve fairness of cpu allocation for task groups
Message-ID: <20071119160647.GV3359@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071119122713.GA28777@linux.vnet.ibm.com> <20071119123051.GC28777@linux.vnet.ibm.com> <20071119131201.GB31491@elte.hu> <20071119150312.GA2365@linux.vnet.ibm.com> <20071119152258.GB31426@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119152258.GB31426@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 04:22:58PM +0100, Ingo Molnar wrote:
> 
> * Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> 
> > - inc/dec_load() takes a load input instead of task pointer input as their
> >   2nd arg
> > - inc/dec_nr_running don't call inc/dec_load. Instead,
> > - enqueue/dequeue_task class callbacks call inc/dec_load
> > - [Unintended/will-fix change] min/max tunables added in
> >   /proc/sys/kernel
> > 
> > All of above changes (except last, which I will fix) should have zero 
> > functional+runtime effect for !CONFIG_FAIR_GROUP_SCHED case. So I 
> > don't see how I can split Patch 2/2 further.
> 
> ok, as long as it's NOP for the CONFIG_FAIR_GROUP_SCHED, we could try 
> it.

Ok ..thx. I was begining to make changes to avoid even the above minor changes 
for !CONFIG_FAIR_GROUP_SCHED case, but it doesn't look neat, hence will drop
that effort.

I am fixing other problems observed with Patch 1/2 (usage of a mutex to
serialize create/destroy groups) and will resend the series very soon.

-- 
Regards,
vatsa

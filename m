Return-Path: <linux-kernel-owner+w=401wt.eu-S1762784AbYCGNzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762784AbYCGNzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 08:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758460AbYCGNzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 08:55:42 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:55322 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757726AbYCGNzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 08:55:41 -0500
Date: Fri, 7 Mar 2008 19:25:37 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Yi Yang <yi.y.yang@intel.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are
	dealocked when cpu is set to offline
Message-ID: <20080307135537.GB10576@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com> <20080303153154.GA11288@in.ibm.com> <1204555505.3842.4.camel@yangyi-dev.bj.intel.com> <20080304052613.GA28632@in.ibm.com> <20080304150107.GA564@tv-sign.ru> <20080306134400.GA1915@in.ibm.com> <20080307025451.GA201@tv-sign.ru> <20080307091049.GA8827@in.ibm.com> <20080307105138.GA10576@in.ibm.com> <b647ffbd0803070502m28355751rd526ed8ca4dd90a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0803070502m28355751rd526ed8ca4dd90a@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 02:02:20PM +0100, Dmitry Adamushko wrote:
> Hi,
> 
> 'watchdog' is of SCHED_FIFO class. The standard load-balancer doesn't
> move RT tasks between cpus anymore and there is a special mechanism in
> scher_rt.c instead (I think, it's .25 material).
> 
> So I wonder, whether __migrate_task() is still capable of properly
> moving a RT task to another CPU (e.g. for the case when it's in
> TASK_RUNNING state) without breaking something in the rt migration
> mechanism (or whatever else) that would leave us with a runqueue in
> the 'inconsistent' state...
> (I've taken a quick look at the relevant code so can't confirm it yet)
> 
> maybe it'd be faster if somebody could do a quick test now with the
> following line commented out in kernel/softlockup.c :: watchdog()
> 
> -         sched_setscheduler(current, SCHED_FIFO, &param);

Commenting out that like seems to work. Passed 500 iterations of
cpu-hotplug without any problems.

> 
> 
> -- 
> Best regards,
> Dmitry Adamushko

-- 
Thanks and Regards
gautham

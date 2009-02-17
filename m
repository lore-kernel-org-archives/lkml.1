Return-Path: <linux-kernel-owner+w=401wt.eu-S1751921AbZBQFBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbZBQFBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbZBQFBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:01:06 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:46621 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbZBQFBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:01:05 -0500
Date: Tue, 17 Feb 2009 10:30:33 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Corey Hickey <bugfood-ml@fatooh.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, mtk.manpages@gmail.com
Subject: Re: RT scheduling and a way to make a process hang, unkillable
Message-ID: <20090217050033.GA10409@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <4997672B.1000301@fatooh.org> <1234697096.4713.24.camel@laptop> <20090216103636.GC17355@linux.vnet.ibm.com> <1234782516.4703.15.camel@laptop> <20090216120213.GB3925@linux.vnet.ibm.com> <1234787082.30178.3.camel@laptop> <20090216131440.GC3925@linux.vnet.ibm.com> <20090216132014.GD3925@linux.vnet.ibm.com> <4999BC0C.1010304@fatooh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4999BC0C.1010304@fatooh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 11:18:36AM -0800, Corey Hickey wrote:
> Dhaval Giani wrote:
> > And it continues on! Please try this version.
> > 
> > sched: Don't allow setuid to succeed if the user does not have rt bandwidth
> > 
> > Corey Hickey reported that on using setuid to change the uid of a
> > rt process, the process would be unkillable and not be running.
> > This is because there was no rt runtime for that user group. Add
> > in a check to see if a user can attach an rt task to its task group.
> > 
> > Disclaimer: Not sure about the return values, and if setuid allows
> > return values other than EPERM and EAGAIN.
> > 
> > Changes from v3:
> > 1. Actually fix the leak.
> > 
> > Changes from v2:
> > 1. Patch compiles for CONFIG_CGROUP_SCHED as well
> > 2. Fix two memory leaks.
> > 
> > Changes from v1:
> > 1. Peter suggested that rt_task_can_change_user should be renamed to
> > task_can_change_user
> > 2. Changed sched_rt_can_attach to boolean.
> > 
> > Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 
> Thank you, Peter and Dhaval, for looking at this. I appreciate your work.
> 
> I tested patch v4 on 2.6.29-rc5, and I get frequent kernel BUG messages.
> Should I be testing your patch on a different source tree? The patch
> applied to rc5 ok but with lots of offsets.
> 

This was on top of tip I think. But yeah, that would be expected.
Yesterday was really not working out, I figured out this one, and had
fixed this in the next version. I have a better patch arond here.

thanks,
-- 
regards,
Dhaval

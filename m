Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713AbYI3LkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbYI3LkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYI3LkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:40:10 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58276 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbYI3LkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:40:08 -0400
Date: Tue, 30 Sep 2008 17:10:00 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org,
       vatsa@linux.vnet.ibm.com, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] sched: minor optimizations in wake_affine and
	select_task_rq_fair
Message-ID: <20080930114000.GA14977@amitarora.in.ibm.com>
References: <20080929100227.GA21129@amitarora.in.ibm.com> <48E0FDC5.1080500@nortel.com> <20080930070158.GA12465@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930070158.GA12465@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 09:01:58AM +0200, Ingo Molnar wrote:
> 
> * Chris Friesen <cfriesen@nortel.com> wrote:
> 
> > Amit K. Arora wrote:
> >> Hello,
> >>
> >> Please consider this patch. It makes a few minor changes to
> >> sched_fair.c.
> >>
> >>
> >> sched: Minor optimizations in wake_affine and select_task_rq_fair
> >>
> >> This patch does following:
> >> o Reduces the number of arguments to wake_affine().
> >
> > At what point is it cheaper to pass items as args rather than 
> > recalculating them?  If reducing the number of args is desirable, what 
> > about removing the "this_cpu" and "prev_cpu" args and recalculating 
> > them in wake_affine()?
> 
> it's usually not worth it, especially if it leads to duplicated 
> calculations (and code) like:
> 
> +       unsigned int imbalance = 100 + (this_sd->imbalance_pct - 100) / 2;
> 
> gcc will optimize it away because it's all static functions, but still.

Ok. I will resubmit the patch with other suggested changes only. It
won't try to reduce wake_affine's arguments (besides the first argument
"rq" which is not being used at all). 

Regards,
Amit Arora
> 
> 'size kernel/sched.o' should be a good guideline: if the .o's text 
> section gets smaller due to a patch it usually gets faster as well.
> 
> 	Ingo

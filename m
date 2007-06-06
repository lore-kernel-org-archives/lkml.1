Return-Path: <linux-kernel-owner+w=401wt.eu-S1757103AbXFFJIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbXFFJIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760581AbXFFJIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:08:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:15089 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775AbXFFJIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:08:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EwyVF+ll1Vxyo4uWKo/Zq+nAjnl2korTHG1mEs3GBKzZiF7+pHOM2iPt+I2hCkaS3rrDEAI8vvEMiDMJWWoHIwQ6JVDMvPyPN3X+EtKWiLNcdGJ9mhseWre+1kJzpo5FQ+6RcFSUiO/OPxJhmK1Az8G+SXvbRZ+yhfAHh9H/cLg=
Message-ID: <b647ffbd0706060208i5666f57eoe96215b636617622@mail.gmail.com>
Date: Wed, 6 Jun 2007 11:08:07 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: vatsa@in.ibm.com
Subject: Re: [patch] CFS scheduler, -v15
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070606074317.GB3274@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070531150908.GA23538@elte.hu>
	 <20070606064228.GA22443@in.ibm.com> <20070606070143.GA7375@elte.hu>
	 <20070606074317.GB3274@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> On Wed, Jun 06, 2007 at 09:01:43AM +0200, Ingo Molnar wrote:
> > [...] and my tree already contains the fixes for rt task's
> > exec_start.
>
> Can I have this snapshot pls? I have to deal with the same issue when
> the current task switches groups and I was planning to fix it by
> introducing a set_curr_task() method in fair_sched_class which
> initializes exec_start and other fields for that task.

Hum.. what about accounting 'exec_time' and updating 'exec_start' in
rt_sched :: dequeue_task_rt() instead (like update_curr() does it in
dequeue_task_fair())?

This way, on RT -> NORMAL transition.. some 'delta_exec' ( between
deactivate_task() ---> activate_task() ) will be accounted later as if
the task was 'sched_fair_class' during this time.. which I think makes
some sense. What do you think?

sched_setscheduler()
{
...
        on_rq = p->on_rq;
        if (on_rq)
                deactivate_task(rq, p, 0);
        oldprio = p->prio;
        __setscheduler(rq, p, policy, param->sched_priority);
        if (on_rq) {
                activate_task(rq, p, 0);
...


> --
> Regards,
> vatsa
>

-- 
Best regards,
Dmitry Adamushko

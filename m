Return-Path: <linux-kernel-owner+w=401wt.eu-S939688AbXG3VFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939688AbXG3VFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936837AbXG3VFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:05:40 -0400
Received: from cb2.northrockquote.com ([64.251.14.146]:1291 "EHLO
	dejavu.debianpt.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S936806AbXG3VFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:05:39 -0400
From: Miguel Figueiredo <elmig@debianpt.org>
Organization: DebianPT.org
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Date: Mon, 30 Jul 2007 22:05:15 +0100
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707301704.29670.elmig@debianpt.org> <20070730183804.GB20901@elte.hu>
In-Reply-To: <20070730183804.GB20901@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707302205.15790.elmig@debianpt.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Segunda, 30 de Julho de 2007 19:38, Ingo Molnar escreveu:
> * Miguel Figueiredo <elmig@debianpt.org> wrote:
> > in mainline (2.6.22):
> > /**
> >  * sys_sched_yield - yield the current processor to other threads.
> >  *
> >  * This function yields the current CPU by moving the calling thread
> >  * to the expired array. If there are no other threads running on this
> >  * CPU then this function will return.
> >  */
> >

[...]

> this is what CFS does:
>
>   static void yield_task_fair(struct rq *rq, struct task_struct *p)
>   {
>           struct cfs_rq *cfs_rq = task_cfs_rq(p);
>           u64 now = __rq_clock(rq);
>
>           /*
>            * Dequeue and enqueue the task to update its
>            * position within the tree:
>            */
>           dequeue_entity(cfs_rq, &p->se, 0, now);
>           enqueue_entity(cfs_rq, &p->se, 0, now);
>   }
>
> 	Ingo

So the difference from mainline (2.6.22) is that now you removed 
requeue_task(), is that it?
-- 

Com os melhores cumprimentos/Best regards,

Miguel Figueiredo
http://www.DebianPT.org

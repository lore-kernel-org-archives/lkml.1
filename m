Return-Path: <linux-kernel-owner+w=401wt.eu-S936643AbXHHXpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936643AbXHHXpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763106AbXHHXpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:45:10 -0400
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:45017
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761471AbXHHXpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:45:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=MSqALTHSluhhQ+svMU4hSTU1xHiV7F31DsrpEPanoMuRE9qDhtvhjeIBNBH/gVBX;
  h=Received:Message-ID:Reply-To:From:To:Cc:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE:X-ELNK-Trace:X-Originating-IP;
Message-ID: <000501c7da16$838dea40$6501a8c0@earthlink.net>
Reply-To: "Mitchell Erblich" <erblichs@earthlink.net>
From: "Mitchell Erblich" <erblichs@earthlink.net>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Question: RT schedular : task_tick_rt(struct rq *rq, structtask_struct *p) : decreases overhead when  rq->nr_running == 1
Date: Wed, 8 Aug 2007 16:47:31 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1106
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1106
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec7966f9cbfe833bd8aed8c6fdeea71422a8350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.164.93.14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar and group,

First, RT/RR tasks are not deprecated.  This
change simply removes sched overhead while
only 1 RT/RR task is runable per rq.

The code size increase is minor and is a very
straightforward change..

THUS...

    My assumption is / was to hand you/Ingo Molnar this change
    because,
        * you have the latest scheduler git tree and do periodic
           pull requests, so I consider you the default scheduler
           maintainer ....   : ^ )
        * my scheduler tree is more developmental,
        * and I wish to first suggest minor changes over time to see
           what scheduler changes are more acceptable.

  Mitchell Erblich
----------------------


Ingo Molnar wrote:
>
> * Mitchell Erblich <erblichs@earthlink.net> wrote:
>
> > After
> >     p->time_slice = static_prio_timeslice(p->static_prio);
> >
> > Why isn't their a check like
> >     if  (rq->nr_running == 1)
> >          return;
> >
> > Which world remove the need for any recheduling or requeue'ing...
>
> your change is a possible optimization, but this is a pretty rare
> codepath because the overwhelming majority of RT apps uses SCHED_FIFO.
> Plus, the time_slice going down to 0 is a relatively rare event even for
> SCHED_RR tasks. And if we have only a single SCHED_RR task, why is it
> SCHED_RR to begin with? So this is on several levels an uncommon
> workload and by adding a check like that we'd increase the codesize. But
> ... no strong feelings against this optimization - if you send a proper
> patch we can apply it, it certainly makes sense from a logic POV.
>
>         Ingo
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751799AbXB0O4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbXB0O4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbXB0O4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:56:34 -0500
Received: from 195-13-16-24.net.novis.pt ([195.23.16.24]:45468 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbXB0O4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:56:33 -0500
Message-ID: <45E4469C.8000505@grupopie.com>
Date: Tue, 27 Feb 2007 14:56:28 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>,
       Hiro Yoshioka <hyoshiok@miraclelinux.com>, davej@redhat.com,
       harlan@artselect.com, nickpiggin@yahoo.com.au, l_allegrucci@yahoo.it,
       linux-kernel@vger.kernel.org, mingo@elte.hu, suparna@in.ibm.com,
       jens.axboe@oracle.com
Subject: Re: SMP performance degradation with sysbench
References: <20070226223645.GA24174@redhat.com>	<98df96d30702261632u7479c9b2sce93f80f68bbc8d0@mail.gmail.com>	<45E37EA3.3060101@redhat.com>	<20070227.130305.424251739.hyoshiok@miraclelinux.com>	<45E3B421.603@redhat.com> <20070227091409.6f3d12f9@werewolf-wl> <45E439E4.5030703@redhat.com>
In-Reply-To: <45E439E4.5030703@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> J.A. Magallón wrote:
>>[...]
>> Its the same to answer 4+4 queries than 8 at half the speed, isn't it ?
> 
> That still doesn't fix the potential Linux problem that this
> benchmark identified.
> 
> To clarify: I don't care as much about MySQL performance as
> I care about identifying and fixing this potential bug in
> Linux.

IIRC a long time ago there was a change in the scheduler to prevent a 
low prio task running on a sibling of a hyperthreaded processor to slow 
down a higher prio task on another sibling of the same processor.

Basically the scheduler would put the low prio task to sleep during an 
adequate task slice to allow the other sibling to run at full speed for 
a while.

I don't know the scheduler code well enough, but comments like this one 
make me think that the change is still in place:

> 	/*
> 	 * If an SMT sibling task has been put to sleep for priority
> 	 * reasons reschedule the idle task to see if it can now run.
> 	 */
> 	if (rq->nr_running) {
> 		resched_task(rq->idle);
> 		ret = 1;
> 	}

If that is the case, turning off CONFIG_SCHED_SMT would solve the problem.

-- 
Paulo Marques - www.grupopie.com

"The face of a child can say it all, especially the
mouth part of the face."

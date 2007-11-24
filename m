Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbXKWNZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbXKWNZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 08:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbXKWNZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 08:25:03 -0500
Received: from ns2.suse.de ([195.135.220.15]:55964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbXKWNZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 08:25:00 -0500
Message-ID: <47482675.80602@suse.de>
Date: Sat, 24 Nov 2007 18:56:13 +0530
From: Nikanth Karthikesan <knikanth@suse.de>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       vatsa@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [PATCH] sched: minor optimization
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Nov 23, 2007 at  5:48 PM, "Dmitry Adamushko"
<dmitry.adamushko@gmail.com> wrote:
> The only legitimate possibility of having the fair_sched_class
> returning no task in this case is when 'rq->nr_running ==
> rq->cfs.nr_running == 0'.

Yes, I think so.

> iow, a possible optimization would be just the following check :
>
> if (rq->nr_running == 0)
>         return idle_sched_class.pick_next_task(rq);
> at the beginning of pick_next_task().
>
> (or maybe put it at the beginning of the
> if (likely(rq->nr_running == rq->cfs.nr_running)) {} block as we
> already have 'likely()' there).
>

But that might add a test before the case we want to optimize the most.
I just thought of taking advantage of a case where we know
rq->nr_running==0, instead of throwing away that information.

Thanks
Nikanth

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751604AbXC0NwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbXC0NwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 09:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbXC0NwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 09:52:04 -0400
Received: from [212.12.190.133] ([212.12.190.133]:32872 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751604AbXC0NwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 09:52:02 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][ 3/5] sched: implement staircase deadline cpu
Date: Tue, 27 Mar 2007 16:55:17 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703271655.17157.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> All tasks are initially given a quota based on RR_INTERVAL. This is equal
> to RR_INTERVAL between nice values of -6 and 0, half that size above nice
> 0, and progressively larger for nice values from -1 to -20.

from -7 to -20.

I suppose this could be policy decision?

> This is
> assigned to p->quota and only changes with changes in nice level.
>
> As a task is first queued, it checks in recalc_task_prio to see if it has
> run at this runqueue's current priority rotation. If it has not, it will
> have its p->prio level set according to the first slot in a "priority
> matrix" and will be given a p->time_slice equal to the p->quota, and has
> its allocation bitmap bit set in p->bitmap for this prio level. It is then
> queued on the current active priority array.

I'm not sure why you need a matrix.  Can't you just deduce this based on 
static_prio and prio?

Also, I wonder if there is something inherently smoother than staircase.


Thanks!

--
Al


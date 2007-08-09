Return-Path: <linux-kernel-owner+w=401wt.eu-S938471AbXHIIYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938471AbXHIIYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 04:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759596AbXHIIYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 04:24:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:38167 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758324AbXHIIYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 04:24:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZVM4YvI0uYYu5y3MEVXdMKmnK9eiOoj5mN2mbtSM5I5nuYMxL8qlt2/ZX+WBd101hLHbwXZopxa1q/i2m0eVhGw9qBOBdBQyV9WxSl6PIUNQp6P9ISYFUGEeir77Uk403pMEwnvzmPQcQRdYiyF6yaKJCTvWkJtAHUzkEpH7prk=
Message-ID: <b647ffbd0708090124i2671c73g69148244284b2d0c@mail.gmail.com>
Date: Thu, 9 Aug 2007 10:24:21 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Mitchell Erblich" <erblichs@earthlink.net>
Subject: Re: Question : sched_rt.c : Loss of stats?? requeue_task_rt() does not call update_curr_rt() which updates stats
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <001001c7da42$8022a7c0$6501a8c0@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <001001c7da42$8022a7c0$6501a8c0@earthlink.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/07, Mitchell Erblich <erblichs@earthlink.net> wrote:
> sched_rt.c : requeue_task_rt()
>
> The comment states the problem requeue no dequeue.
> Put task to the end of the run list without the overhead of dequeue
> followed by enqueue.
>
> dequeue_task_rt() updates stats. Where without calling
> it will skip the stat update.
>
> Thus, shouldn't  requeue_task_rt() call
>   update_curr_rt(rq); ???

No. As update_curr_rt() suggests it's only about collecting runtime
statistics, namely
(a) the longest interval of time a given task was consuming a CPU
(i.e. == 'current') and
(b) the total amount of time it was running.

To this goal, it would be enough to call it only in
put_prev_task_rt().. I recall, we do it in dequeue_task_rt() to catch
a case of SCHED_RR/FIFO --> SCHED_NORMAL transition (e.g. in
sched_setscheduler()).. so that may make accounting a bit less precise
for (a).


-- 
Best regards,
Dmitry Adamushko

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbXEaJpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbXEaJpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757271AbXEaJpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:45:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:64912 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472AbXEaJpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:45:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=pOdwTA9tH90BDDwDAzoLck9J6srHQCG7kQNQDmoGa8RGTPjpCmy7PhjOnhAAK//0xPBaNSbXrwtLNTWslRa3hguLudHLlFnBvFiRBrG+Uyp9Kfofat9kzT5Yg91biAKBl6OAMC/eOBw3xLqX1a9FPlXrubKHYI3RgHJgmRt2N0k=
Message-ID: <465E992C.4020601@gmail.com>
Date: Thu, 31 May 2007 17:45:16 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v14
References: <20070523120616.GA23407@elte.hu> <4658F1D6.3070706@gmail.com> <20070529061544.GA28523@elte.hu> <20070529080738.GA28657@elte.hu>
In-Reply-To: <20070529080738.GA28657@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


static void distribute_fair_add(struct rq *rq, s64 delta)
{
    struct task_struct *curr = rq->curr;
    s64 delta_fair = 0;

    if (!(sysctl_sched_load_smoothing & 32))
        return;

    if (rq->nr_running) {
        delta_fair = div64_s(delta, rq->nr_running);
        /*
         * The currently running task's next wait_runtime value does
         * not depend on the fair_clock, so fix it up explicitly:
         */
        add_wait_runtime(rq, curr, -delta_fair);
        rq->fair_clock -= delta_fair;
    }
}

See this line:

        delta_fair = div64_s(delta, rq->nr_running);

Ingo, should we be replace "rq->nr_running" with "rq->raw_load_weight" here?

Good luck
- Li Yu





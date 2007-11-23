Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbXKWMSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbXKWMSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 07:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbXKWMSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 07:18:23 -0500
Received: from nz-out-0506.google.com ([64.233.162.236]:40606 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbXKWMSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 07:18:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eHX5vefyihrr6/2q/tNv3sijjMoavqvNkoonEeoiiAGFz1nFfk1N/R4KtHQalKZzZcueq8SdhThs8rAx2cSdBn9H61GscZj8x7hL6k7YJg00LjDKXSCWyo6ZNCYQKGDAwIDoxjqFmEwvYZOZt3BMPnxjoE6dkmDsDF+B9ciFOKE=
Message-ID: <b647ffbd0711230418i67434250t6ab0f05738eb3f5e@mail.gmail.com>
Date: Fri, 23 Nov 2007 13:18:20 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Nikanth Karthikesan" <knikanth@suse.de>
Subject: Re: [PATCH] sched: minor optimization
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       vatsa@linux.vnet.ibm.com
In-Reply-To: <47480F2D.3030408@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47480F2D.3030408@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/11/2007, Nikanth Karthikesan <knikanth@suse.de> wrote:
> As an optimization, if all tasks are in the fair class, the next task is
> directly picked from fair_sched_class. But, if it returns no task we go
> through again from sched_class_highest which could be avoided and
> instead return the idle task directly.

The only legitimate possibility of having the fair_sched_class
returning no task in this case is when 'rq->nr_running ==
rq->cfs.nr_running == 0'.

iow, a possible optimization would be just the following check :

if (rq->nr_running == 0)
        return idle_sched_class.pick_next_task(rq);

at the beginning of pick_next_task().

(or maybe put it at the beginning of the
if (likely(rq->nr_running == rq->cfs.nr_running)) {} block as we
already have 'likely()' there).


-- 
Best regards,
Dmitry Adamushko

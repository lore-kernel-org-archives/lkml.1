Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbZKZJDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbZKZJDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760039AbZKZJDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:03:49 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57251 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759970AbZKZJDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:03:47 -0500
Date: Thu, 26 Nov 2009 10:03:53 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/4] cfq-iosched: policy fixes
Message-ID: <20091126090353.GR8742@kernel.dk>
References: <200911241448.29871.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911241448.29871.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24 2009, Corrado Zoccolo wrote:
> Hi Jens,
> I've collected some bugfixes to the for-2.6.33 branch.
> Excluding the NCQ policy fix, that I'm resending with improved changelog,
> the bugs were found by Vivek while investingating performance drops
> or unfairness while testing cgroups. Nevertheless, those fixes have
> general impact, so they should go in before cgroup code is merged:
> * no-idle preemption logic was both under/over preempting.
>    it should preempt only if the active queue is idling due to
>    no-idle service tree empty
> * seeky queues with large depth could steal too much bandwidth to
>    low depth ones, so they will be marked as idling, and have exclusive
>    access to disk for their time share
> * the idling logic had some corner cases in which idling was not enabled,
>   even if it should have been, caused by rq_noidle and rq_in_driver checks.
>   Those were adjusted to better match the original intention.

Thanks Corrado, applied all 4!

-- 
Jens Axboe


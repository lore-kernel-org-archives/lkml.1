Return-Path: <linux-kernel-owner+w=401wt.eu-S1751596AbZHSDhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbZHSDhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 23:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbZHSDhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 23:37:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56498 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbZHSDhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 23:37:13 -0400
Message-ID: <4A8B7336.7010800@cn.fujitsu.com>
Date: Wed, 19 Aug 2009 11:36:22 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com
Subject: Re: [PATCH 03/24] io-controller: Common flat fair queuing code in
 elevaotor layer
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-4-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1250451046-9966-4-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...

> +
> +static void elv_preempt_queue(struct request_queue *q, struct io_queue *ioq)
> +{
> +	elv_log_ioq(q->elevator->efqd, ioq, "preempt");
> +	elv_slice_expired(q);
> +
> +	/*
> +	 * Put the new queue at the front of the of the current list,
> +	 * so we know that it will be selected next.
> +	 */
> +
> +	requeue_ioq(ioq);
> +	ioq->slice_start = ioq->slice_end = 0;

I think this assignment is redundant because these two members will be reset
when this ioq is scheduled.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index d04e925..b3c387d 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -2650,7 +2650,6 @@ static void elv_preempt_queue(struct request_queue *q, struct io_queue *ioq)
 		 */
 
 		requeue_ioq(ioq);
-		ioq->slice_start = ioq->slice_end = 0;
 		elv_mark_ioq_slice_new(ioq);
 	}
 }
-- 
1.5.4.rc3




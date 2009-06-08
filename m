Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbZFHHqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbZFHHqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 03:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZFHHqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 03:46:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62336 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbZFHHqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 03:46:05 -0400
Message-ID: <4A2CC15F.2010708@cn.fujitsu.com>
Date: Mon, 08 Jun 2009 15:44:31 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 02/20] io-controller: Common flat fair queuing code in
 elevaotor layer
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com> <1243377729-2176-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1243377729-2176-3-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
> +
> +static inline pid_t elv_ioq_pid(struct io_queue *ioq)
> +{
> +	return ioq->pid;
> +}
> +
> +static inline unsigned long elv_ioq_ttime_mean(struct io_queue *ioq)
> +{
> +	return ioq->ttime_mean;
> +}
> +
> +static inline unsigned long elv_ioq_sample_valid(struct io_queue *ioq)
> +{
> +	return ioq_sample_valid(ioq->ttime_samples);
> +}
> +

These three functions are dead now, just remove them.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.h |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/block/elevator-fq.h b/block/elevator-fq.h
index 24a3af9..b2bb11a 100644
--- a/block/elevator-fq.h
+++ b/block/elevator-fq.h
@@ -452,21 +452,6 @@ static inline int elv_ioq_nr_queued(struct io_queue *ioq)
 	return ioq->nr_queued;
 }
 
-static inline pid_t elv_ioq_pid(struct io_queue *ioq)
-{
-	return ioq->pid;
-}
-
-static inline unsigned long elv_ioq_ttime_mean(struct io_queue *ioq)
-{
-	return ioq->ttime_mean;
-}
-
-static inline unsigned long elv_ioq_sample_valid(struct io_queue *ioq)
-{
-	return ioq_sample_valid(ioq->ttime_samples);
-}
-
 static inline void elv_get_ioq(struct io_queue *ioq)
 {
 	atomic_inc(&ioq->ref);
-- 
1.5.4.rc3


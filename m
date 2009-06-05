Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbZFEJhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbZFEJhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZFEJho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:37:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53443 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbZFEJhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:37:43 -0400
Message-ID: <4A28E710.5080307@cn.fujitsu.com>
Date: Fri, 05 Jun 2009 17:36:16 +0800
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
Subject: Re: [PATCH 05/20] io-controller: Common hierarchical fair queuing
 code in elevaotor layer
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com> <1243377729-2176-6-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1243377729-2176-6-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
> +#ifdef CONFIG_GROUP_IOSCHED
> +extern int io_group_allow_merge(struct request *rq, struct bio *bio);
> +extern void io_ioq_move(struct elevator_queue *e, struct io_queue *ioq,

io_ioq_move is not used anymore, removing the dead code.

Singed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.h |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/block/elevator-fq.h b/block/elevator-fq.h
index 1c99e83..24a3af9 100644
--- a/block/elevator-fq.h
+++ b/block/elevator-fq.h
@@ -537,8 +537,6 @@ static inline struct io_group *ioq_to_io_group(struct io_queue *ioq)
 
 #ifdef CONFIG_GROUP_IOSCHED
 extern int io_group_allow_merge(struct request *rq, struct bio *bio);
-extern void io_ioq_move(struct elevator_queue *e, struct io_queue *ioq,
-					struct io_group *iog);
 static inline bfq_weight_t iog_weight(struct io_group *iog)
 {
 	return iog->entity.weight;
@@ -588,15 +586,6 @@ static inline int update_requeue(struct io_queue *ioq, int requeue)
 }
 
 #else /* !GROUP_IOSCHED */
-/*
- * No ioq movement is needed in case of flat setup. root io group gets cleaned
- * up upon elevator exit and before that it has been made sure that both
- * active and idle tree are empty.
- */
-static inline void io_ioq_move(struct elevator_queue *e, struct io_queue *ioq,
-					struct io_group *iog)
-{
-}
 
 static inline int io_group_allow_merge(struct request *rq, struct bio *bio)
 {
-- 
1.5.4.rc3



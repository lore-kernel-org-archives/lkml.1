Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbZFEJSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbZFEJSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbZFEJSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:18:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64533 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbZFEJSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:18:34 -0400
Message-ID: <4A28E293.90402@cn.fujitsu.com>
Date: Fri, 05 Jun 2009 17:17:07 +0800
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
Subject: Re: [PATCH 10/20] io-conroller: Prepare elevator layer for single
 queue schedulers
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com> <1243377729-2176-11-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1243377729-2176-11-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> +				e->ops->elevator_free_sched_queue_fn(e,
> +							sched_q);
> +				sched_q = NULL;
> +				goto queue_fail;
> +			}
> +		}
> +
> +		elv_init_ioq(e, ioq, iog, sched_q, IOPRIO_CLASS_BE, 4, 1);

It's better to use IOPRIO_NORM here.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index f1179aa..3c5f9da 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -2403,7 +2403,8 @@ alloc_ioq:
 			}
 		}
 
-		elv_init_ioq(e, ioq, iog, sched_q, IOPRIO_CLASS_BE, 4, 1);
+		elv_init_ioq(e, ioq, iog, sched_q, IOPRIO_CLASS_BE,
+			     IOPRIO_NORM, 1);
 		io_group_set_ioq(iog, ioq);
 		elv_mark_ioq_sync(ioq);
 		elv_get_iog(iog);
-- 
1.5.4.rc3


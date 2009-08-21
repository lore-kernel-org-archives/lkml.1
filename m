Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbZHUByy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbZHUByy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 21:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZHUByx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 21:54:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56949 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbZHUByw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 21:54:52 -0400
Message-ID: <4A8DFE3A.6030503@cn.fujitsu.com>
Date: Fri, 21 Aug 2009 09:54:02 +0800
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
Subject: Re: [PATCH 02/24] io-controller: Core of the elevator fair queuing
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1250451046-9966-3-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
> +
> +static void put_prev_io_entity(struct io_entity *entity)
> +{
> +	struct io_service_tree *st = entity->st;
> +	struct io_sched_data *sd = io_entity_sched_data(entity);
> +
> +	st->active_entity = NULL;
> +	sd->active_entity = NULL;
> +
> +	if (unlikely(entity->ioprio_changed)) {
> +		dequeue_io_entity(entity);
> +		io_entity_update_prio(entity);

Hi Vivek,

we don't need to update prio here for the following enqueue_io_entity() 
is already taking care of it.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 201543e..b720139 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -607,7 +607,6 @@ static void put_prev_io_entity(struct io_entity *entity)
 
 	if (unlikely(entity->ioprio_changed)) {
 		dequeue_io_entity(entity);
-		io_entity_update_prio(entity);
 		enqueue_io_entity(entity);
 	} else
 		__enqueue_io_entity(st, entity);
-- 
1.5.4.rc3



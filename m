Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZLHHrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZLHHrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZLHHrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:47:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51348 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbZLHHrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:47:51 -0500
Message-ID: <4B1E03AD.7060606@cn.fujitsu.com>
Date: Tue, 08 Dec 2009 15:43:41 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] cfq: Optimization for close cooperating queue searching
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't make any sense to try to find out a close cooperating 
queue if current cfqq is the only one in the group.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index cfb0b2f..89b5dd9 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1750,6 +1750,12 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 		return NULL;
 
 	/*
+	 * Don't search priority tree if it's the only queue in the group.
+	 */
+	if (cur_cfqq->cfqg->nr_cfqq == 1)
+		return NULL;
+
+	/*
 	 * We should notice if some of the queues are cooperating, eg
 	 * working closely on the same area of the disk. In that case,
 	 * we can group them together and don't waste time idling.
-- 
1.5.4.rc3


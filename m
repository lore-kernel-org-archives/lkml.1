Return-Path: <linux-kernel-owner+w=401wt.eu-S1751500AbZGaF3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbZGaF3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 01:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZGaF3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 01:29:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56736 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbZGaF3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 01:29:47 -0400
Message-ID: <4A7280F8.1070401@cn.fujitsu.com>
Date: Fri, 31 Jul 2009 13:28:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Nikanth Karthikesan <knikanth@novell.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] io context: fix ref counting
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d9c7d394a8ebacb60097b192939ae9f15235225e
("block: prevent possible io_context->refcount overflow") mistakenly
changed atomic_inc(&ioc->nr_tasks) to atomic_long_inc(&ioc->refcount).

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/iocontext.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index dd05434..4da4a75 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -92,7 +92,7 @@ static inline struct io_context *ioc_task_link(struct io_context *ioc)
 	 * a race).
 	 */
 	if (ioc && atomic_long_inc_not_zero(&ioc->refcount)) {
-		atomic_long_inc(&ioc->refcount);
+		atomic_inc(&ioc->nr_tasks);
 		return ioc;
 	}
 
-- 
1.6.3

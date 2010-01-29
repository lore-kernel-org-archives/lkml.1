Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340Ab0A2Vpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0A2Vpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 16:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755112Ab0A2Vpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 16:45:31 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:15275 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab0A2Vp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 16:45:29 -0500
Subject: [PATCH 6/7] IB/uverbs: pack struct ib_uverbs_event_file tighter
To: rdreier@cisco.com
From: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 14:45:28 -0700
Message-ID: <20100129214528.17745.56022.stgit@bob.kio>
In-Reply-To: <20100129214039.17745.38679.stgit@bob.kio>
References: <20100129214039.17745.38679.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate some padding in the structure by rearranging the members.

sizeof(struct ib_uverbs_event_file) is now 72 bytes (from 80) and
more members now fit in the first cacheline.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/infiniband/core/uverbs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index e695f65..e54d9ac 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -80,13 +80,13 @@ struct ib_uverbs_device {
 
 struct ib_uverbs_event_file {
 	struct kref				ref;
+	int					is_async;
 	struct ib_uverbs_file		       *uverbs_file;
 	spinlock_t				lock;
+	int					is_closed;
 	wait_queue_head_t			poll_wait;
 	struct fasync_struct		       *async_queue;
 	struct list_head			event_list;
-	int					is_async;
-	int					is_closed;
 };
 
 struct ib_uverbs_file {


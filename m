Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab0BBTMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:12:31 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:16609 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186Ab0BBTIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:08:15 -0500
Subject: [PATCH v2 06/18] IB/uverbs: pack struct ib_uverbs_event_file tighter
To: rdreier@cisco.com
From: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Date: Tue, 02 Feb 2010 12:08:14 -0700
Message-ID: <20100202190814.28217.61115.stgit@bob.kio>
In-Reply-To: <20100202185235.28217.64521.stgit@bob.kio>
References: <20100202185235.28217.64521.stgit@bob.kio>
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab0BBTJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:09:30 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:12304 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab0BBTJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:09:17 -0500
Subject: [PATCH v2 18/18] IB/core: pack struct ib_device a little tighter
To: rdreier@cisco.com
From: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Date: Tue, 02 Feb 2010 12:09:16 -0700
Message-ID: <20100202190916.28217.90954.stgit@bob.kio>
In-Reply-To: <20100202185235.28217.64521.stgit@bob.kio>
References: <20100202185235.28217.64521.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A small change to reduce the size of ib_device to 1112 bytes
(from 1128).

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 include/rdma/ib_verbs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 09509ed..a585e0f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -984,9 +984,9 @@ struct ib_device {
 	struct list_head              event_handler_list;
 	spinlock_t                    event_handler_lock;
 
+	spinlock_t                    client_data_lock;
 	struct list_head              core_list;
 	struct list_head              client_data_list;
-	spinlock_t                    client_data_lock;
 
 	struct ib_cache               cache;
 	int                          *pkey_tbl_len;
@@ -1144,8 +1144,8 @@ struct ib_device {
 		IB_DEV_UNREGISTERED
 	}                            reg_state;
 
-	u64			     uverbs_cmd_mask;
 	int			     uverbs_abi_ver;
+	u64			     uverbs_cmd_mask;
 
 	char			     node_desc[64];
 	__be64			     node_guid;


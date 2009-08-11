Return-Path: <linux-kernel-owner+w=401wt.eu-S932087AbZHKO6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbZHKO6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbZHKO6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:58:04 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:35537 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755046AbZHKO6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:58:03 -0400
From: Michael Spang <mspang@csclub.uwaterloo.ca>
To: Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Michael Spang <mspang@csclub.uwaterloo.ca>
Subject: [PATCH] Revert netlink ABI change to gnet_stats_basic
Date: Tue, 11 Aug 2009 10:58:03 -0400
Message-Id: <1250002683-28554-1-git-send-email-mspang@csclub.uwaterloo.ca>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 5e140dfc1fe87eae27846f193086724806b33c7d "net: reorder struct Qdisc
for better SMP performance" the definition of struct gnet_stats_basic
changed incompatibly, and as copies of this struct may be shipped to
userland via netlink. This reverts back to the old ABI.

Signed-off-by: Michael Spang <mspang@csclub.uwaterloo.ca>
---
 include/linux/gen_stats.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/gen_stats.h b/include/linux/gen_stats.h
index 0ffa41d..13f4e74 100644
--- a/include/linux/gen_stats.h
+++ b/include/linux/gen_stats.h
@@ -22,7 +22,7 @@ struct gnet_stats_basic
 {
 	__u64	bytes;
 	__u32	packets;
-} __attribute__ ((packed));
+};
 
 /**
  * struct gnet_stats_rate_est - rate estimator
-- 
1.6.0.4


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbXIZAyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbXIZAyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 20:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755703AbXIZAyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 20:54:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46716 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579AbXIZAyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 20:54:37 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] fix sctp_del_bind_addr() last argument type
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Message-Id: <E1IaLAe-00085f-9p@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 26 Sep 2007 01:54:32 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It gets pointer to fastcall function, expects a pointer to normal
one and calls the sucker.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/net/sctp/structs.h |    2 +-
 net/sctp/bind_addr.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index c2fe2dc..b942e7e 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1156,7 +1156,7 @@ int sctp_bind_addr_copy(struct sctp_bind_addr *dest,
 int sctp_add_bind_addr(struct sctp_bind_addr *, union sctp_addr *,
 		       __u8 use_as_src, gfp_t gfp);
 int sctp_del_bind_addr(struct sctp_bind_addr *, union sctp_addr *,
-			void (*rcu_call)(struct rcu_head *,
+			void fastcall (*rcu_call)(struct rcu_head *,
 					  void (*func)(struct rcu_head *)));
 int sctp_bind_addr_match(struct sctp_bind_addr *, const union sctp_addr *,
 			 struct sctp_sock *);
diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index d35cbf5..dfffa94 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -181,7 +181,7 @@ int sctp_add_bind_addr(struct sctp_bind_addr *bp, union sctp_addr *new,
  * structure.
  */
 int sctp_del_bind_addr(struct sctp_bind_addr *bp, union sctp_addr *del_addr,
-			void (*rcu_call)(struct rcu_head *head,
+			void fastcall (*rcu_call)(struct rcu_head *head,
 					 void (*func)(struct rcu_head *head)))
 {
 	struct sctp_sockaddr_entry *addr, *temp;
-- 
1.5.3.GIT


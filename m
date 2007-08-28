Return-Path: <linux-kernel-owner+w=401wt.eu-S1763536AbXH1T1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763536AbXH1T1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932409AbXH1TMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:12:31 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:7663 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbXH1TM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:12:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=hDhGtei+U3zM4XnQp+kZo1uerY8Urirl8SQYbh6Rhyj6P9Ay5vb2X5eNboczJKS4boDA0Ff6wha6phNinw4ve8uv8QreSfy3TCxzOQYQ1HeKpjXa7I3FHNJBwbAB0rThQlzHbFvKvbg7NbjyPAHMQjKJMsth8ou74A2QS9XmVwc=
From: Denis Cheng <crquan@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       James Morris <jmorris@namei.org>, Patrick McHardy <kaber@coreworks.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] netlink: use container_of instead
Date: Wed, 29 Aug 2007 03:12:04 +0800
Message-Id: <11883283241594-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.rc5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

this could make future redesign of struct netlink_sock easier.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 net/netlink/af_netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 5681ce3..a78d962 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -88,7 +88,7 @@ struct netlink_sock {
 
 static inline struct netlink_sock *nlk_sk(struct sock *sk)
 {
-	return (struct netlink_sock *)sk;
+	return container_of(sk, struct netlink_sock, sk);
 }
 
 struct nl_pid_hash {
-- 
1.5.3.rc5


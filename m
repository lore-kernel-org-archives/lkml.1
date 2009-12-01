Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbZLAI0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbZLAI0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbZLAIZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:25:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbZLAIZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:25:58 -0500
Date: Tue, 1 Dec 2009 03:26:02 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Amerigo Wang <amwang@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
Message-Id: <20091201082901.4678.16688.sendpatchset@localhost.localdomain>
Subject: [Patch] net: fix an array index overflow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Don't use the address of an out-of-boundary element.

Maybe this is not harmful at runtime, but it is still
good to improve it.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: David S. Miller <davem@davemloft.net>

---
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 57737b8..2669361 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1586,7 +1586,7 @@ static int __init inet_init(void)
 #endif
 
 	/* Register the socket-side information for inet_create. */
-	for (r = &inetsw[0]; r < &inetsw[SOCK_MAX]; ++r)
+	for (r = &inetsw[0]; r <= &inetsw[SOCK_MAX-1]; ++r)
 		INIT_LIST_HEAD(r);
 
 	for (q = inetsw_array; q < &inetsw_array[INETSW_ARRAY_LEN]; ++q)

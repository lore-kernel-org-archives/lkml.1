Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbYDQLM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbYDQLM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933146AbYDQLGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:06:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:41604 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761057AbYDQLGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:06:33 -0400
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 04/12] Netlink: Use generic LSM hook
Date: Thu, 17 Apr 2008 11:06:01 +0000
Message-Id: <a96a55705b6527d8839e05555f2093366ec25dbd.1208428765.git.jmorris@namei.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208430369-23156-1-git-send-email-jmorris@namei.org>
References: <1208430369-23156-1-git-send-email-jmorris@namei.org>
In-Reply-To: <88d8811229b02f6b14ff1f0682dc5502a1f61b41.1208428765.git.jmorris@namei.org>
References: <88d8811229b02f6b14ff1f0682dc5502a1f61b41.1208428765.git.jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ahmed S. Darwish <darwish.07@gmail.com>

Don't use SELinux exported selinux_get_task_sid symbol.
Use the generic LSM equivalent instead.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: James Morris <jmorris@namei.org>
Acked-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Paul Moore <paul.moore@hp.com>
---
 net/netlink/af_netlink.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 1ab0da2..61fd277 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -54,7 +54,6 @@
 #include <linux/mm.h>
 #include <linux/types.h>
 #include <linux/audit.h>
-#include <linux/selinux.h>
 #include <linux/mutex.h>
 
 #include <net/net_namespace.h>
@@ -1239,7 +1238,7 @@ static int netlink_sendmsg(struct kiocb *kiocb, struct socket *sock,
 	NETLINK_CB(skb).pid	= nlk->pid;
 	NETLINK_CB(skb).dst_group = dst_group;
 	NETLINK_CB(skb).loginuid = audit_get_loginuid(current);
-	selinux_get_task_sid(current, &(NETLINK_CB(skb).sid));
+	security_task_getsecid(current, &(NETLINK_CB(skb).sid));
 	memcpy(NETLINK_CREDS(skb), &siocb->scm->creds, sizeof(struct ucred));
 
 	/* What can I do? Netlink is asynchronous, so that
-- 
1.5.4.2


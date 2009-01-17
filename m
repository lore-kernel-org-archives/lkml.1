Return-Path: <linux-kernel-owner+w=401wt.eu-S1764741AbZAQQrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764741AbZAQQrf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758671AbZAQQrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:47:23 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:55728 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060AbZAQQrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:47:22 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 1/1] NET: net_namespace, fix lock imbalance
Date: Sat, 17 Jan 2009 17:47:12 +0100
Message-Id: <1232210832-30041-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

register_pernet_gen_subsys omits mutex_unlock in one fail path.
Fix it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
---
 net/core/net_namespace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 55cffad..55151fa 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -341,8 +341,8 @@ again:
 	rv = register_pernet_operations(first_device, ops);
 	if (rv < 0)
 		ida_remove(&net_generic_ids, *id);
-	mutex_unlock(&net_mutex);
 out:
+	mutex_unlock(&net_mutex);
 	return rv;
 }
 EXPORT_SYMBOL_GPL(register_pernet_gen_subsys);
-- 
1.6.1


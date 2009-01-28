Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbZA1Rxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbZA1Rxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZA1Rxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:53:45 -0500
Received: from cantor.suse.de ([195.135.220.2]:53887 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbZA1Rxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:53:45 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: greg@kroah.com
Cc: chrisw@sous-sol.org, stable@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH stable-28 1/3] NET: net_namespace, fix lock imbalance
Date: Wed, 28 Jan 2009 18:53:39 +0100
Message-Id: <1233165221-20106-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1233165221-20106-2-git-send-email-jslaby@suse.cz>
References: <1233165221-20106-1-git-send-email-jslaby@suse.cz>
 <1233165221-20106-2-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

register_pernet_gen_subsys omits mutex_unlock in one fail path.
Fix it.

Commit 357f5b0b91054ae23385ea4b0634bb8b43736e83.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/core/net_namespace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 1895a4c..0bc398c 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -342,8 +342,8 @@ again:
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


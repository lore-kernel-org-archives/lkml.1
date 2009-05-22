Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbZEVE4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbZEVE4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 00:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbZEVEze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:55:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:3469 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbZEVEzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:55:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GllOOhz08PhNXZcsKux0WThyrf9onxsby5O8voTh8UJmk1DUtgCDWad03f2g+Q4hz5
         q2U0h19a592PWxRI/9lMEAAMXxQXEnnZ3OXJQ8VcCNGJiufibR/QWC70gbLQhN5Uh/iV
         JkZRiNJBhKfF/C4GZlM27oC0sxW8Bhh+jr9Oo=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 03/38] ipcns 1/4: remove useless get/put while CLONE_NEWIPC
Date: Fri, 22 May 2009 08:54:57 +0400
Message-Id: <1242968132-1044-3-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_ipcs() doesn't actually copy anything. If new ipcns is created, it's
created from scratch, in this case get/put on old ipcns isn't needed.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 ipc/namespace.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/ipc/namespace.c b/ipc/namespace.c
index 4a5e752..a56fc59 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -50,15 +50,11 @@ struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
 {
 	struct ipc_namespace *new_ns;
 
-	BUG_ON(!ns);
-	get_ipc_ns(ns);
-
 	if (!(flags & CLONE_NEWIPC))
-		return ns;
+		return get_ipc_ns(ns);
 
 	new_ns = clone_ipc_ns(ns);
 
-	put_ipc_ns(ns);
 	return new_ns;
 }
 
-- 
1.5.6.5


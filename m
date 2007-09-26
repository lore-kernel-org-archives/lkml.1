Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbXIZNaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbXIZNaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbXIZNaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:30:07 -0400
Received: from sacred.ru ([62.205.161.221]:48499 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbXIZNaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:30:06 -0400
Message-ID: <46FA5D0F.2090604@openvz.org>
Date: Wed, 26 Sep 2007 17:22:23 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Serge Hallyn <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Use KMEM_CACHE macro to create the nsproxy cache
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 26 Sep 2007 17:24:45 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The blessed way for standard caches is to use it.
Besides, this may give this cache a better alignment.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index ee68964..31351cc 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -222,8 +222,7 @@ void exit_task_namespaces(struct task_st
 
 static int __init nsproxy_cache_init(void)
 {
-	nsproxy_cachep = kmem_cache_create("nsproxy", sizeof(struct nsproxy),
-					   0, SLAB_PANIC, NULL);
+	nsproxy_cachep = KMEM_CACHE(nsproxy, SLAB_PANIC);
 	return 0;
 }
 

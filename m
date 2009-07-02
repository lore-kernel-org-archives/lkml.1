Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbZGBFd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbZGBFd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbZGBFcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:32:07 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:58731 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbZGBFcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:32:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TdoXEwmegxwvQ1r52uQE5+nwEViPm7S6t1DYhbU45RkcmTF+TAvwu3aWbA5c8unGpV
         frccTazeWYWtUcZRcLzTrQABPXBl/7ZJeDo1wsR7W0h0OieiN2AZYKuOkSR5A7ySQ/hB
         oCwkkg9JD59LalCIdg47Oyg0mT1lhuQhv4fvA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: selinux@tycho.nsa.gov, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 6/8] SELinux netport.c non trivial fixes.
Date: Wed,  1 Jul 2009 22:32:45 -0700
Message-Id: <1246512767-2999-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1246512767-2999-1-git-send-email-justinmattock@gmail.com>
References: <1246512767-2999-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Fix some debug comments.
Fix some comments.
---
 security/selinux/netport.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/security/selinux/netport.c b/security/selinux/netport.c
index fe7fba6..61a88b3 100644
--- a/security/selinux/netport.c
+++ b/security/selinux/netport.c
@@ -56,11 +56,11 @@ struct sel_netport {
 	struct rcu_head rcu;
 };
 
-/* NOTE: we are using a combined hash table for both IPv4 and IPv6, the reason
+/* NOTE: We are using a combined hash table for both IPv4 and IPv6, the reason
  * for this is that I suspect most users will not make heavy use of both
  * address families at the same time so one table will usually end up wasted,
  * if this becomes a problem we can always add a hash table for each address
- * family later */
+ * family later. */
 
 static LIST_HEAD(sel_netport_list);
 static DEFINE_SPINLOCK(sel_netport_lock);
@@ -131,8 +131,8 @@ static void sel_netport_insert(struct sel_netport *port)
 {
 	unsigned int idx;
 
-	/* we need to impose a limit on the growth of the hash table so check
-	 * this bucket to make sure it is within the specified bounds */
+	/* We need to impose a limit on the growth of the hash table so check
+	 * this bucket to make sure it is within the specified bounds. */
 	idx = sel_netport_hashfn(port->psec.port);
 	list_add_rcu(&port->list, &sel_netport_hash[idx].list);
 	if (sel_netport_hash[idx].size == SEL_NETPORT_HASH_BKT_LIMIT) {
@@ -187,8 +187,8 @@ out:
 	spin_unlock_bh(&sel_netport_lock);
 	if (unlikely(ret)) {
 		printk(KERN_WARNING
-		       "SELinux: failure in sel_netport_sid_slow(),"
-		       " unable to determine network port label\n");
+		       "SELinux: Failure in sel_netport_sid_slow(),"
+		       " unable to determine network port label.\n");
 		kfree(new);
 	}
 	return ret;
-- 
1.6.3.2


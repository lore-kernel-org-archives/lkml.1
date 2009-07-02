Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbZGBFdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbZGBFdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbZGBFcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:32:04 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:54689 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbZGBFcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:32:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=e7eKHLaFBPXDlu67lkqk2Zm7dTTXHySQSAbqTGbhRFrhTMBT1z1detce48PBgzzbJl
         DDF9yAh5WrAobGYSK9zDF9IVvTl+2EMIcBn/QLWrPXjrL0j+8C2hcP3Hx9fO4+bdTdMk
         6aYaGjNWjSLNUEEg3lUkKm5XJkZLdZvO/WnLg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: selinux@tycho.nsa.gov, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 5/8] SELinux netnode.c non trivial fixes.
Date: Wed,  1 Jul 2009 22:32:44 -0700
Message-Id: <1246512767-2999-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1246512767-2999-1-git-send-email-justinmattock@gmail.com>
References: <1246512767-2999-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Fix some comments.
---
 security/selinux/netnode.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/security/selinux/netnode.c b/security/selinux/netnode.c
index 7100072..426c41d 100644
--- a/security/selinux/netnode.c
+++ b/security/selinux/netnode.c
@@ -57,11 +57,11 @@ struct sel_netnode {
 	struct rcu_head rcu;
 };
 
-/* NOTE: we are using a combined hash table for both IPv4 and IPv6, the reason
+/* NOTE: We are using a combined hash table for both IPv4 and IPv6, the reason
  * for this is that I suspect most users will not make heavy use of both
  * address families at the same time so one table will usually end up wasted,
  * if this becomes a problem we can always add a hash table for each address
- * family later */
+ * family later. */
 
 static LIST_HEAD(sel_netnode_list);
 static DEFINE_SPINLOCK(sel_netnode_lock);
@@ -94,8 +94,8 @@ static void sel_netnode_free(struct rcu_head *p)
  */
 static unsigned int sel_netnode_hashfn_ipv4(__be32 addr)
 {
-	/* at some point we should determine if the mismatch in byte order
-	 * affects the hash function dramatically */
+	/* At some point we should determine if the mismatch in byte order
+	 * affects the hash function dramatically. */
 	return (addr & (SEL_NETNODE_HASH_SIZE - 1));
 }
 
@@ -110,9 +110,9 @@ static unsigned int sel_netnode_hashfn_ipv4(__be32 addr)
  */
 static unsigned int sel_netnode_hashfn_ipv6(const struct in6_addr *addr)
 {
-	/* just hash the least significant 32 bits to keep things fast (they
+	/* Just hash the least significant 32 bits to keep things fast (they
 	 * are the most likely to be different anyway), we can revisit this
-	 * later if needed */
+	 * later if needed. */
 	return (addr->s6_addr32[3] & (SEL_NETNODE_HASH_SIZE - 1));
 }
 
@@ -184,8 +184,8 @@ static void sel_netnode_insert(struct sel_netnode *node)
 
 	INIT_RCU_HEAD(&node->rcu);
 
-	/* we need to impose a limit on the growth of the hash table so check
-	 * this bucket to make sure it is within the specified bounds */
+	/* We need to impose a limit on the growth of the hash table so check
+	 * this bucket to make sure it is within the specified bounds. */
 	list_add_rcu(&node->list, &sel_netnode_hash[idx].list);
 	if (sel_netnode_hash[idx].size == SEL_NETNODE_HASH_BKT_LIMIT) {
 		struct sel_netnode *tail;
@@ -252,8 +252,8 @@ out:
 	spin_unlock_bh(&sel_netnode_lock);
 	if (unlikely(ret)) {
 		printk(KERN_WARNING
-		       "SELinux: failure in sel_netnode_sid_slow(),"
-		       " unable to determine network node label\n");
+		       "SELinux: Failure in sel_netnode_sid_slow(),"
+		       " unable to determine network node label.\n");
 		kfree(new);
 	}
 	return ret;
-- 
1.6.3.2


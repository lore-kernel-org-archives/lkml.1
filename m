Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbYGSAB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbYGSAB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 20:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756912AbYGSABU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 20:01:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39894 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbYGSABU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 20:01:20 -0400
Date: Sat, 19 Jul 2008 01:01:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: [PATCH] fixup for vfs-next vs. net-next
Message-ID: <20080719000117.GS28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	VServer folks had played with sysctls again; needs to be covered
in sysctl fixes...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index b91a5de..2240a9e 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -44,13 +44,6 @@ static struct ctl_table_root net_sysctl_root = {
 	.lookup = net_ctl_header_lookup,
 };
 
-static LIST_HEAD(net_sysctl_ro_tables);
-static struct list_head *net_ctl_ro_header_lookup(struct ctl_table_root *root,
-		struct nsproxy *namespaces)
-{
-	return &net_sysctl_ro_tables;
-}
-
 static int net_ctl_ro_header_perms(struct ctl_table_root *root,
 		struct nsproxy *namespaces, struct ctl_table *table)
 {
@@ -61,7 +54,6 @@ static int net_ctl_ro_header_perms(struct ctl_table_root *root,
 }
 
 static struct ctl_table_root net_sysctl_ro_root = {
-	.lookup = net_ctl_ro_header_lookup,
 	.permissions = net_ctl_ro_header_perms,
 };
 
@@ -89,6 +81,7 @@ static __init int sysctl_init(void)
 	if (ret)
 		goto out;
 	register_sysctl_root(&net_sysctl_root);
+	setup_sysctl_set(&net_sysctl_ro_root.default_set, NULL, NULL);
 	register_sysctl_root(&net_sysctl_ro_root);
 out:
 	return ret;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbYEOAK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbYEOAK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 20:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbYEOAKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 20:10:16 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42009 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbYEOAKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 20:10:15 -0400
Date: Wed, 14 May 2008 17:10:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: dwmw2@infradead.org, akpm@linux-foundation.org, hch@infradead.org
Subject: [PATCH] list_for_each_rcu must die: audit
Message-ID: <20080515001012.GA20811@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080424012150.GA15350@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424012150.GA15350@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All uses of list_for_each_rcu() can be profitably replaced by the
easier-to-use list_for_each_entry_rcu().  This patch makes this change
for the Audit system, in preparation for removing the list_for_each_rcu()
API entirely.  This time with well-formed SOB.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 audit_tree.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -urpNa -X dontdiff linux-2.6.25/kernel/audit_tree.c linux-2.6.25-lfer-audit/kernel/audit_tree.c
--- linux-2.6.25/kernel/audit_tree.c	2008-04-16 19:49:44.000000000 -0700
+++ linux-2.6.25-lfer-audit/kernel/audit_tree.c	2008-04-23 18:09:16.000000000 -0700
@@ -172,10 +172,9 @@ static void insert_hash(struct audit_chu
 struct audit_chunk *audit_tree_lookup(const struct inode *inode)
 {
 	struct list_head *list = chunk_hash(inode);
-	struct list_head *pos;
+	struct audit_chunk *p;
 
-	list_for_each_rcu(pos, list) {
-		struct audit_chunk *p = container_of(pos, struct audit_chunk, hash);
+	list_for_each_entry_rcu(p, list, hash) {
 		if (p->watch.inode == inode) {
 			get_inotify_watch(&p->watch);
 			return p;

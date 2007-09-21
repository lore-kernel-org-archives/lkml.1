Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbXIUJjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbXIUJjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 05:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbXIUJjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 05:39:06 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:26639 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbXIUJjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 05:39:04 -0400
Date: Fri, 21 Sep 2007 13:38:08 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH 1/1] user.c: deinline
Message-ID: <20070921093808.GA6812@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Save some space because uid_hash_find() has 3 callsites.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 kernel/user.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/kernel/user.c
+++ b/kernel/user.c
@@ -55,17 +55,17 @@ struct user_struct root_user = {
 /*
  * These routines must be called with the uidhash spinlock held!
  */
-static inline void uid_hash_insert(struct user_struct *up, struct hlist_head *hashent)
+static void uid_hash_insert(struct user_struct *up, struct hlist_head *hashent)
 {
 	hlist_add_head(&up->uidhash_node, hashent);
 }
 
-static inline void uid_hash_remove(struct user_struct *up)
+static void uid_hash_remove(struct user_struct *up)
 {
 	hlist_del_init(&up->uidhash_node);
 }
 
-static inline struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
+static struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
 {
 	struct user_struct *user;
 	struct hlist_node *h;


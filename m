Return-Path: <linux-kernel-owner+w=401wt.eu-S1762794AbXGVSvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762794AbXGVSvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 14:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759401AbXGVSu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 14:50:57 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:35554
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757922AbXGVSu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 14:50:56 -0400
Date: Sun, 22 Jul 2007 20:52:47 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 3/5] kernel/user.c: Use list_for_each_entry instead of list_for_each
Message-ID: <20070722185247.GI27415@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070722184202.GF27415@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070722184202.GF27415@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/user.c: Convert list_for_each to list_for_each_entry in
uid_hash_find()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/kernel/user.c b/kernel/user.c
index 4869563..d0363d1 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -68,13 +68,9 @@ static inline void uid_hash_remove(struct user_struct *up)
 
 static inline struct user_struct *uid_hash_find(uid_t uid, struct list_head *hashent)
 {
-	struct list_head *up;
-
-	list_for_each(up, hashent) {
-		struct user_struct *user;
-
-		user = list_entry(up, struct user_struct, uidhash_list);
+	struct user_struct *user;
 
+	list_for_each_entry(user, hashent, uidhash_list) {
 		if(user->uid == uid) {
 			atomic_inc(&user->__count);
 			return user;

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona


   Usually when people are sad, they don't do anything. They just cry over
     their condition. But when they get angry, they bring about a change
                              (Malcolm X)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757657AbXE0QlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbXE0QlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 12:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbXE0QlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 12:41:07 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:35331
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755396AbXE0QlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 12:41:06 -0400
Date: Sun, 27 May 2007 18:43:02 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] Block device elevator: use list_for_each_entry() instead of list_for_each()
Message-ID: <20070527164302.GL31790@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	axboe@kernel.dk, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_for_each_entry() instead of list_for_each() in the block
device elevator

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/block/elevator.c b/block/elevator.c
index ce866eb..4769a25 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -112,12 +112,8 @@ static inline int elv_try_merge(struct request *__rq, struct bio *bio)
 static struct elevator_type *elevator_find(const char *name)
 {
 	struct elevator_type *e;
-	struct list_head *entry;
-
-	list_for_each(entry, &elv_list) {
-
-		e = list_entry(entry, struct elevator_type, list);
 
+	list_for_each_entry(e, &elv_list, list) {
 		if (!strcmp(e->elevator_name, name))
 			return e;
 	}
@@ -1116,14 +1112,11 @@ ssize_t elv_iosched_show(request_queue_t *q, char *name)
 {
 	elevator_t *e = q->elevator;
 	struct elevator_type *elv = e->elevator_type;
-	struct list_head *entry;
+	struct elevator_type *__e;
 	int len = 0;
 
 	spin_lock(&elv_list_lock);
-	list_for_each(entry, &elv_list) {
-		struct elevator_type *__e;
-
-		__e = list_entry(entry, struct elevator_type, list);
+	list_for_each_entry(__e, &elv_list, list) {
 		if (!strcmp(elv->elevator_name, __e->elevator_name))
 			len += sprintf(name+len, "[%s] ", elv->elevator_name);
 		else
 
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

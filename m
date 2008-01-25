Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbYAYIiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbYAYIiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763943AbYAYIBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:47 -0500
Received: from mail.suse.de ([195.135.220.2]:59445 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760771AbYAYH7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:50 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jens Axboe <axboe@kernel.dk>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 159/196] Kobject: convert block/elevator.c to use kobject_init/add_ng()
Date: Thu, 24 Jan 2008 23:33:08 -0800
Message-Id: <1201246425-5058-80-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the code to use the new kobject functions, cleaning up the
logic in doing so.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/elevator.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index e452deb..5445c3c 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -185,9 +185,7 @@ static elevator_t *elevator_alloc(struct request_queue *q,
 
 	eq->ops = &e->ops;
 	eq->elevator_type = e;
-	kobject_init(&eq->kobj);
-	kobject_set_name(&eq->kobj, "%s", "iosched");
-	eq->kobj.ktype = &elv_ktype;
+	kobject_init_ng(&eq->kobj, &elv_ktype);
 	mutex_init(&eq->sysfs_lock);
 
 	eq->hash = kmalloc_node(sizeof(struct hlist_head) * ELV_HASH_ENTRIES,
@@ -931,9 +929,7 @@ int elv_register_queue(struct request_queue *q)
 	elevator_t *e = q->elevator;
 	int error;
 
-	e->kobj.parent = &q->kobj;
-
-	error = kobject_add(&e->kobj);
+	error = kobject_add_ng(&e->kobj, &q->kobj, "%s", "iosched");
 	if (!error) {
 		struct elv_fs_entry *attr = e->elevator_type->elevator_attrs;
 		if (attr) {
-- 
1.5.3.8


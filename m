Return-Path: <linux-kernel-owner+w=401wt.eu-S932301AbYAYI0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbYAYI0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762390AbYAYIBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:53705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763708AbYAYH75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:57 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 132/196] Kobject: convert fs/char_dev.c to use kobject_init/add_ng()
Date: Thu, 24 Jan 2008 23:32:41 -0800
Message-Id: <1201246425-5058-53-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the code to use the new kobject functions, cleaning up the
logic in doing so.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/char_dev.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index c3bfa76..b2dd5a0 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -510,9 +510,8 @@ struct cdev *cdev_alloc(void)
 {
 	struct cdev *p = kzalloc(sizeof(struct cdev), GFP_KERNEL);
 	if (p) {
-		p->kobj.ktype = &ktype_cdev_dynamic;
 		INIT_LIST_HEAD(&p->list);
-		kobject_init(&p->kobj);
+		kobject_init_ng(&p->kobj, &ktype_cdev_dynamic);
 	}
 	return p;
 }
@@ -529,8 +528,7 @@ void cdev_init(struct cdev *cdev, const struct file_operations *fops)
 {
 	memset(cdev, 0, sizeof *cdev);
 	INIT_LIST_HEAD(&cdev->list);
-	cdev->kobj.ktype = &ktype_cdev_default;
-	kobject_init(&cdev->kobj);
+	kobject_init_ng(&cdev->kobj, &ktype_cdev_default);
 	cdev->ops = fops;
 }
 
-- 
1.5.3.8


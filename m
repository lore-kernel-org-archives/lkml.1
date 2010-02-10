Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab0BJLfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 06:35:47 -0500
Received: from perceval.irobotique.be ([92.243.18.41]:34344 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab0BJLfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 06:35:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: gregkh@suse.de
Cc: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       artem.bityutskiy@nokia.com
Subject: [PATCH] class: Free the class private data in class_unregister
Date: Wed, 10 Feb 2010 12:35:43 +0100
Message-Id: <1265801743-26079-1-git-send-email-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a memory leak by freeing the memory allocated in __class_register
for the class private data.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/base/class.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 161746d..a9449b3 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -200,6 +200,7 @@ void class_unregister(struct class *cls)
 	pr_debug("device class '%s': unregistering\n", cls->name);
 	remove_class_attrs(cls);
 	kset_unregister(&cls->p->class_subsys);
+	kfree(cls->p);
 }
 
 static void class_create_release(struct class *cls)
-- 
1.6.4.4


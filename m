Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab0BJMc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 07:32:57 -0500
Received: from perceval.irobotique.be ([92.243.18.41]:56887 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab0BJMc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 07:32:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: gregkh@suse.de
Cc: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       artem.bityutskiy@nokia.com
Subject: [PATCH v2] class: Free the class private data in class_release
Date: Wed, 10 Feb 2010 13:32:49 +0100
Message-Id: <1265805169-31315-1-git-send-email-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1265801743-26079-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1265801743-26079-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a memory leak by freeing the memory allocated in __class_register
for the class private data.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/base/class.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 161746d..6e2c3b0 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -59,6 +59,8 @@ static void class_release(struct kobject *kobj)
 	else
 		pr_debug("class '%s' does not have a release() function, "
 			 "be careful\n", class->name);
+
+	kfree(cp);
 }
 
 static struct sysfs_ops class_sysfs_ops = {
-- 
1.6.4.4


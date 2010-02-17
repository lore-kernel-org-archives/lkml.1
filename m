Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776Ab0BQALi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 19:11:38 -0500
Received: from kroah.org ([198.145.64.141]:41526 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933756Ab0BQALc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 19:11:32 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       stable <stable@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/2] class: Free the class private data in class_release
Date: Tue, 16 Feb 2010 16:11:29 -0800
Message-Id: <1266365489-32082-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20100217000206.GB31137@kroah.com>
References: <20100217000206.GB31137@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Fix a memory leak by freeing the memory allocated in __class_register
for the class private data.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.0


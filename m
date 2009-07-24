Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbZGXJbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbZGXJbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 05:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbZGXJbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 05:31:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45533 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbZGXJbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 05:31:47 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] drivers/base: do not send KOBJ_ADD uevent if kobject_init_and_add fails
Date: Fri, 24 Jul 2009 17:31:41 +0800
Message-Id: <1248427901-30992-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kobject_init_and_add fails, sysdev_register should not send KOBJ_ADD
uevent to userspace.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 drivers/base/sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 79a9ae5..0d90390 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -275,9 +275,9 @@ int sysdev_register(struct sys_device *sysdev)
 				drv->add(sysdev);
 		}
 		mutex_unlock(&sysdev_drivers_lock);
+		kobject_uevent(&sysdev->kobj, KOBJ_ADD);
 	}
 
-	kobject_uevent(&sysdev->kobj, KOBJ_ADD);
 	return error;
 }
 
-- 
1.6.2.5


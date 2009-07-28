Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbZG1Vpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbZG1Vpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbZG1Vpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:45:33 -0400
Received: from kroah.org ([198.145.64.141]:55427 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623AbZG1Vpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:45:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <dfeng@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/5] driver core: sysdev: do not send KOBJ_ADD uevent if kobject_init_and_add fails
Date: Tue, 28 Jul 2009 14:44:40 -0700
Message-Id: <1248817481-13372-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090728213826.GC13090@kroah.com>
References: <20090728213826.GC13090@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaotian Feng <dfeng@redhat.com>

If kobject_init_and_add fails, sysdev_register should not send KOBJ_ADD
uevent to userspace.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.3.2


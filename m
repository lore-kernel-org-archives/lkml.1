Return-Path: <linux-kernel-owner+w=401wt.eu-S934097AbZLKWbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934097AbZLKWbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762774AbZLKWZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:25:20 -0500
Received: from kroah.org ([198.145.64.141]:32788 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762712AbZLKWZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:25:00 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/27] Driver core: Don't remove kobjects in device_shutdown.
Date: Fri, 11 Dec 2009 14:24:32 -0800
Message-Id: <1260570289-6997-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

device_shutdown is defined to just shutdown the hardware and to not
clean up any kernel data structures.  Therefore don't put the kobjects
for /sys/dev and /sys/dev/block and /sys/dev/char.

This ensures we don't remove /sys/dev/block and /sys/dev/char while
we still have symlinks from there to the actual devices.

Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 0d3c29d..353b137 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1730,8 +1730,5 @@ void device_shutdown(void)
 			dev->driver->shutdown(dev);
 		}
 	}
-	kobject_put(sysfs_dev_char_kobj);
-	kobject_put(sysfs_dev_block_kobj);
-	kobject_put(dev_kobj);
 	async_synchronize_full();
 }
-- 
1.6.5.5


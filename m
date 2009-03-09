Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZCIWsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZCIWsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 18:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbZCIWqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 18:46:05 -0400
Received: from cmpxchg.org ([85.214.51.133]:60373 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552AbZCIWqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 18:46:04 -0400
Message-Id: <20090309224228.507356326@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Mon, 09 Mar 2009 23:37:27 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Oliver Neukum <oneukum@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Oliver Neukum <oliver@neukum.name>
Subject: [patch 1/2] hiddev: fix incorrect free
References: <20090309223726.565021009@cmpxchg.org>
Content-Disposition: inline; filename=hiddev-fix-incorrect-free.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If hiddev_open() fails, it wrongly frees the shared hiddev structure
kept in hiddev_table instead of the hiddev_list structure allocated
for the opened file descriptor.  Existing references to this structure
will then accessed free memory.

This was introduced by 079034073 "HID: hiddev cleanup -- handle all
error conditions properly".

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oliver Neukum <oliver@neukum.name>
---
 drivers/hid/usbhid/hiddev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -306,7 +306,7 @@ static int hiddev_open(struct inode *ino
 	return 0;
 bail:
 	file->private_data = NULL;
-	kfree(list->hiddev);
+	kfree(list);
 	return res;
 }
 



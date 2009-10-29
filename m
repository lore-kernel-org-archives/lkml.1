Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbZJ2T3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbZJ2T3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZJ2T3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:29:08 -0400
Received: from kroah.org ([198.145.64.141]:34065 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756613AbZJ2T3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:29:06 -0400
Subject: patch driver-core-devtmpfs-cleanup-node-on-device-creation-error.patch added to gregkh-2.6 tree
To: kay.sievers@vrfy.org, gregkh@suse.de, greg@kroah.com,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 29 Oct 2009 12:29:05 -0700
In-Reply-To: <1256755897.2618.324.camel@yio.site>
Message-ID: <12568445451759@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Driver Core: devtmpfs: cleanup node on device creation error

to my gregkh-2.6 tree.  Its filename is

    driver-core-devtmpfs-cleanup-node-on-device-creation-error.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From kay.sievers@vrfy.org  Thu Oct 29 12:01:25 2009
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 28 Oct 2009 19:51:37 +0100
Subject: Driver Core: devtmpfs: cleanup node on device creation error
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1256755897.2618.324.camel@yio.site>


From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -987,6 +987,8 @@ done:
 	device_remove_class_symlinks(dev);
  SymlinkError:
 	if (MAJOR(dev->devt))
+		devtmpfs_delete_node(dev);
+	if (MAJOR(dev->devt))
 		device_remove_sys_dev_entry(dev);
  devtattrError:
 	if (MAJOR(dev->devt))


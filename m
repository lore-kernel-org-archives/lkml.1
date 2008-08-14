Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYHNCcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYHNCcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 22:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYHNCcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 22:32:47 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:44259 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYHNCcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 22:32:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=MdHkcFdriMm8X2xm0NZBuv08WXXZNzGuGxgtmIrsBuiU+sIjS5OOHzyoONgYIzOZE3
         qnz4jCuABXYiRAyBx3c8Un2PgtFAEdOQoWeqiiADHkrAsPdWioWHAQkaxXjLT7p9Pyhq
         wBpX9K6rHHGL2B8CeSU9L/1S+CibaI4XlqQAw=
Date: Thu, 14 Aug 2008 11:32:34 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Subject: [PATCH] brd: fix name argument of unregister_blkdev()
Message-ID: <20080814023233.GA20728@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name of brd block device is "ramdisk", it's not "brd".
(The block device is registered by register_blkdev(RAMDISK_MAJOR, "ramdisk")
So it should be unregistered by unregister_blkdev(RAMDISK_MAJOR, "ramdisk")

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc:  Nick Piggin <npiggin@suse.de>
---
 drivers/block/brd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6-git/drivers/block/brd.c
===================================================================
--- 2.6-git.orig/drivers/block/brd.c
+++ 2.6-git/drivers/block/brd.c
@@ -571,8 +571,8 @@ out_free:
 		list_del(&brd->brd_list);
 		brd_free(brd);
 	}
+	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
 
-	unregister_blkdev(RAMDISK_MAJOR, "brd");
 	return -ENOMEM;
 }
 

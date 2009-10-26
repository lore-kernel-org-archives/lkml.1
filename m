Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbZJ0AAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbZJ0AAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136AbZJ0AAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:00:07 -0400
Received: from kroah.org ([198.145.64.141]:48101 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039AbZJ0AAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:00:02 -0400
Subject: patch driver-core-fix-driver_register-return-value.patch added to gregkh-2.6 tree
To: stsp@aknet.ru, gregkh@suse.de, linux-kernel@vger.kernel.org,
       stable@kernel.org
From: <gregkh@suse.de>
Date: Mon, 26 Oct 2009 16:56:58 -0700
In-Reply-To: <4ADA29AA.9070907@aknet.ru>
Message-ID: <12566014181853@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Driver core: fix driver_register() return value

to my gregkh-2.6 tree.  Its filename is

    driver-core-fix-driver_register-return-value.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From stsp@aknet.ru  Mon Oct 26 16:00:03 2009
From: Stas Sergeev <stsp@aknet.ru>
Date: Sun, 18 Oct 2009 00:31:38 +0400
Subject: Driver core: fix driver_register() return value
To: Greg KH <gregkh@suse.de>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Message-ID: <4ADA29AA.9070907@aknet.ru>

In this patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=16dc42e018c2868211b4928f20a957c0c216126c
the check was added for another driver to already claim the same device
on the same bus. But the returned error code was wrong: to modprobe, the
-EEXIST means that _this_ driver is already installed. It therefore
doesn't produce the needed error message when _another_ driver is trying
to register for the same device.  Returning -EBUSY fixes the problem.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -236,7 +236,7 @@ int driver_register(struct device_driver
 		put_driver(other);
 		printk(KERN_ERR "Error: Driver '%s' is already registered, "
 			"aborting...\n", drv->name);
-		return -EEXIST;
+		return -EBUSY;
 	}
 
 	ret = bus_add_driver(drv);


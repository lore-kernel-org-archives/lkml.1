Return-Path: <linux-kernel-owner+w=401wt.eu-S1764867AbXHYEph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764867AbXHYEph (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 00:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbXHYEpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 00:45:30 -0400
Received: from ns2.suse.de ([195.135.220.15]:37935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbXHYEp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 00:45:29 -0400
Subject: patch usb-avoid-redundant-cast-of-kmalloc-return-value-in-oti-6858-driver.patch added to gregkh-2.6 tree
To: jesper.juhl@gmail.com, greg@kroah.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Fri, 24 Aug 2007 21:43:58 -0700
In-Reply-To: <e71841eb1d00e260fea44d94a4c8a0f950debcfd.1187912217.git.jesper.juhl@gmail.com>
Message-Id: <20070825044527.36A7114540D0@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: usb: avoid redundant cast of kmalloc() return value in OTi-6858 driver

to my gregkh-2.6 tree.  Its filename is

     usb-avoid-redundant-cast-of-kmalloc-return-value-in-oti-6858-driver.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From jesper.juhl@gmail.com Thu Aug 23 17:38:13 2007
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 02:35:14 +0200
Subject: usb: avoid redundant cast of kmalloc() return value in OTi-6858 driver
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Jesper Juhl <jesper.juhl@gmail.com>
Message-ID: <e71841eb1d00e260fea44d94a4c8a0f950debcfd.1187912217.git.jesper.juhl@gmail.com>
Content-Disposition: inline


In drivers/usb/serial/oti6858.c::pl2303_buf_alloc() the return value
of kmalloc() is being cast to "struct pl2303_buf *", but that need
not be done here since kmalloc() returns "void *".

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/oti6858.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -1144,7 +1144,7 @@ static struct pl2303_buf *pl2303_buf_all
 	if (size == 0)
 		return NULL;
 
-	pb = (struct pl2303_buf *)kmalloc(sizeof(struct pl2303_buf), GFP_KERNEL);
+	pb = kmalloc(sizeof(struct pl2303_buf), GFP_KERNEL);
 	if (pb == NULL)
 		return NULL;
 


Patches currently in gregkh-2.6 which might be from jesper.juhl@gmail.com are

bad/speakup-kconfig-fix.patch
usb/usb-clean-up-duplicate-includes-in-drivers-usb.patch
usb/usb-avoid-redundant-cast-of-kmalloc-return-value-in-oti-6858-driver.patch

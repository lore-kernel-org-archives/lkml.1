Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbXJaDwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbXJaDwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 23:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbXJaDvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 23:51:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37665 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbXJaDvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 23:51:54 -0400
Date: Wed, 31 Oct 2007 14:51:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] hiddev: compat_ptr() returns a void *
Message-Id: <20071031145153.30f9d3dd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

so cast it to unsigned long before passing it to hiddev_ioctl.

This gets rid of:

drivers/hid/usbhid/hiddev.c: In function 'hiddev_compat_ioctl':
drivers/hid/usbhid/hiddev.c:746: warning: passing argument 4 of 'hiddev_ioctl' makes integer from pointer without a cast

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/hid/usbhid/hiddev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 9837adc..5fc4019 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -743,7 +743,7 @@ inval:
 static long hiddev_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
-	return hiddev_ioctl(inode, file, cmd, compat_ptr(arg));
+	return hiddev_ioctl(inode, file, cmd, (unsigned long)compat_ptr(arg));
 }
 #endif
 
-- 
1.5.3.4


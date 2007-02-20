Return-Path: <linux-kernel-owner+w=401wt.eu-S965347AbXBTQPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965347AbXBTQPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965356AbXBTQPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:15:55 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2447 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965347AbXBTQPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:15:53 -0500
Date: Tue, 20 Feb 2007 16:15:41 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Pete Zaitcev <zaitcev@redhat.com>
Subject: [PATCH] Fix USB Mon breakage
Message-ID: <20070220161541.GA20977@flint.arm.linux.org.uk>
Mail-Followup-To: Linux Kernel List <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>, Pete Zaitcev <zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Never call __exit code from __init code - it causes errors such as:

arm-linux-ld: `mon_bin_exit' referenced in section `.init.text' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
arm-linux-ld: `mon_text_exit' referenced in section `.init.text' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/usb/mon/mon_bin.c  |    2 +-
 drivers/usb/mon/mon_text.c |    2 +-
 drivers/usb/mon/usb_mon.h  |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index c01dfe6..b2bedd9 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1165,7 +1165,7 @@ err_dev:
 	return rc;
 }
 
-void __exit mon_bin_exit(void)
+void mon_bin_exit(void)
 {
 	cdev_del(&mon_bin_cdev);
 	unregister_chrdev_region(mon_bin_dev0, MON_BIN_MAX_MINOR);
diff --git a/drivers/usb/mon/mon_text.c b/drivers/usb/mon/mon_text.c
index d38a127..494ee3b 100644
--- a/drivers/usb/mon/mon_text.c
+++ b/drivers/usb/mon/mon_text.c
@@ -520,7 +520,7 @@ int __init mon_text_init(void)
 	return 0;
 }
 
-void __exit mon_text_exit(void)
+void mon_text_exit(void)
 {
 	debugfs_remove(mon_dir);
 }
diff --git a/drivers/usb/mon/usb_mon.h b/drivers/usb/mon/usb_mon.h
index 4f949ce..efdfd89 100644
--- a/drivers/usb/mon/usb_mon.h
+++ b/drivers/usb/mon/usb_mon.h
@@ -57,9 +57,9 @@ void mon_text_del(struct mon_bus *mbus);
 // void mon_bin_add(struct mon_bus *);
 
 int __init mon_text_init(void);
-void __exit mon_text_exit(void);
+void mon_text_exit(void);
 int __init mon_bin_init(void);
-void __exit mon_bin_exit(void);
+void mon_bin_exit(void);
 
 /*
  * DMA interface.


-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

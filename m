Return-Path: <linux-kernel-owner+w=401wt.eu-S1030353AbXBUO0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030353AbXBUO0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 09:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030573AbXBUO0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 09:26:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030353AbXBUO0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 09:26:24 -0500
Date: Wed, 21 Feb 2007 09:26:17 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       zaitcev@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070221142617.28095.82350.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: Remove __exit from mon_bin_exit & mon_text_exit.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove __exit from mon_bin_exit & mon_text_exit.  Both functions are used
in error code paths in __init functions.

Resolves MODPOST warnings similar to:

`mon_bin_exit' referenced in section `.init.text' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`mon_text_exit' referenced in section `.init.text' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

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

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbXIIVbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbXIIVbw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 17:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbXIIVbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 17:31:45 -0400
Received: from ns2.suse.de ([195.135.220.15]:48962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbXIIVbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 17:31:44 -0400
Subject: patch usb-sisusbvga-fix-bug-and-build-warnings.patch added to gregkh-2.6 tree
To: satyam@infradead.org, greg@kroah.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org, thomas@winischhofer.net
From: <gregkh@suse.de>
Date: Sun, 09 Sep 2007 14:32:38 -0700
In-Reply-To: <alpine.LFD.0.999.0709030136140.29617@enigma.security.iitk.ac.in>
Message-ID: <1189373558@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: USB: sisusbvga: Fix bug and build warnings

to my gregkh-2.6 tree.  Its filename is

     usb-sisusbvga-fix-bug-and-build-warnings.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From satyam@infradead.org Sun Sep  2 12:54:28 2007
From: Satyam Sharma <satyam@infradead.org>
Date: Mon, 3 Sep 2007 01:37:31 +0530 (IST)
Subject: USB: sisusbvga: Fix bug and build warnings
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Thomas Winischhofer <thomas@winischhofer.net>,  Greg Kroah-Hartman <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net
Message-ID: <alpine.LFD.0.999.0709030136140.29617@enigma.security.iitk.ac.in>


drivers/usb/misc/sisusbvga/sisusb.c: In function usb_sisusb_init:
drivers/usb/misc/sisusbvga/sisusb.c:3321: warning: unused variable sisusb
drivers/usb/misc/sisusbvga/sisusb.c:3320: warning: unused variable retval

are trivially solved by getting rid of the unused variables.

drivers/usb/misc/sisusbvga/sisusb.c: In function sisusb_open
drivers/usb/misc/sisusbvga/sisusb.c:2444: warning: sisusb is used uninitialized in this function

is a genuine bug (which will cause oops). We cannot use "sisusb" in
error path for (!interface), because sisusb will itself be derived
from "interface" later.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/usb/misc/sisusbvga/sisusb.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -2440,10 +2440,8 @@ sisusb_open(struct inode *inode, struct 
 	struct usb_interface *interface;
 	int subminor = iminor(inode);
 
-	if (!(interface = usb_find_interface(&sisusb_driver, subminor))) {
-		dev_err(&sisusb->sisusb_dev->dev, "Failed to find interface\n");
+	if (!(interface = usb_find_interface(&sisusb_driver, subminor)))
 		return -ENODEV;
-	}
 
 	if (!(sisusb = usb_get_intfdata(interface)))
 		return -ENODEV;


Patches currently in gregkh-2.6 which might be from satyam@infradead.org are

driver/sysfs-remove-first-pass-at-shadow-directory-support.patch
driver/sysfs-introduce-sysfs_rename_mutex.patch
driver/sysfs-cosmetic-changes-in-sysfs_lookup.patch
driver/sysfs-make-sysfs_add-remove_one-call-link-unlink_sibling-implictly.patch
driver/sysfs-make-sysfs_add_one-automatically-check-for-duplicate-entry.patch
driver/sysfs-make-sysfs_addrm_finish-return-void.patch
driver/sysfs-simplify-sysfs_rename_dir.patch
driver/sysfs-kill-sysfs_flag_removed.patch
driver/sysfs-remove-s_dentry.patch
driver/sysfs-fix-i_mutex-locking-in-sysfs_get_dentry.patch
driver/sysfs-in-sysfs_lookup-don-t-open-code-sysfs_find_dirent.patch
driver/sysfs-make-sysfs_mount-static.patch
driver/sysfs-move-all-of-inode-initialization-into-sysfs_init_inode.patch
driver/sysfs-remove-sysfs_instantiate.patch
driver/sysfs-rewrite-rename-in-terms-of-sysfs-dirents.patch
driver/sysfs-rewrite-sysfs_drop_dentry.patch
driver/sysfs-rewrite-sysfs_move_dir-in-terms-of-sysfs-dirents.patch
driver/sysfs-simplify-readdir.patch
driver/sysfs-simply-sysfs_get_dentry.patch
driver/sysfs-use-kill_anon_super.patch
usb/usb-drivers-usb-serial-bus.c-fix-incompatible-pointer-type-warning.patch
usb/usb-sisusbvga-fix-bug-and-build-warnings.patch

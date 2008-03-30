Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbYC3Owu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbYC3Owu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 10:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYC3Owk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 10:52:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:14585 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYC3Owj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 10:52:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=oIDvAIpyt07eeKgvuIf7WvTQpj+47GP8vGdDyhwQs154TVXq+7cgDvGtbEIglJMMJQZLf8fDaYCtkV967Jj2C4AEEaVht2wnfWMj1FLEgHemfZcWsVHUqoq3NoEsCuJDsnrol1IVBnHRB7D/6VGc3bZrlwaprxzBCsMQ0pCGX80=
Date: Sun, 30 Mar 2008 18:49:04 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mm 4/3] proc: remove proc_bus
Message-ID: <20080330144904.GA4317@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove proc_bus export and variable itself. Using pathnames works fine
and is slightly more understandable and greppable.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/arm/kernel/ecard.c    |    2 +-
 drivers/input/input.c      |    6 +++---
 drivers/nubus/proc.c       |    2 +-
 drivers/pci/proc.c         |    2 +-
 drivers/pnp/isapnp/proc.c  |    2 +-
 drivers/pnp/pnpbios/proc.c |    4 ++--
 drivers/usb/core/inode.c   |    4 ++--
 drivers/zorro/proc.c       |    2 +-
 fs/proc/root.c             |    5 ++---
 include/linux/proc_fs.h    |    2 --
 10 files changed, 14 insertions(+), 17 deletions(-)

--- a/arch/arm/kernel/ecard.c
+++ b/arch/arm/kernel/ecard.c
@@ -778,7 +778,7 @@ static struct proc_dir_entry *proc_bus_ecard_dir = NULL;
 
 static void ecard_proc_init(void)
 {
-	proc_bus_ecard_dir = proc_mkdir("ecard", proc_bus);
+	proc_bus_ecard_dir = proc_mkdir("bus/ecard", NULL);
 	create_proc_info_entry("devices", 0, proc_bus_ecard_dir,
 		get_ecard_dev_info);
 }
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -898,7 +898,7 @@ static int __init input_proc_init(void)
 {
 	struct proc_dir_entry *entry;
 
-	proc_bus_input_dir = proc_mkdir("input", proc_bus);
+	proc_bus_input_dir = proc_mkdir("bus/input", NULL);
 	if (!proc_bus_input_dir)
 		return -ENOMEM;
 
@@ -921,7 +921,7 @@ static int __init input_proc_init(void)
 	return 0;
 
  fail2:	remove_proc_entry("devices", proc_bus_input_dir);
- fail1: remove_proc_entry("input", proc_bus);
+ fail1: remove_proc_entry("bus/input", NULL);
 	return -ENOMEM;
 }
 
@@ -929,7 +929,7 @@ static void input_proc_exit(void)
 {
 	remove_proc_entry("devices", proc_bus_input_dir);
 	remove_proc_entry("handlers", proc_bus_input_dir);
-	remove_proc_entry("input", proc_bus);
+	remove_proc_entry("bus/input", NULL);
 }
 
 #else /* !CONFIG_PROC_FS */
--- a/drivers/nubus/proc.c
+++ b/drivers/nubus/proc.c
@@ -171,7 +171,7 @@ void __init nubus_proc_init(void)
 {
 	if (!MACH_IS_MAC)
 		return;
-	proc_bus_nubus_dir = proc_mkdir("nubus", proc_bus);
+	proc_bus_nubus_dir = proc_mkdir("bus/nubus", NULL);
 	create_proc_info_entry("devices", 0, proc_bus_nubus_dir,
 				get_nubus_dev_info);
 	proc_bus_nubus_add_devices();
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -472,7 +472,7 @@ static int __init pci_proc_init(void)
 {
 	struct proc_dir_entry *entry;
 	struct pci_dev *dev = NULL;
-	proc_bus_pci_dir = proc_mkdir("pci", proc_bus);
+	proc_bus_pci_dir = proc_mkdir("bus/pci", NULL);
 	entry = create_proc_entry("devices", 0, proc_bus_pci_dir);
 	if (entry)
 		entry->proc_fops = &proc_bus_pci_dev_operations;
--- a/drivers/pnp/isapnp/proc.c
+++ b/drivers/pnp/isapnp/proc.c
@@ -116,7 +116,7 @@ int __init isapnp_proc_init(void)
 {
 	struct pnp_dev *dev;
 
-	isapnp_proc_bus_dir = proc_mkdir("isapnp", proc_bus);
+	isapnp_proc_bus_dir = proc_mkdir("bus/isapnp", NULL);
 	protocol_for_each_dev(&isapnp_protocol, dev) {
 		isapnp_proc_attach_device(dev);
 	}
--- a/drivers/pnp/pnpbios/proc.c
+++ b/drivers/pnp/pnpbios/proc.c
@@ -256,7 +256,7 @@ int pnpbios_interface_attach_device(struct pnp_bios_node *node)
  */
 int __init pnpbios_proc_init(void)
 {
-	proc_pnp = proc_mkdir("pnp", proc_bus);
+	proc_pnp = proc_mkdir("bus/pnp", NULL);
 	if (!proc_pnp)
 		return -EIO;
 	proc_pnp_boot = proc_mkdir("boot", proc_pnp);
@@ -294,5 +294,5 @@ void __exit pnpbios_proc_exit(void)
 	remove_proc_entry("configuration_info", proc_pnp);
 	remove_proc_entry("devices", proc_pnp);
 	remove_proc_entry("boot", proc_pnp);
-	remove_proc_entry("pnp", proc_bus);
+	remove_proc_entry("bus/pnp", NULL);
 }
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -773,7 +773,7 @@ int __init usbfs_init(void)
 	usb_register_notify(&usbfs_nb);
 
 	/* create mount point for usbfs */
-	usbdir = proc_mkdir("usb", proc_bus);
+	usbdir = proc_mkdir("bus/usb", NULL);
 
 	return 0;
 }
@@ -783,6 +783,6 @@ void usbfs_cleanup(void)
 	usb_unregister_notify(&usbfs_nb);
 	unregister_filesystem(&usb_fs_type);
 	if (usbdir)
-		remove_proc_entry("usb", proc_bus);
+		remove_proc_entry("bus/usb", NULL);
 }
 
--- a/drivers/zorro/proc.c
+++ b/drivers/zorro/proc.c
@@ -128,7 +128,7 @@ static int __init zorro_proc_init(void)
 	u_int slot;
 
 	if (MACH_IS_AMIGA && AMIGAHW_PRESENT(ZORRO)) {
-		proc_bus_zorro_dir = proc_mkdir("zorro", proc_bus);
+		proc_bus_zorro_dir = proc_mkdir("bus/zorro", NULL);
 		create_proc_info_entry("devices", 0, proc_bus_zorro_dir,
 				       get_zorro_dev_info);
 		for (slot = 0; slot < zorro_num_autocon; slot++)
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -22,7 +22,7 @@
 
 #include "internal.h"
 
-struct proc_dir_entry *proc_bus, *proc_root_fs, *proc_root_driver;
+struct proc_dir_entry *proc_root_fs, *proc_root_driver;
 
 static int proc_test_super(struct super_block *sb, void *data)
 {
@@ -137,7 +137,7 @@ void __init proc_root_init(void)
 #ifdef CONFIG_PROC_DEVICETREE
 	proc_device_tree_init();
 #endif
-	proc_bus = proc_mkdir("bus", NULL);
+	proc_mkdir("bus", NULL);
 	proc_sys_init();
 }
 
@@ -236,5 +236,4 @@ EXPORT_SYMBOL(proc_create);
 EXPORT_SYMBOL(remove_proc_entry);
 EXPORT_SYMBOL(proc_root);
 EXPORT_SYMBOL(proc_root_fs);
-EXPORT_SYMBOL(proc_bus);
 EXPORT_SYMBOL(proc_root_driver);
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -98,7 +98,6 @@ struct vmcore {
 
 extern struct proc_dir_entry proc_root;
 extern struct proc_dir_entry *proc_root_fs;
-extern struct proc_dir_entry *proc_bus;
 extern struct proc_dir_entry *proc_root_driver;
 extern struct proc_dir_entry *proc_root_kcore;
 
@@ -214,7 +213,6 @@ extern void dup_mm_exe_file(struct mm_struct *oldmm, struct mm_struct *newmm);
 #else
 
 #define proc_root_driver NULL
-#define proc_bus NULL
 
 #define proc_net_fops_create(net, name, mode, fops)  ({ (void)(mode), NULL; })
 static inline void proc_net_remove(struct net *net, const char *name) {}
-- 
1.5.4.3



Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbXKERSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbXKERSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757808AbXKERI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:08:26 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59546 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757232AbXKERIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:08:23 -0500
Date: Mon, 5 Nov 2007 18:07:59 +0100
From: Adrian Bunk <bunk@kernel.org>
To: funaho@jurai.org, geert@linux-m68k.org, zippel@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] kill drivers/nubus/nubus_syms.c
Message-ID: <20071105170759.GZ12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL's belong to the actual code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/nubus/Makefile     |    1 -
 drivers/nubus/nubus.c      |   13 +++++++++++++
 drivers/nubus/nubus_syms.c |   28 ----------------------------
 drivers/nubus/proc.c       |    2 ++
 4 files changed, 15 insertions(+), 29 deletions(-)

9475251791883b5d3f0f19bcbbcd6e61e16c1ec3 
diff --git a/drivers/nubus/Makefile b/drivers/nubus/Makefile
index f5ef03c..21bda20 100644
--- a/drivers/nubus/Makefile
+++ b/drivers/nubus/Makefile
@@ -4,5 +4,4 @@
 
 obj-y   := nubus.o
 
-obj-$(CONFIG_MODULES) += nubus_syms.o 
 obj-$(CONFIG_PROC_FS) += proc.o
diff --git a/drivers/nubus/nubus.c b/drivers/nubus/nubus.c
index e503c9c..3cf7213 100644
--- a/drivers/nubus/nubus.c
+++ b/drivers/nubus/nubus.c
@@ -14,6 +14,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 #include <asm/setup.h>
 #include <asm/system.h>
 #include <asm/page.h>
@@ -186,6 +187,7 @@ void nubus_get_rsrc_mem(void *dest, const struct nubus_dirent* dirent,
 		len--;
 	}
 }
+EXPORT_SYMBOL(nubus_get_rsrc_mem);
 
 void nubus_get_rsrc_str(void *dest, const struct nubus_dirent* dirent,
 			int len)
@@ -200,6 +202,7 @@ void nubus_get_rsrc_str(void *dest, const struct nubus_dirent* dirent,
 		len--;
 	}
 }
+EXPORT_SYMBOL(nubus_get_rsrc_str);
 
 int nubus_get_root_dir(const struct nubus_board* board,
 		       struct nubus_dir* dir)
@@ -209,6 +212,7 @@ int nubus_get_root_dir(const struct nubus_board* board,
 	dir->mask = board->lanes;
 	return 0;
 }
+EXPORT_SYMBOL(nubus_get_root_dir);
 
 /* This is a slyly renamed version of the above */
 int nubus_get_func_dir(const struct nubus_dev* dev,
@@ -219,6 +223,7 @@ int nubus_get_func_dir(const struct nubus_dev* dev,
 	dir->mask = dev->board->lanes;
 	return 0;
 }
+EXPORT_SYMBOL(nubus_get_func_dir);
 
 int nubus_get_board_dir(const struct nubus_board* board,
 			struct nubus_dir* dir)
@@ -237,6 +242,7 @@ int nubus_get_board_dir(const struct nubus_board* board,
 		return -1;
 	return 0;
 }
+EXPORT_SYMBOL(nubus_get_board_dir);
 
 int nubus_get_subdir(const struct nubus_dirent *ent,
 		     struct nubus_dir *dir)
@@ -246,6 +252,7 @@ int nubus_get_subdir(const struct nubus_dirent *ent,
 	dir->mask = ent->mask;
 	return 0;
 }
+EXPORT_SYMBOL(nubus_get_subdir);
 
 int nubus_readdir(struct nubus_dir *nd, struct nubus_dirent *ent)
 {
@@ -274,12 +281,14 @@ int nubus_readdir(struct nubus_dir *nd, struct nubus_dirent *ent)
 	ent->mask  = nd->mask;
 	return 0;
 }
+EXPORT_SYMBOL(nubus_readdir);
 
 int nubus_rewinddir(struct nubus_dir* dir)
 {
 	dir->ptr = dir->base;
 	return 0;
 }
+EXPORT_SYMBOL(nubus_rewinddir);
 
 /* Driver interface functions, more or less like in pci.c */
 
@@ -303,6 +312,7 @@ nubus_find_device(unsigned short category,
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(nubus_find_device);
 
 struct nubus_dev*
 nubus_find_type(unsigned short category,
@@ -320,6 +330,7 @@ nubus_find_type(unsigned short category,
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(nubus_find_type);
 
 struct nubus_dev*
 nubus_find_slot(unsigned int slot,
@@ -335,6 +346,7 @@ nubus_find_slot(unsigned int slot,
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(nubus_find_slot);
 
 int
 nubus_find_rsrc(struct nubus_dir* dir, unsigned char rsrc_type,
@@ -346,6 +358,7 @@ nubus_find_rsrc(struct nubus_dir* dir, unsigned char rsrc_type,
 	}	
 	return -1;
 }
+EXPORT_SYMBOL(nubus_find_rsrc);
 
 /* Initialization functions - decide which slots contain stuff worth
    looking at, and print out lots and lots of information from the
diff --git a/drivers/nubus/nubus_syms.c b/drivers/nubus/nubus_syms.c
deleted file mode 100644
index 9204f04..0000000
--- a/drivers/nubus/nubus_syms.c
+++ /dev/null
@@ -1,28 +0,0 @@
-/* Exported symbols for NuBus services
-
-   (c) 1999 David Huggins-Daines <dhd@debian.org> */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/nubus.h>
-
-#ifdef CONFIG_PROC_FS
-EXPORT_SYMBOL(nubus_proc_attach_device);
-EXPORT_SYMBOL(nubus_proc_detach_device);
-#endif
-
-MODULE_LICENSE("GPL");
-
-EXPORT_SYMBOL(nubus_find_device);
-EXPORT_SYMBOL(nubus_find_type);
-EXPORT_SYMBOL(nubus_find_slot);
-EXPORT_SYMBOL(nubus_get_root_dir);
-EXPORT_SYMBOL(nubus_get_board_dir);
-EXPORT_SYMBOL(nubus_get_func_dir);
-EXPORT_SYMBOL(nubus_readdir);
-EXPORT_SYMBOL(nubus_find_rsrc);
-EXPORT_SYMBOL(nubus_rewinddir);
-EXPORT_SYMBOL(nubus_get_subdir);
-EXPORT_SYMBOL(nubus_get_rsrc_mem);
-EXPORT_SYMBOL(nubus_get_rsrc_str);
-
diff --git a/drivers/nubus/proc.c b/drivers/nubus/proc.c
index 5271a4a..fd410fb 100644
--- a/drivers/nubus/proc.c
+++ b/drivers/nubus/proc.c
@@ -140,6 +140,7 @@ int nubus_proc_attach_device(struct nubus_dev *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL(nubus_proc_attach_device);
 
 /* FIXME: this is certainly broken! */
 int nubus_proc_detach_device(struct nubus_dev *dev)
@@ -154,6 +155,7 @@ int nubus_proc_detach_device(struct nubus_dev *dev)
 	}
 	return 0;
 }
+EXPORT_SYMBOL(nubus_proc_detach_device);
 
 void __init proc_bus_nubus_add_devices(void)
 {


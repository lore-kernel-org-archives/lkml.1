Return-Path: <linux-kernel-owner+w=401wt.eu-S933646AbXDHDk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646AbXDHDk7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 23:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933660AbXDHDk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 23:40:59 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:53791 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933646AbXDHDk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 23:40:57 -0400
Date: Sat, 7 Apr 2007 23:40:50 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: aeb@cwi.nl
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] partitions: Add conditionals and static inline stubs to
 helpers in headers
In-Reply-To: <alpine.DEB.0.83.0704072235180.27057@sigma.j-a-k-j.com>
Message-ID: <alpine.DEB.0.83.0704072340100.27057@sigma.j-a-k-j.com>
References: <alpine.DEB.0.83.0704072235180.27057@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

Functions of the form adfspart_check_FOO and foo_partition defined in 
fs/partitions/*.h are helper functions called in a deliberate order by 
check_partition in check.c. Add conditional-compilation directives and 
static inline no-op functions to allow code to indiscriminately call these 
functions irrespective of whether they do anything, removing the necessity 
of oodles of #ifdef/#endif in function bodies.

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

---

The next patch changes the check.c code to use these function definitions 
in a nicer way.

--- linux-2.6.20.6-orig/fs/partitions/acorn.h	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/acorn.h	2007-04-07 20:02:51.000000000 -0400
@@ -7,8 +7,47 @@
  *  format, and everyone stick to it?
  */
 
-int adfspart_check_CUMANA(struct parsed_partitions *state, struct block_device *bdev);
-int adfspart_check_ADFS(struct parsed_partitions *state, struct block_device *bdev);
-int adfspart_check_ICS(struct parsed_partitions *state, struct block_device *bdev);
-int adfspart_check_POWERTEC(struct parsed_partitions *state, struct block_device *bdev);
-int adfspart_check_EESOX(struct parsed_partitions *state, struct block_device *bdev);
+#ifdef CONFIG_ACORN_PARTITION_ICS
+	int adfspart_check_ICS(struct parsed_partitions *state, struct block_device *bdev);
+#else
+	static inline int adfspart_check_ICS(struct parsed_partitions *state, struct block_device *bdev)
+	{
+		return 0;
+	}
+#endif
+
+#ifdef CONFIG_ACORN_PARTITION_POWERTEC
+	int adfspart_check_POWERTEC(struct parsed_partitions *state, struct block_device *bdev);
+#else
+	static inline int adfspart_check_POWERTEC(struct parsed_partitions *state, struct block_device *bdev)
+	{
+		return 0;
+	}
+#endif
+
+#ifdef CONFIG_ACORN_PARTITION_EESOX
+	int adfspart_check_EESOX(struct parsed_partitions *state, struct block_device *bdev);
+#else
+	static inline int adfspart_check_EESOX(struct parsed_partitions *state, struct block_device *bdev)
+	{
+		return 0;
+	}
+#endif
+
+#ifdef CONFIG_ACORN_PARTITION_CUMANA
+	int adfspart_check_CUMANA(struct parsed_partitions *state, struct block_device *bdev);
+#else
+	static inline int adfspart_check_CUMANA(struct parsed_partitions *state, struct block_device *bdev)
+	{
+		return 0;
+	}
+#endif
+
+#ifdef CONFIG_ACORN_PARTITION_ADFS
+	int adfspart_check_ADFS(struct parsed_partitions *state, struct block_device *bdev);
+#else
+	static inline int adfspart_check_ADFS(struct parsed_partitions *state, struct block_device *bdev)
+	{
+		return 0;
+	}
+#endif
--- linux-2.6.20.6-orig/fs/partitions/amiga.h	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/amiga.h	2007-04-07 20:04:10.000000000 -0400
@@ -2,5 +2,11 @@
  *  fs/partitions/amiga.h
  */
 
-int amiga_partition(struct parsed_partitions *state, struct block_device *bdev);
-
+#ifdef CONFIG_AMIGA_PARTITION
+	int amiga_partition(struct parsed_partitions *state, struct block_device *bdev);
+#else
+	static inline int amiga_partition(struct parsed_partitions *state, struct block_device *bdev)
+	{
+		return 0;
+	}
+#endif
--- linux-2.6.20.6-orig/fs/partitions/atari.h	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/atari.h	2007-04-07 20:05:34.000000000 -0400
@@ -31,4 +31,11 @@ struct rootsector
   u16 checksum;			/* checksum for bootable disks */
 } __attribute__((__packed__));
 
-int atari_partition(struct parsed_partitions *state, struct block_device *bdev);
+#ifdef CONFIG_ATARI_PARTITION
+	int atari_partition(struct parsed_partitions *state, struct block_device *bdev);
+#else
+	static inline int atari_partition(struct parsed_partitions *state, struct block_device *bdev)
+	{
+		return 0;
+	}
+#endif
--- linux-2.6.20.6-orig/fs/partitions/efi.h	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/efi.h	2007-04-07 20:06:28.000000000 -0400
@@ -106,7 +106,14 @@ typedef struct _legacy_mbr {
 } __attribute__ ((packed)) legacy_mbr;
 
 /* Functions */
-extern int efi_partition(struct parsed_partitions *state, struct block_device *bdev);
+#ifdef CONFIG_EFI_PARTITION
+	int efi_partition(struct parsed_partitions *state, struct block_device *bdev);
+#else
+	static inline int efi_partition(struct parsed_partitions *state, struct block_device *bdev)
+	{
+		return 0;
+	}
+#endif
 
 #endif
 
--- linux-2.6.20.6-orig/fs/partitions/ibm.h	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/ibm.h	2007-04-07 22:06:16.000000000 -0400
@@ -1 +1,8 @@
-int ibm_partition(struct parsed_partitions *, struct block_device *);
+#ifdef CONFIG_IBM_PARTITION
+	int ibm_partition(struct parsed_partitions *state, struct block_device *bdev);
+#else
+	static inline int ibm_partition(struct parsed_partitions *state, struct block_device *bdev)
+	{
+		return 0;
+	}
+#endif
--- linux-2.6.20.6-orig/fs/partitions/karma.h	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/karma.h	2007-04-07 20:13:57.000000000 -0400
@@ -4,5 +4,11 @@
 
 #define KARMA_LABEL_MAGIC		0xAB56
 
-int karma_partition(struct parsed_partitions *state, struct block_device *bdev);
-
+#ifdef CONFIG_KARMA_PARTITION
+	int karma_partition(struct parsed_partitions *state, struct block_device *bdev);
+#else
+	static inline int karma_partition(struct parsed_partitions *state, struct block_device *bdev)
+	{
+		return 0;
+	}
+#endif
--- linux-2.6.20.6-orig/fs/partitions/ldm.h	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/ldm.h	2007-04-07 20:14:34.000000000 -0400
@@ -214,7 +214,14 @@ struct ldmdb {				/* Cache of the databa
 	struct list_head v_part;
 };
 
-int ldm_partition (struct parsed_partitions *state, struct block_device *bdev);
+#ifdef CONFIG_LDM_PARTITION
+	int ldm_partition (struct parsed_partitions *state, struct block_device *bdev);
+#else
+	static inline int ldm_partition (struct parsed_partitions *state, struct block_device *bdev)
+	{
+		return 0;
+	}
+#endif
 
 #endif /* _FS_PT_LDM_H_ */
 
--- linux-2.6.20.6-orig/fs/partitions/mac.h	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/mac.h	2007-04-07 20:15:09.000000000 -0400
@@ -41,4 +41,11 @@ struct mac_driver_desc {
     /* ... more stuff */
 };
 
-int mac_partition(struct parsed_partitions *state, struct block_device *bdev);
+#ifdef CONFIG_MAC_PARTITION
+	int mac_partition(struct parsed_partitions *state, struct block_device *bdev);
+#else
+	static inline int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
+	{
+		return 0;
+	}
+#endif
--- linux-2.6.20.6-orig/fs/partitions/msdos.h	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/msdos.h	2007-04-07 20:15:40.000000000 -0400
@@ -4,5 +4,11 @@
 
 #define MSDOS_LABEL_MAGIC		0xAA55
 
-int msdos_partition(struct parsed_partitions *state, struct block_device *bdev);
-
+#ifdef CONFIG_MSDOS_PARTITION
+	int msdos_partition(struct parsed_partitions *state, struct block_device *bdev);
+#else
+	static inline int msdos_partition(struct parsed_partitions *state, struct block_device *bdev)
+	{
+		return 0;
+	}
+#endif
--- linux-2.6.20.6-orig/fs/partitions/osf.h	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/osf.h	2007-04-07 20:16:14.000000000 -0400
@@ -4,4 +4,11 @@
 
 #define DISKLABELMAGIC (0x82564557UL)
 
-int osf_partition(struct parsed_partitions *state, struct block_device *bdev);
+#ifdef CONFIG_OSF_PARTITION
+	int osf_partition(struct parsed_partitions *state, struct block_device *bdev);
+#else
+	static inline int osf_partition(struct parsed_partitions *state, struct block_device *bdev)
+	{
+		return 0;
+	}
+#endif
--- linux-2.6.20.6-orig/fs/partitions/sgi.h	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/sgi.h	2007-04-07 20:16:49.000000000 -0400
@@ -2,7 +2,14 @@
  *  fs/partitions/sgi.h
  */
 
-extern int sgi_partition(struct parsed_partitions *state, struct block_device *bdev);
+#ifdef CONFIG_SGI_PARTITION
+	int sgi_partition(struct parsed_partitions *state, struct block_device *bdev);
+#else
+	static inline int sgi_partition(struct parsed_partitions *state, struct block_device *bdev)
+	{
+		return 0;
+	}
+#endif
 
 #define SGI_LABEL_MAGIC 0x0be5a941
 
--- linux-2.6.20.6-orig/fs/partitions/sun.h	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/sun.h	2007-04-07 20:17:18.000000000 -0400
@@ -4,4 +4,11 @@
 
 #define SUN_LABEL_MAGIC          0xDABE
 
-int sun_partition(struct parsed_partitions *state, struct block_device *bdev);
+#ifdef CONFIG_SUN_PARTITION
+	int sun_partition(struct parsed_partitions *state, struct block_device *bdev);
+#else
+	static inline int sun_partition(struct parsed_partitions *state, struct block_device *bdev)
+	{
+		return 0;
+	}
+#endif
--- linux-2.6.20.6-orig/fs/partitions/ultrix.h	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/ultrix.h	2007-04-07 20:17:45.000000000 -0400
@@ -2,4 +2,11 @@
  *  fs/partitions/ultrix.h
  */
 
-int ultrix_partition(struct parsed_partitions *state, struct block_device *bdev);
+#ifdef CONFIG_ULTRIX_PARTITION
+	int ultrix_partition(struct parsed_partitions *state, struct block_device *bdev);
+#else
+	static inline int ultrix_partition(struct parsed_partitions *state, struct block_device *bdev)
+	{
+		return 0;
+	}
+#endif

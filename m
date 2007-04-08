Return-Path: <linux-kernel-owner+w=401wt.eu-S932753AbXDHDkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbXDHDkS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 23:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933646AbXDHDkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 23:40:17 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:53766 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753AbXDHDkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 23:40:15 -0400
Date: Sat, 7 Apr 2007 23:40:07 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: aeb@cwi.nl
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] partitions: Add conditionals to acorn.c to clear benign
 compiler warnings
In-Reply-To: <alpine.DEB.0.83.0704072235180.27057@sigma.j-a-k-j.com>
Message-ID: <alpine.DEB.0.83.0704072339290.27057@sigma.j-a-k-j.com>
References: <alpine.DEB.0.83.0704072235180.27057@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

Adds conditional-compilation directives to fs/partitions/acorn.c to 
prevent compilation of the functions adfs_partition and linux_partition 
which are used only within ACORN_PARTITION_CUMANA and ACORN_PARTITION_ADFS 
sections, thereby preventing unused-function compiler warnings if 
ACORN_PARTITION is defined and neither of the other two are.

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

---

Nothing using these two functions is defined except inside CUMANA and 
ADFS, so without either of those, nothing using these functions is 
compiled, hence the unused-function warning. Both CUMANA and ADFS code use 
both functions so they must be included if either symbol is defined.

--- linux-2.6.20.6-orig/fs/partitions/acorn.c	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/acorn.c	2007-04-07 21:40:39.000000000 -0400
@@ -25,6 +25,8 @@
 #define PARTITION_RISCIX_SCSI	2
 #define PARTITION_LINUX		9
 
+#if defined(CONFIG_ACORN_PARTITION_CUMANA) || defined(CONFIG_ACORN_PARTITION_ADFS)
+
 static struct adfs_discrecord *
 adfs_partition(struct parsed_partitions *state, char *name, char *data,
 	       unsigned long first_sector, int slot)
@@ -49,6 +51,8 @@ adfs_partition(struct parsed_partitions 
 	return dr;
 }
 
+#endif
+
 #ifdef CONFIG_ACORN_PARTITION_RISCIX
 
 struct riscix_part {
@@ -106,6 +110,8 @@ riscix_partition(struct parsed_partition
 }
 #endif
 
+#if defined(CONFIG_ACORN_PARTITION_CUMANA) || defined(CONFIG_ACORN_PARTITION_ADFS)
+
 #define LINUX_NATIVE_MAGIC 0xdeafa1de
 #define LINUX_SWAP_MAGIC   0xdeafab1e
 
@@ -147,6 +153,8 @@ linux_partition(struct parsed_partitions
 	return slot;
 }
 
+#endif
+
 #ifdef CONFIG_ACORN_PARTITION_CUMANA
 int
 adfspart_check_CUMANA(struct parsed_partitions *state, struct block_device *bdev)

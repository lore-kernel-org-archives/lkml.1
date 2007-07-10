Return-Path: <linux-kernel-owner+w=401wt.eu-S1764225AbXGJVpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764225AbXGJVpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 17:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbXGJVpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 17:45:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:61244 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760550AbXGJVpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 17:45:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=LuauYUNT9+UWqZ3890F6S+JOhAB1lHb3eoB2YNTQ4HBeiebuN4zxWkZeWf0+bcgUimG/2gFKWmbyiHqHTj9rRmWm083ZnJ8g+ChdtVz30Y2e8F++lMnWxk2mIl/2iRBqe8VAEpIa5u3p6Km3kr2WPj//6jBoRAYLM+uT/dJLEuM=
Message-ID: <6defe8840707101445g638ce955x666d3dac737c1836@mail.gmail.com>
Date: Tue, 10 Jul 2007 17:45:40 -0400
From: "Denver Gingerich" <denver@ossguy.com>
To: linux-kernel@vger.kernel.org, "Andries Brouwer" <aeb@cwi.nl>
Subject: [PATCH] fix compiler warnings in acorn.c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: a24a7147eedaa203
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Correct the following compiler warnings:
warning: 'adfs_partition' defined but not used
warning: 'riscix_partition' defined but not used
warning: 'linux_partition' defined but not used

Signed-off-by: Denver Gingerich <denver@ossguy.com>

---

--- linux-2.6.22/fs/partitions/acorn.c.000	2007-05-09 18:56:41.000000000 -0400
+++ linux-2.6.22/fs/partitions/acorn.c	2007-05-09 20:44:04.000000000 -0400
@@ -25,6 +25,8 @@
 #define PARTITION_RISCIX_SCSI	2
 #define PARTITION_LINUX		9

+#if defined(CONFIG_ACORN_PARTITION_CUMANA) || \
+	defined(CONFIG_ACORN_PARTITION_ADFS)
 static struct adfs_discrecord *
 adfs_partition(struct parsed_partitions *state, char *name, char *data,
 	       unsigned long first_sector, int slot)
@@ -48,6 +50,7 @@ adfs_partition(struct parsed_partitions
 	put_partition(state, slot, first_sector, nr_sects);
 	return dr;
 }
+#endif

 #ifdef CONFIG_ACORN_PARTITION_RISCIX

@@ -65,6 +68,8 @@ struct riscix_record {
 	struct riscix_part part[8];
 };

+#if defined(CONFIG_ACORN_PARTITION_CUMANA) || \
+	defined(CONFIG_ACORN_PARTITION_ADFS)
 static int
 riscix_partition(struct parsed_partitions *state, struct block_device *bdev,
 		unsigned long first_sect, int slot, unsigned long nr_sects)
@@ -105,6 +110,7 @@ riscix_partition(struct parsed_partition
 	return slot;
 }
 #endif
+#endif

 #define LINUX_NATIVE_MAGIC 0xdeafa1de
 #define LINUX_SWAP_MAGIC   0xdeafab1e
@@ -115,6 +121,8 @@ struct linux_part {
 	__le32 nr_sects;
 };

+#if defined(CONFIG_ACORN_PARTITION_CUMANA) || \
+	defined(CONFIG_ACORN_PARTITION_ADFS)
 static int
 linux_partition(struct parsed_partitions *state, struct block_device *bdev,
 		unsigned long first_sect, int slot, unsigned long nr_sects)
@@ -146,6 +154,7 @@ linux_partition(struct parsed_partitions
 	put_dev_sector(sect);
 	return slot;
 }
+#endif

 #ifdef CONFIG_ACORN_PARTITION_CUMANA
 int

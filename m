Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbXEUCbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbXEUCbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 22:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbXEUCbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 22:31:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:25530 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbXEUCbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 22:31:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=o8rV4mUitqqGnpMw2Y4jcA2xJVRta3OO0Kr6Ar2lUAWO3Dtlh8VN/t7BIvh+UUWUkKXS1ytX6x621HaGosC4JSlNNeVSdTwkaWovZiL8/03YHNn3xkFy3Ej3q7GR7q+nUpihO/t+xPLfam1enVwV+Iv5adWvAMasRORPeQ3lxMQ=
Message-ID: <6defe8840705201931q2e433d0fo6fe334911afd1b01@mail.gmail.com>
Date: Sun, 20 May 2007 22:31:14 -0400
From: "Denver Gingerich" <denver@ossguy.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix compiler warnings in acorn.c
In-Reply-To: <6defe8840705091822s3e99e73l2d8aaaa328fd24da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6defe8840705091822s3e99e73l2d8aaaa328fd24da@mail.gmail.com>
X-Google-Sender-Auth: 029ba42144860520
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Denver Gingerich <denver@ossguy.com>
Date: May 9, 2007 9:22 PM
Subject: [PATCH] fix compiler warnings in acorn.c
To: kernel-janitors@lists.linux-foundation.org


Correct the following compiler warnings:
warning: 'adfs_partition' defined but not used
warning: 'riscix_partition' defined but not used
warning: 'linux_partition' defined but not used

Signed-off-by: Denver Gingerich <denver@ossguy.com>

---

--- linux-2.6.21/fs/partitions/acorn.c.000      2007-05-09
18:56:41.000000000 -0400
+++ linux-2.6.21/fs/partitions/acorn.c  2007-05-09 20:44:04.000000000 -0400
@@ -25,6 +25,8 @@
 #define PARTITION_RISCIX_SCSI  2
 #define PARTITION_LINUX                9

+#if defined(CONFIG_ACORN_PARTITION_CUMANA) || \
+       defined(CONFIG_ACORN_PARTITION_ADFS)
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
+       defined(CONFIG_ACORN_PARTITION_ADFS)
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
+       defined(CONFIG_ACORN_PARTITION_ADFS)
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

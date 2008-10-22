Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbYJVXaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbYJVXaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 19:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbYJVXaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 19:30:11 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:10795 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbYJVXaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 19:30:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=xtvjNGLkKkvquR/bvD2QMpDbN/xXdl2a3l3xUU4fbtbayCpAwj24y+U8pP28bGglo4
         iY+NXWWHan3s7lKzZkxHQfUq3+BuvEFcb8kLNq3+K/uHtNjBRJJn9NFFWetkp8WaGWWi
         qscY8Kn0hVwFzgGRx0H3t3kTsptyIcyoCI2QU=
Subject: [PATCH] memstick: annotate endianness of attribute structs
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 16:30:04 -0700
Message-Id: <1224718204.6823.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code was shifting the endianness appropriately everywhere, annotate
the structs to avoid the sparse warnings when assigning the endian types
to the struct members, or passing them to be[16|32]_to_cpu:

drivers/memstick/core/mspro_block.c:331:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:333:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:335:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:337:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:341:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:347:4: warning: cast to restricted __be32
drivers/memstick/core/mspro_block.c:356:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:358:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:364:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:367:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:369:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:371:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:377:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:478:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:480:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:482:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:484:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:486:4: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:689:22:    expected unsigned int [unsigned] [assigned] data_address
drivers/memstick/core/mspro_block.c:689:22:    got restricted __be32 [usertype] <noident>
drivers/memstick/core/mspro_block.c:697:3: warning: cast to restricted __be32
drivers/memstick/core/mspro_block.c:960:17: warning: incorrect type in initializer (different base types)
drivers/memstick/core/mspro_block.c:960:17:    expected unsigned short [unsigned] data_count
drivers/memstick/core/mspro_block.c:960:17:    got restricted __be16 [usertype] <noident>
drivers/memstick/core/mspro_block.c:993:6: warning: cast to restricted __be16
drivers/memstick/core/mspro_block.c:995:28: warning: cast to restricted __be16

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/memstick/core/mspro_block.c |   43 +++++++++++++++++------------------
 include/linux/memstick.h            |    4 +-
 2 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 7911151..89b9a6a 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -52,14 +52,14 @@ struct mspro_sys_attr {
 };
 
 struct mspro_attr_entry {
-	unsigned int  address;
-	unsigned int  size;
+	__be32 address;
+	__be32 size;
 	unsigned char id;
 	unsigned char reserved[3];
 } __attribute__((packed));
 
 struct mspro_attribute {
-	unsigned short          signature;
+	__be16 signature;
 	unsigned short          version;
 	unsigned char           count;
 	unsigned char           reserved[11];
@@ -69,28 +69,28 @@ struct mspro_attribute {
 struct mspro_sys_info {
 	unsigned char  class;
 	unsigned char  reserved0;
-	unsigned short block_size;
-	unsigned short block_count;
-	unsigned short user_block_count;
-	unsigned short page_size;
+	__be16 block_size;
+	__be16 block_count;
+	__be16 user_block_count;
+	__be16 page_size;
 	unsigned char  reserved1[2];
 	unsigned char  assembly_date[8];
-	unsigned int   serial_number;
+	__be32 serial_number;
 	unsigned char  assembly_maker_code;
 	unsigned char  assembly_model_code[3];
-	unsigned short memory_maker_code;
-	unsigned short memory_model_code;
+	__be16 memory_maker_code;
+	__be16 memory_model_code;
 	unsigned char  reserved2[4];
 	unsigned char  vcc;
 	unsigned char  vpp;
-	unsigned short controller_number;
-	unsigned short controller_function;
-	unsigned short start_sector;
-	unsigned short unit_size;
+	__be16 controller_number;
+	__be16 controller_function;
+	__be16 start_sector;
+	__be16 unit_size;
 	unsigned char  ms_sub_class;
 	unsigned char  reserved3[4];
 	unsigned char  interface_type;
-	unsigned short controller_code;
+	__be16 controller_code;
 	unsigned char  format_type;
 	unsigned char  reserved4;
 	unsigned char  device_type;
@@ -124,11 +124,11 @@ struct mspro_specfile {
 } __attribute__((packed));
 
 struct mspro_devinfo {
-	unsigned short cylinders;
-	unsigned short heads;
-	unsigned short bytes_per_track;
-	unsigned short bytes_per_sector;
-	unsigned short sectors_per_track;
+	__be16 cylinders;
+	__be16 heads;
+	__be16 bytes_per_track;
+	__be16 bytes_per_sector;
+	__be16 sectors_per_track;
 	unsigned char  reserved[6];
 } __attribute__((packed));
 
@@ -338,8 +338,7 @@ static ssize_t mspro_block_attr_show_sysinfo(struct device *dev,
 	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "assembly date: "
 			"GMT%+d:%d %04u-%02u-%02u %02u:%02u:%02u\n",
 			date_tz, date_tz_f,
-			be16_to_cpu(*(unsigned short *)
-				    &x_sys->assembly_date[1]),
+			be16_to_cpup((__be16 *)&x_sys->assembly_date[1]),
 			x_sys->assembly_date[3], x_sys->assembly_date[4],
 			x_sys->assembly_date[5], x_sys->assembly_date[6],
 			x_sys->assembly_date[7]);
diff --git a/include/linux/memstick.h b/include/linux/memstick.h
index d0c37e6..690c35a 100644
--- a/include/linux/memstick.h
+++ b/include/linux/memstick.h
@@ -100,8 +100,8 @@ struct mspro_param_register {
 #define MEMSTICK_SYS_PAR8   0x40
 #define MEMSTICK_SYS_SERIAL 0x80
 
-	unsigned short data_count;
-	unsigned int   data_address;
+	__be16 data_count;
+	__be32 data_address;
 	unsigned char  tpc_param;
 } __attribute__((packed));
 
-- 
1.6.0.3.723.g757e




Return-Path: <linux-kernel-owner+w=401wt.eu-S1760750AbXIURfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760750AbXIURfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 13:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXIURf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 13:35:26 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:5852 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbXIURfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 13:35:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Sn7iZOy6UGNvyEudqDdyW+OlgTXPtwtMsrO4ajZjwYm9AXcgMcqD/Iq3eHthevM2CijZU199FO76MOEQL6dvItVJ8AJ8poifiu7BA8bzAFz+z/8IthA0w6fun+HZzHj2fqgqJPbNBKgnL04iJVLYnpQZIvU4Sez91U6Xytzqjcc=
Date: Fri, 21 Sep 2007 21:35:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] UDF: code style fixup v3
Message-ID: <20070921173514.GB7221@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does additional coding style fixup. Initially the
code is being distorted by Lindent (in my patches sent not very
long ago) and fixed in the followup patches but this stuff was
accidently missed.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

New and old compiled files were compared with cmp to check
for being identically. So the patch will not break the kernel.

Jan, could you please check super.c at line 770 (on current UDF tree)?
I've made a special note there with my prev. patches. I think this 'return'
case does look strange a bit.

 fs/udf/super.c   |   51 +++++++++++++++++++--------------------------------
 fs/udf/udftime.c |    5 ++---
 2 files changed, 21 insertions(+), 35 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index c68a6e7..4d4047c 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -913,8 +913,7 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 					UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table =
 						udf_iget(sb, loc);
 					if (!UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table) {
-						udf_debug("cannot load unallocSpaceTable (part %d)\n",
-							i);
+						udf_debug("cannot load unallocSpaceTable (part %d)\n", i);
 						return 1;
 					}
 					UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_UNALLOC_TABLE;
@@ -944,8 +943,7 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 					UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table =
 						udf_iget(sb, loc);
 					if (!UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table) {
-						udf_debug("cannot load freedSpaceTable (part %d)\n",
-							i);
+						udf_debug("cannot load freedSpaceTable (part %d)\n", i);
 						return 1;
 					}
 					UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_FREED_TABLE;
@@ -1293,19 +1291,16 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 
 			if (!UDF_SB_LASTBLOCK(sb)) {
 				udf_debug("Unable to determine Lastblock (For "
-						"Virtual Partition)\n");
+					  "Virtual Partition)\n");
 				return 1;
 			}
 
 			for (j = 0; j < UDF_SB_NUMPARTS(sb); j++) {
-				if (j != i && UDF_SB_PARTVSN(sb, i) ==
-					UDF_SB_PARTVSN(sb, j) &&
-				    	UDF_SB_PARTNUM(sb, i) ==
-						UDF_SB_PARTNUM(sb, j)) {
+				if (j != i &&
+				    UDF_SB_PARTVSN(sb, i) == UDF_SB_PARTVSN(sb, j) &&
+				    UDF_SB_PARTNUM(sb, i) == UDF_SB_PARTNUM(sb, j)) {
 					ino.partitionReferenceNum = j;
-					ino.logicalBlockNum =
-					    UDF_SB_LASTBLOCK(sb) -
-					    UDF_SB_PARTROOT(sb, j);
+					ino.logicalBlockNum = UDF_SB_LASTBLOCK(sb) - UDF_SB_PARTROOT(sb, j);
 					break;
 				}
 			}
@@ -1318,9 +1313,9 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 
 			if (UDF_SB_PARTTYPE(sb, i) == UDF_VIRTUAL_MAP15) {
 				UDF_SB_TYPEVIRT(sb, i).s_start_offset =
-				    udf_ext0_offset(UDF_SB_VAT(sb));
+					udf_ext0_offset(UDF_SB_VAT(sb));
 				UDF_SB_TYPEVIRT(sb, i).s_num_entries =
-				    (UDF_SB_VAT(sb)->i_size - 36) >> 2;
+					(UDF_SB_VAT(sb)->i_size - 36) >> 2;
 			} else if (UDF_SB_PARTTYPE(sb, i) == UDF_VIRTUAL_MAP20) {
 				struct buffer_head *bh = NULL;
 				uint32_t pos;
@@ -1330,19 +1325,15 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 				if (!bh)
 					return 1;
 				UDF_SB_TYPEVIRT(sb, i).s_start_offset =
-				    le16_to_cpu(((struct
-					virtualAllocationTable20 *)bh->b_data +
-					  udf_ext0_offset(UDF_SB_VAT(sb)))->
-						lengthHeader) +
-					  udf_ext0_offset(UDF_SB_VAT(sb));
-				UDF_SB_TYPEVIRT(sb, i).s_num_entries =
-				    (UDF_SB_VAT(sb)->i_size -
-				     UDF_SB_TYPEVIRT(sb, i).s_start_offset) >> 2;
+					le16_to_cpu(((struct virtualAllocationTable20 *)bh->b_data +
+						     udf_ext0_offset(UDF_SB_VAT(sb)))->lengthHeader) +
+					udf_ext0_offset(UDF_SB_VAT(sb));
+				UDF_SB_TYPEVIRT(sb, i).s_num_entries = (UDF_SB_VAT(sb)->i_size -
+									UDF_SB_TYPEVIRT(sb, i).s_start_offset) >> 2;
 				brelse(bh);
 			}
 			UDF_SB_PARTROOT(sb, i) = udf_get_pblock(sb, 0, i, 0);
-			UDF_SB_PARTLEN(sb, i) = UDF_SB_PARTLEN(sb,
-						ino.partitionReferenceNum);
+			UDF_SB_PARTLEN(sb, i) = UDF_SB_PARTLEN(sb, ino.partitionReferenceNum);
 		}
 	}
 	return 0;
@@ -1357,21 +1348,17 @@ static void udf_open_lvid(struct super_block *sb)
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
 		if (udf_time_to_stamp(&cpu_time, CURRENT_TIME))
-			UDF_SB_LVID(sb)->recordingDateAndTime =
-			    cpu_to_lets(cpu_time);
+			UDF_SB_LVID(sb)->recordingDateAndTime = cpu_to_lets(cpu_time);
 		UDF_SB_LVID(sb)->integrityType = LVID_INTEGRITY_TYPE_OPEN;
 
-		UDF_SB_LVID(sb)->descTag.descCRC =
-		    cpu_to_le16(udf_crc((char *)UDF_SB_LVID(sb) + sizeof(tag),
-					le16_to_cpu(UDF_SB_LVID(sb)->descTag.
-						    descCRCLength), 0));
+		UDF_SB_LVID(sb)->descTag.descCRC = cpu_to_le16(udf_crc((char *)UDF_SB_LVID(sb) + sizeof(tag),
+								       le16_to_cpu(UDF_SB_LVID(sb)->descTag.descCRCLength), 0));
 
 		UDF_SB_LVID(sb)->descTag.tagChecksum = 0;
 		for (i = 0; i < 16; i++)
 			if (i != 4)
 				UDF_SB_LVID(sb)->descTag.tagChecksum +=
-				    ((uint8_t *) &
-				     (UDF_SB_LVID(sb)->descTag))[i];
+					((uint8_t *) &(UDF_SB_LVID(sb)->descTag))[i];
 
 		mark_buffer_dirty(UDF_SB_LVIDBH(sb));
 	}
diff --git a/fs/udf/udftime.c b/fs/udf/udftime.c
index 3fd80eb..eb5b890 100644
--- a/fs/udf/udftime.c
+++ b/fs/udf/udftime.c
@@ -108,9 +108,8 @@ time_t *udf_stamp_to_time(time_t *dest, long *dest_usec, kernel_timestamp src)
 	*dest = year_seconds[src.year - EPOCH_YEAR];
 	*dest -= offset * 60;
 
-	yday = ((__mon_yday[__isleap (src.year)]
-		 [src.month - 1]) + (src.day - 1));
-	*dest += ( ( (yday * 24) + src.hour ) * 60 + src.minute ) * 60 + src.second;
+	yday = ((__mon_yday[__isleap(src.year)][src.month - 1]) + (src.day - 1));
+	*dest += (((yday * 24) + src.hour) * 60 + src.minute) * 60 + src.second;
 	*dest_usec = src.centiseconds * 10000 + src.hundredsOfMicroseconds * 100 + src.microseconds;
 	return dest;
 }


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbYFBJ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbYFBJ7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYFBJ7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:59:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32954 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYFBJ7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:59:04 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] ibmaem endianness annotations
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1K36og-0007Yt-Ho@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 02 Jun 2008 10:59:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index 5c006c9..c9416e6 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -189,8 +189,8 @@ static struct aem_iana_id system_x_id = {
 struct aem_find_firmware_req {
 	struct aem_iana_id	id;
 	u8			rsvd;
-	u16			index;
-	u16			module_type_id;
+	__be16			index;
+	__be16			module_type_id;
 } __packed;
 
 struct aem_find_firmware_resp {
@@ -202,7 +202,7 @@ struct aem_find_firmware_resp {
 struct aem_find_instance_req {
 	struct aem_iana_id	id;
 	u8			instance_number;
-	u16			module_type_id;
+	__be16			module_type_id;
 } __packed;
 
 struct aem_find_instance_resp {
@@ -444,17 +444,17 @@ static int aem_read_sensor(struct aem_data *data, u8 elt, u8 reg,
 	}
 	case 2: {
 		u16 *x = buf;
-		*x = be16_to_cpup((u16 *)rs_resp->bytes);
+		*x = be16_to_cpup((__be16 *)rs_resp->bytes);
 		break;
 	}
 	case 4: {
 		u32 *x = buf;
-		*x = be32_to_cpup((u32 *)rs_resp->bytes);
+		*x = be32_to_cpup((__be32 *)rs_resp->bytes);
 		break;
 	}
 	case 8: {
 		u64 *x = buf;
-		*x = be64_to_cpup((u64 *)rs_resp->bytes);
+		*x = be64_to_cpup((__be64 *)rs_resp->bytes);
 		break;
 	}
 	}

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYFAXdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYFAXdZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbYFAX2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:28:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:7108 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbYFAX2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:28:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=yFOWoSyk7sfoW06J0CI39DNYjXvcnsPahrIiX6BGsc9yfNc2aCFblfaeaKVSfFeJtWT0YIX/tAeK1JE1QpS4UM0bWjRFl3EJbmGeUGX9RpwiKGo49jPWRrtl4JffKXAGyH0WJG4h4OdkFenSQikOPgdBNWXMTGHklZ3o2fq9lAI=
Message-Id: <20080601231623.811622701@gmail.com>
References: <20080601231329.223608711@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 08:13:46 +0900
From: akinobu.mita@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org
Subject: [patch -v2 17/23] acpi: use memory_read_from_buffer
Content-Disposition: inline; filename=acpi-use-memory-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/system.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

Index: 2.6-git/drivers/acpi/system.c
===================================================================
--- 2.6-git.orig/drivers/acpi/system.c
+++ 2.6-git/drivers/acpi/system.c
@@ -77,7 +77,6 @@ static ssize_t acpi_table_show(struct ko
 	    container_of(bin_attr, struct acpi_table_attr, attr);
 	struct acpi_table_header *table_header = NULL;
 	acpi_status status;
-	ssize_t ret_count = count;
 
 	status =
 	    acpi_get_table(table_attr->name, table_attr->instance,
@@ -85,18 +84,8 @@ static ssize_t acpi_table_show(struct ko
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
-	if (offset >= table_header->length) {
-		ret_count = 0;
-		goto end;
-	}
-
-	if (offset + ret_count > table_header->length)
-		ret_count = table_header->length - offset;
-
-	memcpy(buf, ((char *)table_header) + offset, ret_count);
-
-      end:
-	return ret_count;
+	return memory_read_from_buffer(buf, count, &offset,
+					table_header, table_header->length);
 }
 
 static void acpi_table_attr_init(struct acpi_table_attr *table_attr,

-- 

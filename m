Return-Path: <linux-kernel-owner+w=401wt.eu-S1762220AbYFDMPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762220AbYFDMPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760483AbYFDMKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:10:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:20551 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbYFDMKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:10:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=Q1A9FJ0vA6BmuncnbZZAUogljIZZlyjKDv5+5O/smNWgBZHZudEy4/j2MHetdN5Y+C
         426IOn/Yidj+/NSsNmL3NisOYM8WlB6Y3oMBTuUQYt+/O7r/PP7XJx480GaS9sg4epQZ
         1UyJRQ+BLw14bMWi6fnJm6hiri7W0RLQEcF4g=
Message-Id: <20080604115824.062644468@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:49 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org
Subject: [patch -v3 16/22] acpi: use memory_read_from_buffer
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

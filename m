Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbZJRW6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbZJRW6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZJRW6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:58:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:62235 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbZJRW6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:58:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=ttAJQeXxI7rVsHq/bNcWUlgkxkPXHQ1b3bL5Jv6nYKwxNw6TLHgyl1i1zZg9STteVq
         Ctc5zeMiLGLkQIEANmX8kDCMupnksSH6MX9iUFojxKTcXrPEownCQ5KU1YqGXhdHhfJX
         OGmVAIRqqX9Ck3ZR8Fadv6fEPzXbtjzHCcM1A=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Len Brown <lenb@kernel.org>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org
Subject: [PATCH 7/7] acpi: fix trivial warnings caused by previous commmit
Date: Mon, 19 Oct 2009 01:54:34 +0300
Message-Id: <1255906474-25091-8-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/acpi/acpica/exfldio.c: In function ‘acpi_ex_extract_from_field’:
drivers/acpi/acpica/exfldio.c:761: warning: comparison of distinct pointer types lacks a cast
drivers/acpi/acpica/exfldio.c:761: warning: comparison of distinct pointer types lacks a cast
drivers/acpi/acpica/exfldio.c:761: warning: comparison of distinct pointer types lacks a cast
drivers/acpi/acpica/exfldio.c:780: warning: comparison of distinct pointer types lacks a cast
drivers/acpi/acpica/exfldio.c:780: warning: comparison of distinct pointer types lacks a cast
drivers/acpi/acpica/exfldio.c:780: warning: comparison of distinct pointer types lacks a cast
drivers/acpi/acpica/exfldio.c: In function ‘acpi_ex_insert_into_field’:
drivers/acpi/acpica/exfldio.c:880: warning: comparison of distinct pointer types lacks a cast
drivers/acpi/acpica/exfldio.c:880: warning: comparison of distinct pointer types lacks a cast
drivers/acpi/acpica/exfldio.c:880: warning: comparison of distinct pointer types lacks a cast
drivers/acpi/acpica/exfldio.c:933: warning: comparison of distinct pointer types lacks a cast
drivers/acpi/acpica/exfldio.c:933: warning: comparison of distinct pointer types lacks a cast
drivers/acpi/acpica/exfldio.c:933: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/acpi/acpica/exfldio.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpica/exfldio.c b/drivers/acpi/acpica/exfldio.c
index d7b3b41..597bc39 100644
--- a/drivers/acpi/acpica/exfldio.c
+++ b/drivers/acpi/acpica/exfldio.c
@@ -761,7 +761,7 @@ acpi_ex_extract_from_field(union acpi_operand_object *obj_desc,
 
 		ACPI_MEMCPY(((char *)buffer) + buffer_offset, &merged_datum,
 			    ACPI_MIN(obj_desc->common_field.access_byte_width,
-				     buffer_length - buffer_offset));
+				     (u8)(buffer_length - buffer_offset)));
 
 		buffer_offset += obj_desc->common_field.access_byte_width;
 		merged_datum =
@@ -780,7 +780,7 @@ acpi_ex_extract_from_field(union acpi_operand_object *obj_desc,
 
 	ACPI_MEMCPY(((char *)buffer) + buffer_offset, &merged_datum,
 		    ACPI_MIN(obj_desc->common_field.access_byte_width,
-			     buffer_length - buffer_offset));
+			     (u8)(buffer_length - buffer_offset)));
 
 	return_ACPI_STATUS(AE_OK);
 }
@@ -880,7 +880,7 @@ acpi_ex_insert_into_field(union acpi_operand_object *obj_desc,
 
 	ACPI_MEMCPY(&raw_datum, buffer,
 		    ACPI_MIN(obj_desc->common_field.access_byte_width,
-			     buffer_length - buffer_offset));
+			     (u8)(buffer_length - buffer_offset)));
 
 	merged_datum =
 	    raw_datum << obj_desc->common_field.start_field_bit_offset;
@@ -933,7 +933,7 @@ acpi_ex_insert_into_field(union acpi_operand_object *obj_desc,
 		buffer_offset += obj_desc->common_field.access_byte_width;
 		ACPI_MEMCPY(&raw_datum, ((char *)buffer) + buffer_offset,
 			    ACPI_MIN(obj_desc->common_field.access_byte_width,
-				     buffer_length - buffer_offset));
+				     (u8)(buffer_length - buffer_offset)));
 		merged_datum |=
 		    raw_datum << obj_desc->common_field.start_field_bit_offset;
 	}
-- 
1.6.5.1


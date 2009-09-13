Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbZIMTjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbZIMTjm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 15:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbZIMTjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 15:39:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:8748 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbZIMTjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 15:39:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=beZoLQ1VxRVJB/WddctajV5iajWgXLeCXtqJ9qiM3nOtPMDjL/lpn40CNrtwCvF22c
         S6Qh2xUvZvisnDCvDUz49t4/6K8GEQ+rIlBNwsyHMvEdYV/9hHQ91B45LLk0d6J1m7Gn
         9mX0OHffMn+ZjfuTPjPZ5d17y7C6uK1q10XOQ=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Contreras <felipe.contreras@gmail.com>, Len Brown <lenb@kernel.org>,
       Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org
Subject: [PATCH 5/5] acpi: fix trivial warnings caused by previous commmit
Date: Sun, 13 Sep 2009 22:38:27 +0300
Message-Id: <1252870707-4824-6-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1252870707-4824-5-git-send-email-felipe.contreras@gmail.com>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
 <1252870707-4824-2-git-send-email-felipe.contreras@gmail.com>
 <1252870707-4824-3-git-send-email-felipe.contreras@gmail.com>
 <1252870707-4824-4-git-send-email-felipe.contreras@gmail.com>
 <1252870707-4824-5-git-send-email-felipe.contreras@gmail.com>
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
index 6687be1..4affc5f 100644
--- a/drivers/acpi/acpica/exfldio.c
+++ b/drivers/acpi/acpica/exfldio.c
@@ -760,7 +760,7 @@ acpi_ex_extract_from_field(union acpi_operand_object *obj_desc,
 
 		ACPI_MEMCPY(((char *)buffer) + buffer_offset, &merged_datum,
 			    ACPI_MIN(obj_desc->common_field.access_byte_width,
-				     buffer_length - buffer_offset));
+				     (u8)(buffer_length - buffer_offset)));
 
 		buffer_offset += obj_desc->common_field.access_byte_width;
 		merged_datum =
@@ -779,7 +779,7 @@ acpi_ex_extract_from_field(union acpi_operand_object *obj_desc,
 
 	ACPI_MEMCPY(((char *)buffer) + buffer_offset, &merged_datum,
 		    ACPI_MIN(obj_desc->common_field.access_byte_width,
-			     buffer_length - buffer_offset));
+			     (u8)(buffer_length - buffer_offset)));
 
 	return_ACPI_STATUS(AE_OK);
 }
@@ -879,7 +879,7 @@ acpi_ex_insert_into_field(union acpi_operand_object *obj_desc,
 
 	ACPI_MEMCPY(&raw_datum, buffer,
 		    ACPI_MIN(obj_desc->common_field.access_byte_width,
-			     buffer_length - buffer_offset));
+			     (u8)(buffer_length - buffer_offset)));
 
 	merged_datum =
 	    raw_datum << obj_desc->common_field.start_field_bit_offset;
@@ -932,7 +932,7 @@ acpi_ex_insert_into_field(union acpi_operand_object *obj_desc,
 		buffer_offset += obj_desc->common_field.access_byte_width;
 		ACPI_MEMCPY(&raw_datum, ((char *)buffer) + buffer_offset,
 			    ACPI_MIN(obj_desc->common_field.access_byte_width,
-				     buffer_length - buffer_offset));
+				     (u8)(buffer_length - buffer_offset)));
 		merged_datum |=
 		    raw_datum << obj_desc->common_field.start_field_bit_offset;
 	}
-- 
1.6.5.rc1


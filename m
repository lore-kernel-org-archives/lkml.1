Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbZK3Lmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbZK3Lmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZK3Lmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:42:52 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:52655 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZK3Lmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:42:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ZWvQQSpY8s/r5ItYAZaND+Tkdm4P6fzYqRXOhKaVNr/tn9mpDHfLjxgfmx7LIoz56C
         uBmjLVQbBABBLel/isxLxNVXv2aOCybDTpztlHZFO1LSB/8tw57G7eSX4GkBUjky+jpV
         yoPhCyM9ubgVupTYRgeHoNagwuznLH3+j/wEg=
Message-ID: <4B13AFF2.5070200@gmail.com>
Date: Mon, 30 Nov 2009 19:43:46 +0800
From: "Helight.Xu" <helight.xu@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] fix a Section mismatch in arch/x86/pci/mmconfig-shared.c
 and include/linux/sfi_acpi.h
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_sfi_table_parse() should be __init. tested on x86 system!

warning msg:

WARNING: vmlinux.o(.text+0x322e69): Section mismatch in reference from 
the function acpi_sfi_table_parse() to the function 
.init.text:acpi_table_parse()
The function acpi_sfi_table_parse() references
the function __init acpi_table_parse().
This is often because acpi_sfi_table_parse lacks a __init
annotation or the annotation of acpi_table_parse is wrong.


Signed-off-by: ZhenwenXu <helight.xu@gmail.com>
---
include/linux/sfi_acpi.h |    4 ++--
1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sfi_acpi.h b/include/linux/sfi_acpi.h
index c4a5a8c..631af63 100644
--- a/include/linux/sfi_acpi.h
+++ b/include/linux/sfi_acpi.h
@@ -66,7 +66,7 @@ extern int sfi_acpi_table_parse(char *signature, char 
*oem_id,
                               char *oem_table_id,
                               int (*handler)(struct acpi_table_header *));

-static inline int acpi_sfi_table_parse(char *signature,
+static inline int __init acpi_sfi_table_parse(char *signature,
                               int (*handler)(struct acpi_table_header *))
{
       if (!acpi_table_parse(signature, handler))
@@ -83,7 +83,7 @@ static inline int sfi_acpi_table_parse(char 
*signature, char *oem_id,
       return -1;
}

-static inline int acpi_sfi_table_parse(char *signature,
+static inline int __init acpi_sfi_table_parse(char *signature,
                               int (*handler)(struct acpi_table_header *))
{
       return acpi_table_parse(signature, handler);
-- 
1.6.5.3

-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org


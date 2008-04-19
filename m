Return-Path: <linux-kernel-owner+w=401wt.eu-S1762400AbYDSPHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762400AbYDSPHs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 11:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762192AbYDSPGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 11:06:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:11069 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbYDSPGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 11:06:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=XumHi6fr3SRkHkqflztDRfABL5t5nKwEHGfaetZmVtOGYPLbb1HusXcLVj7xhU5g76s0ffNOjIrxfiTs863mDwi7NhrhPL8R+8LDR6vsgoATqU1/ac8EPO8Okpc/sgjDQE+R3pSaJgUnxgqDl3SZyo2xENEw2cEng36uym2z48U=
References: <20080419145510.150338641@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 19 Apr 2008 23:55:14 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 04/10] x86: remove unnecessary memset and NULL check after alloc_bootmem()
Content-Disposition: inline; filename=x86-hpet-res-alloc_bootmem-cleanup.patch
Message-ID: <480a0a86.0fba720a.1814.ffffa580@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memset and NULL check after alloc_bootmem() are unnecessary.
Because it returns zeroed memory and it never return NULL.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/acpi/boot.c |    4 ----
 1 file changed, 4 deletions(-)

Index: 2.6-git/arch/x86/kernel/acpi/boot.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/acpi/boot.c
+++ 2.6-git/arch/x86/kernel/acpi/boot.c
@@ -697,10 +697,6 @@ static int __init acpi_parse_hpet(struct
 #define HPET_RESOURCE_NAME_SIZE 9
 	hpet_res = alloc_bootmem(sizeof(*hpet_res) + HPET_RESOURCE_NAME_SIZE);
 
-	if (!hpet_res)
-		return 0;
-
-	memset(hpet_res, 0, sizeof(*hpet_res));
 	hpet_res->name = (void *)&hpet_res[1];
 	hpet_res->flags = IORESOURCE_MEM;
 	snprintf((char *)hpet_res->name, HPET_RESOURCE_NAME_SIZE, "HPET %u",

-- 

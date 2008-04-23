Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbYDWQe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbYDWQe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 12:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbYDWQeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 12:34:19 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:54766 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbYDWQeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 12:34:19 -0400
Message-ID: <480F6508.9090101@tiscali.nl>
Date: Wed, 23 Apr 2008 18:34:16 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] m32r: test before subtraction on unsigned relocation range
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

relocation is unsigned

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/m32r/kernel/module.c b/arch/m32r/kernel/module.c
index 8d42057..abecedf 100644
--- a/arch/m32r/kernel/module.c
+++ b/arch/m32r/kernel/module.c
@@ -171,13 +171,14 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 	    		COPY_UNALIGNED_WORD (value, *location, align);
 			break;
 		case R_M32R_18_PCREL_RELA:
-	  		relocation = (relocation - (Elf32_Addr) location);
-			if (relocation < -0x20000 || 0x1fffc < relocation)
+			if (relocation + 0x20000 < (Elf32_Addr) location ||
+					relocation >= 0x1fffc + (Elf32_Addr) location)
 				{
 					printk(KERN_ERR "module %s: relocation overflow: %u\n",
-					me->name, relocation);
+					me->name, relocation - (Elf32_Addr) location));
 					return -ENOEXEC;
 				}
+			relocation = (relocation - (Elf32_Addr) location);
 	    		COPY_UNALIGNED_WORD (*location, value, align);
 			if (value & 0xffff)
 				{
@@ -203,13 +204,14 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 	    		COPY_UNALIGNED_HWORD (hvalue, *hlocation, align);
 			break;
 		case R_M32R_26_PCREL_RELA:
-	  		relocation = (relocation - (Elf32_Addr) location);
-			if (relocation < -0x2000000 || 0x1fffffc < relocation)
+			if (relocation + 0x20000 < (Elf32_Addr) location ||
+					relocation >= 0x1fffc + (Elf32_Addr) location)
 				{
 					printk(KERN_ERR "module %s: relocation overflow: %u\n",
-					me->name, relocation);
+					me->name, relocation - (Elf32_Addr) location));
 					return -ENOEXEC;
 				}
+			relocation = (relocation - (Elf32_Addr) location);
 	    		COPY_UNALIGNED_WORD (*location, value, align);
 			if (value & 0xffffff)
 				{

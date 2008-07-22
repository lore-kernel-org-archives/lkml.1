Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbYGVAbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbYGVAbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 20:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbYGVA3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 20:29:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:9567 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbYGVA3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 20:29:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=VkpqY5J26EbV2YOEHPmvz81psKG9qjaMhxRGIYuT6QgB+YqcSMiD4mcz7gg5euwMbE
         lg07gM5SyuJnaIzfRVVHtKUfzXrdcKr+fRsmsXtGyjv7xX8PAcB73Bp1fbegsmHaR3GW
         De3BixoW2OJPVCKtwmfW7uTUKDpG5YlQm0MAY=
Message-ID: <488529F3.5090804@gmail.com>
Date: Mon, 21 Jul 2008 20:29:39 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] m32r: test below 0 on unsigned relocation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elf32_Addr relocation is unsigned so the test doesn't work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/m32r/kernel/module.c b/arch/m32r/kernel/module.c
index 8d42057..0af86f9 100644
--- a/arch/m32r/kernel/module.c
+++ b/arch/m32r/kernel/module.c
@@ -172,7 +172,7 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 			break;
 		case R_M32R_18_PCREL_RELA:
 	  		relocation = (relocation - (Elf32_Addr) location);
-			if (relocation < -0x20000 || 0x1fffc < relocation)
+			if (relocation > 0x1fffc)
 				{
 					printk(KERN_ERR "module %s: relocation overflow: %u\n",
 					me->name, relocation);
@@ -204,7 +204,7 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 			break;
 		case R_M32R_26_PCREL_RELA:
 	  		relocation = (relocation - (Elf32_Addr) location);
-			if (relocation < -0x2000000 || 0x1fffffc < relocation)
+			if (relocation > 0x1fffffc)
 				{
 					printk(KERN_ERR "module %s: relocation overflow: %u\n",
 					me->name, relocation);

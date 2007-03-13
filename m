Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbXCMGji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbXCMGji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 02:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbXCMGji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 02:39:38 -0400
Received: from ozlabs.org ([203.10.76.45]:33258 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbXCMGji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 02:39:38 -0400
Subject: [PATCH] Remove unused set_seg_base
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 17:38:42 +1100
Message-Id: <1173767922.10618.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The set_seg_base function isn't used anywhere (2.6.21-rc3-git1)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 0798f7cfc709 include/asm-x86_64/desc.h
--- a/include/asm-x86_64/desc.h	Mon Mar 12 16:56:18 2007 +1100
+++ b/include/asm-x86_64/desc.h	Tue Mar 13 11:39:16 2007 +1100
@@ -107,16 +107,6 @@ static inline void set_ldt_desc(unsigned
 			      DESC_LDT, size * 8 - 1);
 }
 
-static inline void set_seg_base(unsigned cpu, int entry, void *base)
-{ 
-	struct desc_struct *d = &cpu_gdt(cpu)[entry];
-	u32 addr = (u32)(u64)base;
-	BUG_ON((u64)base >> 32); 
-	d->base0 = addr & 0xffff;
-	d->base1 = (addr >> 16) & 0xff;
-	d->base2 = (addr >> 24) & 0xff;
-} 
-
 #define LDT_entry_a(info) \
 	((((info)->base_addr & 0x0000ffff) << 16) | ((info)->limit & 0x0ffff))
 /* Don't allow setting of the lm bit. It is useless anyways because 



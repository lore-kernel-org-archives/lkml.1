Return-Path: <linux-kernel-owner+w=401wt.eu-S1031909AbXD1Rzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031909AbXD1Rzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163310AbXD1RxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:53:21 -0400
Received: from ns.suse.de ([195.135.220.2]:34445 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163321AbXD1Rw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:59 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [32/35] x86_64: Remove unused set_seg_base
Message-Id: <20070428175258.1E765151D1@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>
The set_seg_base function isn't used anywhere (2.6.21-rc3-git1)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86_64/desc.h |   10 ----------
 1 file changed, 10 deletions(-)

Index: linux/include/asm-x86_64/desc.h
===================================================================
--- linux.orig/include/asm-x86_64/desc.h
+++ linux/include/asm-x86_64/desc.h
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

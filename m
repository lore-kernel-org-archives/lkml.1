Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbXCMGkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbXCMGkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 02:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbXCMGkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 02:40:35 -0400
Received: from ozlabs.org ([203.10.76.45]:33269 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbXCMGkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 02:40:35 -0400
Subject: [PATCH] Introduce load_TLS to the "for" loop.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 17:39:36 +1100
Message-Id: <1173767976.10618.50.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

GCC (4.1 at least) unrolls it anyway, but I can't believe this code
was ever justifiable.  (I've also submitted a patch which cleans up
i386, which is even uglier).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r de5618b5e562 include/asm-x86_64/desc.h
--- a/include/asm-x86_64/desc.h	Tue Mar 13 11:41:55 2007 +1100
+++ b/include/asm-x86_64/desc.h	Tue Mar 13 16:09:56 2007 +1100
@@ -135,16 +135,13 @@ static inline void set_ldt_desc(unsigned
 	(info)->useable		== 0	&& \
 	(info)->lm		== 0)
 
-#if TLS_SIZE != 24
-# error update this code.
-#endif
-
 static inline void load_TLS(struct thread_struct *t, unsigned int cpu)
 {
+	unsigned int i;
 	u64 *gdt = (u64 *)(cpu_gdt(cpu) + GDT_ENTRY_TLS_MIN);
-	gdt[0] = t->tls_array[0];
-	gdt[1] = t->tls_array[1];
-	gdt[2] = t->tls_array[2];
+
+	for (i = 0; i < GDT_ENTRY_TLS_ENTRIES; i++)
+		gdt[i] = t->tls_array[i];
 } 
 
 /*



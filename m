Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYGOFDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYGOFDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 01:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYGOFDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 01:03:38 -0400
Received: from ozlabs.org ([203.10.76.45]:38564 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbYGOFDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 01:03:37 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: fix asm/e820.h for userspace inclusion (again)
Date: Tue, 15 Jul 2008 15:02:27 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807151502.27734.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm-x86/e820.h is included from userspace.  'x86: make e820.c to have
common functions' (b79cd8f1268bab57ff85b19d131f7f23deab2dee) broke it:

	make -C Documentation/lguest
	cc -Wall -Wmissing-declarations -Wmissing-prototypes -O3 -I../../include    
lguest.c  -lz -o lguest
	In file included from ../../include/asm-x86/bootparam.h:8,
	                 from lguest.c:45:
	../../include/asm/e820.h:66: error: expected ‘)’ before ‘start’
	../../include/asm/e820.h:67: error: expected ‘)’ before ‘start’
	../../include/asm/e820.h:68: error: expected ‘)’ before ‘start’
	../../include/asm/e820.h:72: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ 
or ‘__attribute__’ before ‘e820_update_range’
	...

Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 0322ce52818b include/asm-x86/e820.h
--- a/include/asm-x86/e820.h	Tue Jul 15 12:46:05 2008 +1000
+++ b/include/asm-x86/e820.h	Tue Jul 15 14:57:55 2008 +1000
@@ -59,6 +59,7 @@ struct e820map {
 	struct e820entry map[E820_X_MAX];
 };
 
+#ifdef __KERNEL__
 /* see comment in arch/x86/kernel/e820.c */
 extern struct e820map e820;
 extern struct e820map e820_saved;
@@ -115,7 +116,7 @@ extern char *default_machine_specific_me
 extern char *default_machine_specific_memory_setup(void);
 extern char *machine_specific_memory_setup(void);
 extern char *memory_setup(void);
-
+#endif /* __KERNEL__ */
 #endif /* __ASSEMBLY__ */
 
 #define ISA_START_ADDRESS	0xa0000

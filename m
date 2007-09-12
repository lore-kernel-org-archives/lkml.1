Return-Path: <linux-kernel-owner+w=401wt.eu-S933177AbXILCEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177AbXILCEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 22:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXILCEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 22:04:43 -0400
Received: from ozlabs.org ([203.10.76.45]:45584 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbXILCEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 22:04:42 -0400
From: Michael Neuling <mikey@neuling.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       paulus@samba.org, Alan Cox <alan@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
X-GPG-Fingerprint: 9B25 DC2A C58D 2C8D 47C2  457E 0887 E86F 32E6 BE16
MIME-Version: 1.0
Subject: [PATCH] powerpc: add new required termio functions
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 21.4.1
Date: Wed, 12 Sep 2007 12:04:39 +1000
Message-ID: <8018.1189562679@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The "tty: termios locking functions break with new termios type" patch
(f629307c857c030d5a3dd777fee37c8bb395e171) breaks the powerpc compile.
This adds the required API to asm-powerpc.

Signed-off-by: Michael Neuling <mikey@neuling.org>
--
This needs to go up for 2.6.23.

Should we really put these definitions in asm-generic/termios.h as I'm
guessing other architectures are broken too?

coopers@include/ % git grep kernel_termios_to_user_termios_1
asm-arm/termios.h:#define kernel_termios_to_user_termios_1(u, k)
asm-cris/termios.h:#define kernel_termios_to_user_termios_1(u, k)
asm-h8300/termios.h:#define kernel_termios_to_user_termios_1(u, k)
asm-i386/termios.h:#define kernel_termios_to_user_termios_1(u, k)
asm-ia64/termios.h:#define kernel_termios_to_user_termios_1(u, k)
asm-m32r/termios.h:#define kernel_termios_to_user_termios_1(u, k)
asm-m68k/termios.h:#define kernel_termios_to_user_termios_1(u, k)
asm-mips/termios.h:#define kernel_termios_to_user_termios_1(u, k)
asm-v850/termios.h:#define kernel_termios_to_user_termios_1(u, k)
asm-x86_64/termios.h:#define kernel_termios_to_user_termios_1(u, k)

 include/asm-powerpc/termios.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6-ozlabs/include/asm-powerpc/termios.h
===================================================================
--- linux-2.6-ozlabs.orig/include/asm-powerpc/termios.h
+++ linux-2.6-ozlabs/include/asm-powerpc/termios.h
@@ -80,6 +80,9 @@ struct termio {
 
 #include <asm-generic/termios.h>
 
+#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
+#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
+
 #endif	/* __KERNEL__ */
 
 #endif	/* _ASM_POWERPC_TERMIOS_H */


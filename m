Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbYDXIg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbYDXIg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 04:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbYDXIgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 04:36:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:50775 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbYDXIgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 04:36:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=cJTzu5lBKleVyUSEfKEWJ+5aSCyz+Y5WEluszJdczSS0jzBwPiSrS0NtG9HqI5bfzbZcraqGr0qbtSBXiL/PuL0AwyP++xQhBTlWMhcQT1XKojEZZkKAwFUYTdQmhCNhzTnsLvreBGzVHPLEHEtbQJpgQO9GqPUKKWF5ARtKEZo=
Date: Thu, 24 Apr 2008 12:35:58 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: vm86 - hide X86_VM_MASK from userland programs
Message-ID: <20080424083558.GA7749@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X86_VM_MASK is a kernel specific flag so lets hide it from
userland programs

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/include/asm-x86/vm86.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/vm86.h	2008-04-23 22:38:58.000000000 +0400
+++ linux-2.6.git/include/asm-x86/vm86.h	2008-04-24 12:31:53.000000000 +0400
@@ -14,12 +14,16 @@
 
 #include <asm/processor-flags.h>
 
+#ifdef __KERNEL__
+
 #ifdef CONFIG_VM86
 #define X86_VM_MASK	X86_EFLAGS_VM
 #else
 #define X86_VM_MASK	0 /* No VM86 support */
 #endif
 
+#endif /* __KERNEL__ */
+
 #define BIOSSEG		0x0f000
 
 #define CPU_086		0

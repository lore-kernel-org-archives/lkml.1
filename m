Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbXKSWHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbXKSWHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbXKSWGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:06:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbXKSWGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:06:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 10/18] x86 vDSO: i386 vdso32 install
In-Reply-To: Roland McGrath's message of  Monday, 19 November 2007 13:59:43 -0800 <20071119215944.01B7C26F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
X-Windows: let it get in *your* way.
Message-Id: <20071119220556.1D72826F8BE@magilla.localdomain>
Date: Mon, 19 Nov 2007 14:05:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This enables 'make vdso_install' for i386 as on x86_64 and powerpc.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/Makefile_32 |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Makefile_32 b/arch/x86/Makefile_32
index 99dc511..4c869ef 100644
--- a/arch/x86/Makefile_32
+++ b/arch/x86/Makefile_32
@@ -153,9 +153,13 @@ zdisk bzdisk: vmlinux
 fdimage fdimage144 fdimage288 isoimage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) $@
 
-install:
+install: vdso_install
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
 
+PHONY += vdso_install
+vdso_install:
+	$(Q)$(MAKE) $(build)=arch/x86/vdso $@
+
 archclean:
 	$(Q)rm -rf $(objtree)/arch/i386/boot
 	$(Q)$(MAKE) $(clean)=arch/x86/boot

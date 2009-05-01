Return-Path: <linux-kernel-owner+w=401wt.eu-S1760024AbZEAAPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024AbZEAAPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765176AbZEAACl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:02:41 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61822 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763550AbZEAACk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:02:40 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 11/11] x86: convert to new generic read_mostly support.
Date: Thu, 30 Apr 2009 20:01:38 -0400
Message-Id: <1241136098-10376-12-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136098-10376-11-git-send-email-tabbott@mit.edu>
References: <1241136098-10376-1-git-send-email-tabbott@mit.edu>
 <1241136098-10376-2-git-send-email-tabbott@mit.edu>
 <1241136098-10376-3-git-send-email-tabbott@mit.edu>
 <1241136098-10376-4-git-send-email-tabbott@mit.edu>
 <1241136098-10376-5-git-send-email-tabbott@mit.edu>
 <1241136098-10376-6-git-send-email-tabbott@mit.edu>
 <1241136098-10376-7-git-send-email-tabbott@mit.edu>
 <1241136098-10376-8-git-send-email-tabbott@mit.edu>
 <1241136098-10376-9-git-send-email-tabbott@mit.edu>
 <1241136098-10376-10-git-send-email-tabbott@mit.edu>
 <1241136098-10376-11-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/Kconfig             |    3 +++
 arch/x86/include/asm/cache.h |    2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bfff845..f12d0db 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -52,6 +52,9 @@ config OUTPUT_FORMAT
 	default "elf32-i386" if X86_32
 	default "elf64-x86-64" if X86_64
 
+config HAVE_READ_MOSTLY_DATA
+       def_bool y
+
 config ARCH_DEFCONFIG
 	string
 	default "arch/x86/configs/i386_defconfig" if X86_32
diff --git a/arch/x86/include/asm/cache.h b/arch/x86/include/asm/cache.h
index 5d367ca..16c1e65 100644
--- a/arch/x86/include/asm/cache.h
+++ b/arch/x86/include/asm/cache.h
@@ -5,8 +5,6 @@
 #define L1_CACHE_SHIFT	(CONFIG_X86_L1_CACHE_SHIFT)
 #define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
-
 #ifdef CONFIG_X86_VSMP
 /* vSMP Internode cacheline shift */
 #define INTERNODE_CACHE_SHIFT (12)
-- 
1.6.2.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S932341AbZEAA2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbZEAA2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765587AbZEAAGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:06:36 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62465 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765608AbZEAAGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:06:35 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 8/8] powerpc: convert to new generic read_mostly support.
Date: Thu, 30 Apr 2009 19:56:17 -0400
Message-Id: <1241135777-9462-9-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135777-9462-8-git-send-email-tabbott@mit.edu>
References: <1241135777-9462-1-git-send-email-tabbott@mit.edu>
 <1241135777-9462-2-git-send-email-tabbott@mit.edu>
 <1241135777-9462-3-git-send-email-tabbott@mit.edu>
 <1241135777-9462-4-git-send-email-tabbott@mit.edu>
 <1241135777-9462-5-git-send-email-tabbott@mit.edu>
 <1241135777-9462-6-git-send-email-tabbott@mit.edu>
 <1241135777-9462-7-git-send-email-tabbott@mit.edu>
 <1241135777-9462-8-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
---
 arch/powerpc/Kconfig             |    3 +++
 arch/powerpc/include/asm/cache.h |    4 ----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 4c78045..d29ea59 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -32,6 +32,9 @@ config GENERIC_CMOS_UPDATE
 config GENERIC_TIME
 	def_bool y
 
+config HAVE_READ_MOSTLY_DATA
+	def_bool y
+
 config GENERIC_TIME_VSYSCALL
 	def_bool y
 
diff --git a/arch/powerpc/include/asm/cache.h b/arch/powerpc/include/asm/cache.h
index 81de6eb..1843a11 100644
--- a/arch/powerpc/include/asm/cache.h
+++ b/arch/powerpc/include/asm/cache.h
@@ -37,9 +37,5 @@ struct ppc64_caches {
 extern struct ppc64_caches ppc64_caches;
 #endif /* __powerpc64__ && ! __ASSEMBLY__ */
 
-#if !defined(__ASSEMBLY__)
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
-#endif
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_CACHE_H */
-- 
1.6.2.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZFDMmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZFDMmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbZFDMlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:41:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:38698 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbZFDMlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:41:39 -0400
Subject: [PATCH 1/6] headers_check fix: arm, hwcap.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Russell King <rmk+lkml@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <1244118232.5172.26.camel@ht.satnam>
References: <1244118232.5172.26.camel@ht.satnam>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 17:57:56 +0530
Message-Id: <1244118476.5172.29.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix the following 'make headers_check' warning:

  usr/include/asm-arm/hwcap.h:29: extern's make no sense in userspace

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/arm/include/asm/hwcap.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/hwcap.h b/arch/arm/include/asm/hwcap.h
index f7bd52b..48b4501 100644
--- a/arch/arm/include/asm/hwcap.h
+++ b/arch/arm/include/asm/hwcap.h
@@ -20,7 +20,8 @@
 #define HWCAP_VFPv3	8192
 #define HWCAP_VFPv3D16	16384
 
-#if defined(__KERNEL__) && !defined(__ASSEMBLY__)
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
 /*
  * This yields a mask that user programs can use to figure out what
  * instruction set this cpu supports.
@@ -28,5 +29,5 @@
 #define ELF_HWCAP	(elf_hwcap)
 extern unsigned int elf_hwcap;
 #endif
-
+#endif
 #endif
-- 
1.6.0.6




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934675Ab0BZAAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:00:22 -0500
Received: from mga05.intel.com ([192.55.52.89]:54337 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934633Ab0BZAAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:00:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,542,1262592000"; 
   d="scan'208";a="776028997"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] x86/mrst: add kconfig dependencies for Moorestown
Date: Thu, 25 Feb 2010 09:53:04 -0800
Message-Id: <1267120384-25891-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moorestown platform has IOAPIC and PCI bus, even though both of them are
emulated partially by FW. Moorestown depends on PCI MMCONFIG and DIRECT
method to perform device enumeration. IOAPIC is needed to manage
all interrupts coming from the south complex.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f032294..2697fdb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -388,8 +388,12 @@ config X86_ELAN
 
 config X86_MRST
        bool "Moorestown MID platform"
+	depends on PCI
+	depends on PCI_GOANY
+	depends on PCI_IOAPIC
 	depends on X86_32
 	depends on X86_EXTENDED_PLATFORM
+	depends on X86_IO_APIC
 	select APB_TIMER
 	---help---
 	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
-- 
1.5.6.5


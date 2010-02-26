Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934746Ab0BZATH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:19:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:50654 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934672Ab0BZATC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:19:02 -0500
Date: Fri, 26 Feb 2010 00:18:37 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, jacob.jun.pan@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jacob.jun.pan@linux.intel.com
In-Reply-To: <1267120934-9505-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1267120934-9505-1-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, mrst: Add Kconfig dependencies for Moorestown
Message-ID: <tip-4b2f3f7d0fe97ad312fb572c8f8d88836ae8fb1e@git.kernel.org>
Git-Commit-ID: 4b2f3f7d0fe97ad312fb572c8f8d88836ae8fb1e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 00:18:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b2f3f7d0fe97ad312fb572c8f8d88836ae8fb1e
Gitweb:     http://git.kernel.org/tip/4b2f3f7d0fe97ad312fb572c8f8d88836ae8fb1e
Author:     Jacob Pan <jacob.jun.pan@linux.intel.com>
AuthorDate: Thu, 25 Feb 2010 10:02:14 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 25 Feb 2010 16:16:26 -0800

x86, mrst: Add Kconfig dependencies for Moorestown

The Moorestown platform requires IOAPIC for all interrupts from the
south complex, since there is no legacy PIC.

Furthermore, Moorestown I/O requires PCI.  Moorestown PCI depends on PCI MMCONFIG
and DIRECT method to perform device enumeration, as there is no PCI BIOS.

[ hpa: rewrote commit message ]

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
LKML-Reference: <1267120934-9505-1-git-send-email-jacob.jun.pan@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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

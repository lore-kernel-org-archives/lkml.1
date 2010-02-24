Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0BXIIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:08:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:58640 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566Ab0BXIIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:08:18 -0500
Date: Wed, 24 Feb 2010 08:07:19 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F0755A318DA07@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F0755A318DA07@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, ioapic: Add dummy ioapic functions
Message-ID: <tip-4966e1affb45c5fc402969e10e979407b972a7df@git.kernel.org>
Git-Commit-ID: 4966e1affb45c5fc402969e10e979407b972a7df
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Feb 2010 08:07:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4966e1affb45c5fc402969e10e979407b972a7df
Gitweb:     http://git.kernel.org/tip/4966e1affb45c5fc402969e10e979407b972a7df
Author:     Jacob Pan <jacob.jun.pan@intel.com>
AuthorDate: Tue, 23 Feb 2010 10:43:58 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 23 Feb 2010 23:14:07 -0800

x86, ioapic: Add dummy ioapic functions

Some ioapic extern functions are used when CONFIG_X86_IO_APIC is not
defined.  We need the dummy functions to avoid a compile time error.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
LKML-Reference: <43F901BD926A4E43B106BF17856F0755A318DA07@orsmsx508.amr.corp.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/io_apic.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 99a416e..35832a0 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -197,7 +197,11 @@ static const int timer_through_8259 = 0;
 static inline void ioapic_init_mappings(void)	{ }
 static inline void ioapic_insert_resources(void) { }
 static inline void probe_nr_irqs_gsi(void)	{ }
+static inline int mp_find_ioapic(int gsi) { return 0; }
 
+struct io_apic_irq_attr;
+static inline int io_apic_set_pci_routing(struct device *dev, int irq,
+		 struct io_apic_irq_attr *irq_attr) { return 0; }
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */

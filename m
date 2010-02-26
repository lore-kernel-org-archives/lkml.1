Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935238Ab0BZEqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 23:46:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:42402 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935190Ab0BZEqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 23:46:06 -0500
Date: Fri, 26 Feb 2010 04:45:42 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbarnes@virtuousgeek.org, jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F0755A318CE84@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F0755A318CE84@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, pci: Add arch_init to x86_init abstraction
Message-ID: <tip-4fb6088a5cb3a77123fea1279bf2d5b16cf27648@git.kernel.org>
Git-Commit-ID: 4fb6088a5cb3a77123fea1279bf2d5b16cf27648
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 04:45:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4fb6088a5cb3a77123fea1279bf2d5b16cf27648
Gitweb:     http://git.kernel.org/tip/4fb6088a5cb3a77123fea1279bf2d5b16cf27648
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 22 Feb 2010 05:38:38 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 25 Feb 2010 19:24:43 -0800

x86, pci: Add arch_init to x86_init abstraction

Added an abstraction function for arch specific init calls.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
LKML-Reference: <43F901BD926A4E43B106BF17856F0755A318CE84@orsmsx508.amr.corp.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/x86_init.h |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 8ef56f2..b1d62bb 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -98,13 +98,15 @@ struct x86_init_iommu {
 	int (*iommu_init)(void);
 };
 
- /*
-  * struct x86_init_pci - platform specific pci init functions
- * @init:			platform specific pci init
+/**
+ * struct x86_init_pci - platform specific pci init functions
+ * @arch_init:			platform specific pci arch init call
+ * @init:			platform specific pci subsystem init
  * @init_irq:			platform specific pci irq init
  * @fixup_irqs:			platform specific pci irq fixup
  */
 struct x86_init_pci {
+	int (*arch_init)(void);
 	int (*init)(void);
 	void (*init_irq)(void);
 	void (*fixup_irqs)(void);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbZCETN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbZCETN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZCETNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:13:14 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:64005 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbZCETNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:13:12 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH v2 01/15] NULL noise: arch/x86/kernel
Date: Thu, 05 Mar 2009 20:12:47 +0100
Message-ID: <20090305191231.30062.95084.stgit@f10box.hanneseder.net>
In-Reply-To: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: trivial@kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:
  arch/x86/kernel/io_apic.c:3474:37: warning: Using plain integer as NULL pointer
  arch/x86/kernel/machine_kexec_32.c:124:22: warning: Using plain integer as NULL pointer
  arch/x86/kernel/traps.c:950:24: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
v2: other subject, as suggested by Al Viro

 arch/x86/kernel/io_apic.c          |    2 +-
 arch/x86/kernel/machine_kexec_32.c |    2 +-
 arch/x86/kernel/traps.c            |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index a89878e..d9fe0ed 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -3471,7 +3471,7 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	unsigned int irq_want;
 
 #ifdef CONFIG_INTR_REMAP
-	struct intel_iommu *iommu = 0;
+	struct intel_iommu *iommu = NULL;
 	int index = 0;
 #endif
 
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index 37f4200..f5fc8c7 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -121,7 +121,7 @@ static void machine_kexec_page_table_set_one(
 static void machine_kexec_prepare_page_tables(struct kimage *image)
 {
 	void *control_page;
-	pmd_t *pmd = 0;
+	pmd_t *pmd = NULL;
 
 	control_page = page_address(image->control_code_page);
 #ifdef CONFIG_X86_PAE
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ba90406..6882089 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -947,7 +947,7 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 	info.si_signo = SIGILL;
 	info.si_errno = 0;
 	info.si_code = ILL_BADSTK;
-	info.si_addr = 0;
+	info.si_addr = NULL;
 	if (notify_die(DIE_TRAP, "iret exception",
 			regs, error_code, 32, SIGILL) == NOTIFY_STOP)
 		return;


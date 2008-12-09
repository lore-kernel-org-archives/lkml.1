Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYLIT5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYLIT5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 14:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbYLIT5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 14:57:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:2668 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbYLIT5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 14:57:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mSBx1SC9y1uA74P6nTArsqjOBg0S3/0IIrx4fVJBYTd55OnqXlkyFksfg1F6lIJhQS
         4r1Q+OAoPXPh4RX+PGHiohxbNCJUqxhLvsUPG9cNJoyIJM5QtVT5RjDceMQCpdykzgdu
         tV99CqmRYJz4bEmL3s8UBPifLRoLGKVsSZAO0=
Message-ID: <493ECDB5.9000602@gmail.com>
Date: Tue, 09 Dec 2008 20:57:41 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: mingo@redhat.com
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/33 V2] x86: Make static
References: <493EA286.7080500@gmail.com> <493EA3BE.4050206@gmail.com>
In-Reply-To: <493EA3BE.4050206@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/x86/kernel/hpet.c            |    2 +-
 arch/x86/kernel/io_apic.c         |    2 +-
 arch/x86/kernel/microcode_core.c  |    4 ++--
 arch/x86/kernel/microcode_intel.c |    2 +-
 arch/x86/kernel/setup.c           |    3 ++-
 arch/x86/kvm/vmx.c                |    2 +-
 arch/x86/pci/legacy.c             |    2 +-
 7 files changed, 9 insertions(+), 8 deletions(-)

please ignore previous patch (add_efi_memmap was exported)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 067d8de..15fcaac 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -33,7 +33,7 @@
  * HPET address is set in acpi/boot.c, when an ACPI entry exists
  */
 unsigned long				hpet_address;
-unsigned long				hpet_num_timers;
+static unsigned long			hpet_num_timers;
 static void __iomem			*hpet_virt_address;
 
 struct hpet_dev {
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 9043251..dd6371f 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -3401,7 +3401,7 @@ static void hpet_msi_set_affinity(unsigned int irq, cpumask_t mask)
 }
 #endif /* CONFIG_SMP */
 
-struct irq_chip hpet_msi_type = {
+static struct irq_chip hpet_msi_type = {
 	.name = "HPET_MSI",
 	.unmask = hpet_msi_unmask,
 	.mask = hpet_msi_mask,
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 82fb280..97af1ec 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -203,7 +203,7 @@ MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
 #endif
 
 /* fake device for request_firmware */
-struct platform_device *microcode_pdev;
+static struct platform_device *microcode_pdev;
 
 static ssize_t reload_store(struct sys_device *dev,
 			    struct sysdev_attribute *attr,
@@ -319,7 +319,7 @@ static int microcode_resume_cpu(int cpu)
 	return 0;
 }
 
-void microcode_update_cpu(int cpu)
+static void microcode_update_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	int err = 0;
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 622dc4a..c34c820 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -465,7 +465,7 @@ static void microcode_fini_cpu(int cpu)
 	uci->mc = NULL;
 }
 
-struct microcode_ops microcode_intel_ops = {
+static struct microcode_ops microcode_intel_ops = {
 	.request_microcode_user		  = request_microcode_user,
 	.request_microcode_fw             = request_microcode_fw,
 	.collect_cpu_info                 = collect_cpu_info,
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9d5674f..efc5cfe 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -448,7 +448,8 @@ static void __init reserve_early_setup_data(void)
  * @size: Size of the crashkernel memory to reserve.
  * Returns the base address on success, and -1ULL on failure.
  */
-unsigned long long __init find_and_reserve_crashkernel(unsigned long long size)
+static unsigned long long __init find_and_reserve_crashkernel(
+		unsigned long long size)
 {
 	const unsigned long long alignment = 16<<20; 	/* 16M */
 	unsigned long long start = 0LL;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a4018b0..bd7d441 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -122,7 +122,7 @@ static struct vmcs_config {
 	u32 vmentry_ctrl;
 } vmcs_config;
 
-struct vmx_capability {
+static struct vmx_capability {
 	u32 ept;
 	u32 vpid;
 } vmx_capability;
diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index b722dd4..abe0f58 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -55,7 +55,7 @@ static int __init pci_legacy_init(void)
 	return 0;
 }
 
-int __init pci_subsys_init(void)
+static int __init pci_subsys_init(void)
 {
 #ifdef CONFIG_X86_NUMAQ
 	pci_numaq_init();

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbZDPVzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbZDPVzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 17:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZDPVzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 17:55:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:49473 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbZDPVzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 17:55:37 -0400
Subject: [git-pull -tip] x86: fix section mismatch warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 03:25:02 +0530
Message-Id: <1239918902.10567.22.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 88dc4c8e38d64db32907e0bd605f8c1ec4c4d1bd:
  Ingo Molnar (1):
        Merge branch 'tracing/ftrace'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master

Jaswinder Singh Rajput (3):
      x86: mm/numa_32.c calculate_numa_remap_pages should use __init
      x86: apic/es7000_32.c find_unisys_acpi_oem_table and es7000_acpi_madt_oem_check should use __init
      x86: smpboot.c wakeup_secondary_cpu_via_nmi do not required __devinit

 arch/x86/kernel/apic/es7000_32.c |    6 +++---
 arch/x86/kernel/smpboot.c        |    3 +--
 arch/x86/mm/numa_32.c            |    2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

Complete diff:
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 1c11b81..a7a7bbe 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -254,7 +254,7 @@ static int parse_unisys_oem(char *oemptr)
 }
 
 #ifdef CONFIG_ACPI
-static int find_unisys_acpi_oem_table(unsigned long *oem_addr)
+static int __init find_unisys_acpi_oem_table(unsigned long *oem_addr)
 {
 	struct acpi_table_header *header = NULL;
 	struct es7000_oem_table *table;
@@ -306,7 +306,7 @@ static int es7000_check_dsdt(void)
 static int es7000_acpi_ret;
 
 /* Hook from generic ACPI tables.c */
-static int es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int __init es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	unsigned long oem_addr = 0;
 	int check_dsdt;
@@ -717,7 +717,7 @@ struct apic apic_es7000_cluster = {
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 };
 
-struct apic apic_es7000 = {
+struct apic __initdata apic_es7000 = {
 
 	.name				= "es7000",
 	.probe				= probe_es7000,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index bf8ad63..483c2d3 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -504,8 +504,7 @@ void __inquire_remote_apic(int apicid)
  * INIT, INIT, STARTUP sequence will reset the chip hard for us, and this
  * won't ... remember to clear down the APIC, etc later.
  */
-int __devinit
-wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
+int wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
 	int maxlvt;
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 3daefa0..d253006 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -257,7 +257,7 @@ void resume_map_numa_kva(pgd_t *pgd_base)
 }
 #endif
 
-static unsigned long calculate_numa_remap_pages(void)
+static __init unsigned long calculate_numa_remap_pages(void)
 {
 	int nid;
 	unsigned long size, reserve_pages = 0;



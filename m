Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbZKQWLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbZKQWLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738AbZKQWLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:11:15 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:3987 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbZKQWLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:11:14 -0500
Subject: [PATCH 1/3] [CPUFREQ] make ACPI P-state cpufreq drivers depend on
	CONFIG_CPU_FREQ
To: davej@redhat.com
From: Alex Chiang <achiang@hp.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Date: Tue, 17 Nov 2009 15:11:20 -0700
Message-ID: <20091117221120.25933.46929.stgit@bob.kio>
In-Reply-To: <20091117220729.25933.57884.stgit@bob.kio>
References: <20091117220729.25933.57884.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In menuconfig, if you do not select:

Power management and ACPI options ->
  CPU Frequency scaling -->
    CPU Frequency scaling

You do not get a chance to select the various CPUFreq processor drivers
either.

So, it seems reasonable to make these processor drivers:

	- powernow-k8
	- powernow-k7
	- acpi-cpufreq

depend upon CONFIG_CPU_FREQ. This change allows us to be smarter with
#ifdefs and symbols in generic ACPI header files later on.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 arch/x86/kernel/cpu/cpufreq/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/Kconfig b/arch/x86/kernel/cpu/cpufreq/Kconfig
index f138c6c..ca40a9f 100644
--- a/arch/x86/kernel/cpu/cpufreq/Kconfig
+++ b/arch/x86/kernel/cpu/cpufreq/Kconfig
@@ -13,7 +13,7 @@ comment "CPUFreq processor drivers"
 config X86_ACPI_CPUFREQ
 	tristate "ACPI Processor P-States driver"
 	select CPU_FREQ_TABLE
-	depends on ACPI_PROCESSOR
+	depends on ACPI_PROCESSOR && CPU_FREQ
 	help
 	  This driver adds a CPUFreq driver which utilizes the ACPI
 	  Processor Performance States.
@@ -69,7 +69,7 @@ config X86_POWERNOW_K6
 config X86_POWERNOW_K7
 	tristate "AMD Mobile Athlon/Duron PowerNow!"
 	select CPU_FREQ_TABLE
-	depends on X86_32
+	depends on X86_32 && CPU_FREQ
 	help
 	  This adds the CPUFreq driver for mobile AMD K7 mobile processors.
 
@@ -87,7 +87,7 @@ config X86_POWERNOW_K7_ACPI
 config X86_POWERNOW_K8
 	tristate "AMD Opteron/Athlon64 PowerNow!"
 	select CPU_FREQ_TABLE
-	depends on ACPI && ACPI_PROCESSOR
+	depends on ACPI && ACPI_PROCESSOR && CPU_FREQ
 	help
 	  This adds the CPUFreq driver for K8/K10 Opteron/Athlon64 processors.
 


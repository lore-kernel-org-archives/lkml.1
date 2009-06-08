Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbZFHKaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbZFHKaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 06:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbZFHK3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 06:29:54 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:46191 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbZFHK3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 06:29:54 -0400
Date: Mon, 8 Jun 2009 18:29:36 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: [PATCH 2/2] CPUFREQ: Mark e_powersaver driver as EXPERIMENTAL and
	DANGEROUS
Message-ID: <20090608102936.GQ4106@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The e_powersaver driver for VIA's C7 CPU's needs to be marked as
DANGEROUS as it configures the CPU to power states that are out
of specification.

According to Centaur, all systems with C7 and Nano CPU's support
the ACPI p-state method.  Thus, the acpi-cpufreq driver should
be used instead.

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
---
 arch/x86/kernel/cpu/cpufreq/Kconfig |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/Kconfig b/arch/x86/kernel/cpu/cpufreq/Kconfig
index 52c8398..f138c6c 100644
--- a/arch/x86/kernel/cpu/cpufreq/Kconfig
+++ b/arch/x86/kernel/cpu/cpufreq/Kconfig
@@ -220,11 +220,14 @@ config X86_LONGHAUL
 	  If in doubt, say N.
 
 config X86_E_POWERSAVER
-	tristate "VIA C7 Enhanced PowerSaver"
+	tristate "VIA C7 Enhanced PowerSaver (DANGEROUS)"
 	select CPU_FREQ_TABLE
-	depends on X86_32
+	depends on X86_32 && EXPERIMENTAL
 	help
-	  This adds the CPUFreq driver for VIA C7 processors.
+	  This adds the CPUFreq driver for VIA C7 processors.  However, this driver
+	  does not have any safeguards to prevent operating the CPU out of spec
+	  and is thus considered dangerous.  Please use the regular ACPI cpufreq
+	  driver, enabled by CONFIG_X86_ACPI_CPUFREQ.
 
 	  If in doubt, say N.
 
-- 
1.6.2.4


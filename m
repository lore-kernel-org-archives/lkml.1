Return-Path: <linux-kernel-owner+w=401wt.eu-S1761414AbXEPBLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761414AbXEPBLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 21:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760005AbXEPBLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 21:11:48 -0400
Received: from moa.IfA.Hawaii.Edu ([128.171.168.48]:36117 "EHLO
	moa.ifa.hawaii.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759675AbXEPBLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 21:11:47 -0400
Date: Tue, 15 May 2007 15:17:11 -1000
From: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
To: LKML <linux-kernel@vger.kernel.org>
Cc: trivial@kernel.org
Subject: [PATCH] Kconfig powernow-k8 driver should depend on ACPI P-States driver
Message-ID: <20070516011711.GE15763@ifa.hawaii.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Below is a one line patch to possibly fix this bug:

http://bugs.gentoo.org/show_bug.cgi?id=178585
http://bugzilla.kernel.org/show_bug.cgi?id=8075

If the kernel is configured with:

CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_ACPI_CPUFREQ=m

Which is currently an allowed configuration, the powernow-k8 driver on
an SMP system will fail with a warning like:

powernow-k8: Found 4 Dual Core AMD Opteron(tm) Processor 285 processors (version 2.00.00)
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure

Which mimics that failure you get when powernow/cool'n'quiet is disabled
in the BIOS.  I don't know if this config combination is valid on a
uniprocessor system so this dependency may need to be enforced only if
SMP in enabled.  The other powernow-* drivers likely have the same
requirements as -k8 but I am unable to test them.

Signed-off-by: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
--
 Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.21.1.orig/arch/i386/kernel/cpu/cpufreq/Kconfig    2007-04-27 11:49:26.000000000 -1000
+++ linux-2.6.21.1/arch/i386/kernel/cpu/cpufreq/Kconfig 2007-05-15 14:48:50.000000000 -1000
@@ -82,6 +82,7 @@ config X86_POWERNOW_K8
        tristate "AMD Opteron/Athlon64 PowerNow!"
        select CPU_FREQ_TABLE
        depends on EXPERIMENTAL
+       depends on X86_ACPI_CPUFREQ
        help
          This adds the CPUFreq driver for mobile AMD Opteron/Athlon64 processors.


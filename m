Return-Path: <linux-kernel-owner+w=401wt.eu-S1762137AbXEPX4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762137AbXEPX4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbXEPX4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:56:09 -0400
Received: from queueout03-winn.ispmail.ntl.com ([81.103.221.33]:61294 "EHLO
	queueout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755714AbXEPX4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:56:08 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 May 2007 19:56:08 EDT
From: Daniel Drake <dsd@gentoo.org>
To: davej@redhat.com
Cc: duaneg@dghda.com
Cc: prakash@punnoor.de
Cc: jhoblitt@ifa.hawaii.edu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] powernow-k8: depend on acpi-processor for SMP systems
Message-Id: <20070516235050.9B4237B409F@zog.reactivated.net>
Date: Thu, 17 May 2007 00:50:50 +0100 (BST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

powernow-k8 uses PSB BIOS tables to read frequency info on UP systems, but
on SMP it requires the acpi-processor driver. Kconfig should be updated
accordingly to avoid the issues that users are running into.

http://bugzilla.kernel.org/show_bug.cgi?id=8075
https://bugs.gentoo.org/show_bug.cgi?id=178585

Signed-off-by: Daniel Drake <dsd@gentoo.org>

Index: linux/arch/i386/kernel/cpu/cpufreq/Kconfig
===================================================================
--- linux.orig/arch/i386/kernel/cpu/cpufreq/Kconfig
+++ linux/arch/i386/kernel/cpu/cpufreq/Kconfig
@@ -81,6 +81,7 @@ config X86_POWERNOW_K7_ACPI
 config X86_POWERNOW_K8
 	tristate "AMD Opteron/Athlon64 PowerNow!"
 	select CPU_FREQ_TABLE
+	select ACPI_PROCESSOR if SMP
 	depends on EXPERIMENTAL
 	help
 	  This adds the CPUFreq driver for mobile AMD Opteron/Athlon64 processors.

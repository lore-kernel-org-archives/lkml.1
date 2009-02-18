Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZBRS2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZBRS2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZBRS21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:28:27 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35409 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZBRS21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:28:27 -0500
Date: Wed, 18 Feb 2009 18:28:22 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: davej@codemonkey.org.uk
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: [PATCH] cpufreq: Change link order of x86 cpufreq modules
Message-ID: <20090218182822.GA19902@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the link order of the cpufreq modules to ensure that they're 
probed in the preferred order when statically linked in.
    
Signed-off-by: Matthew Garrett <mjg@redhat.com>

diff --git a/arch/x86/kernel/cpu/cpufreq/Makefile b/arch/x86/kernel/cpu/cpufreq/Makefile
index 560f776..509296d 100644
--- a/arch/x86/kernel/cpu/cpufreq/Makefile
+++ b/arch/x86/kernel/cpu/cpufreq/Makefile
@@ -1,6 +1,11 @@
+# Link order matters. K8 is preferred to ACPI because of firmware bugs in early
+# K8 systems. ACPI is preferred to all other hardware-specific drivers.
+# speedstep-* is preferred over p4-clockmod.
+
+obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o
+obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o
 obj-$(CONFIG_X86_POWERNOW_K6)		+= powernow-k6.o
 obj-$(CONFIG_X86_POWERNOW_K7)		+= powernow-k7.o
-obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o
 obj-$(CONFIG_X86_LONGHAUL)		+= longhaul.o
 obj-$(CONFIG_X86_E_POWERSAVER)		+= e_powersaver.o
 obj-$(CONFIG_ELAN_CPUFREQ)		+= elanfreq.o
@@ -10,7 +15,6 @@ obj-$(CONFIG_X86_GX_SUSPMOD)		+= gx-suspmod.o
 obj-$(CONFIG_X86_SPEEDSTEP_ICH)		+= speedstep-ich.o
 obj-$(CONFIG_X86_SPEEDSTEP_LIB)		+= speedstep-lib.o
 obj-$(CONFIG_X86_SPEEDSTEP_SMI)		+= speedstep-smi.o
-obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o
 obj-$(CONFIG_X86_SPEEDSTEP_CENTRINO)	+= speedstep-centrino.o
 obj-$(CONFIG_X86_P4_CLOCKMOD)		+= p4-clockmod.o
 obj-$(CONFIG_X86_CPUFREQ_NFORCE2)	+= cpufreq-nforce2.o
-- 
Matthew Garrett | mjg59@srcf.ucam.org

Return-Path: <linux-kernel-owner+w=401wt.eu-S934587AbXGTISd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934587AbXGTISd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 04:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762149AbXGTISQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 04:18:16 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39169 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762630AbXGTISO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 04:18:14 -0400
Date: Fri, 20 Jul 2007 10:17:36 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Alexey Dobriyan <adobriyan@sw.ru>,
       Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>, Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, cpufreq@lists.linux.org.uk,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: [2.6.23 regression fix] X86_POWERNOW_K8_ACPI must depend on ACPI
Message-ID: <20070720081736.GV3801@stusta.de>
References: <20070719085641.GA11064@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070719085641.GA11064@localhost.sw.ru>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error introduced by
commit e8666b2718fdb5bf0ea7c3126f7e292bbbf2946b and reported
by Alexey Dobriyan:

<--  snip  -->

   CC      arch/i386/kernel/acpi/cstate.o
In file included from arch/i386/kernel/acpi/cstate.c:17:
include/acpi/processor.h:88: error: expected specifier-qualifier-list before 'acpi_integer'

<--  snip  -->

If you select something you must ensure that the dependencies of what 
you are selecting are fulfilled.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/arch/i386/kernel/cpu/cpufreq/Kconfig.old	2007-07-19 15:06:47.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/i386/kernel/cpu/cpufreq/Kconfig	2007-07-19 15:07:07.000000000 +0200
@@ -92,7 +92,7 @@
 config X86_POWERNOW_K8_ACPI
 	bool "ACPI Support"
 	select ACPI_PROCESSOR
-	depends on X86_POWERNOW_K8
+	depends on ACPI && X86_POWERNOW_K8
 	default y
 	help
 	  This provides access to the K8s Processor Performance States via ACPI.


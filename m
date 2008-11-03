Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbYKCTTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbYKCTTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYKCTSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:18:51 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:52826 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753815AbYKCTSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:18:49 -0500
Subject: [PATCH] x86: Don't use tsc_khz to calculate lpj if notsc is passed.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 03 Nov 2008 11:18:47 -0800
Message-Id: <1225739927.8168.34.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: Don't use tsc_khz to calculate lpj if notsc is passed.

From: Alok N Kataria <akataria@vmware.com>

With notsc passed on commandline, tsc may not be used for
udelays, make sure that we do not use tsc_khz to calculate
the lpj value in such cases.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: stable@kernel.org

---

 arch/x86/kernel/tsc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index ee01cd9..8904571 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -829,10 +829,6 @@ void __init tsc_init(void)
 		cpu_khz = calibrate_cpu();
 #endif
 
-	lpj = ((u64)tsc_khz * 1000);
-	do_div(lpj, HZ);
-	lpj_fine = lpj;
-
 	printk("Detected %lu.%03lu MHz processor.\n",
 			(unsigned long)cpu_khz / 1000,
 			(unsigned long)cpu_khz % 1000);
@@ -852,6 +848,10 @@ void __init tsc_init(void)
 	/* now allow native_sched_clock() to use rdtsc */
 	tsc_disabled = 0;
 
+	lpj = ((u64)tsc_khz * 1000);
+	do_div(lpj, HZ);
+	lpj_fine = lpj;
+	
 	use_tsc_delay();
 	/* Check and install the TSC clocksource */
 	dmi_check_system(bad_tsc_dmi_table);



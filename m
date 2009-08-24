Return-Path: <linux-kernel-owner+w=401wt.eu-S1751110AbZHXBIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110AbZHXBIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 21:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbZHXBIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 21:08:22 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:47702 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbZHXBIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 21:08:21 -0400
Subject: [PATCH: x86] Print the hypervisor returned tsc_khz during boot.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Sun, 23 Aug 2009 18:08:23 -0700
Message-Id: <1251076103.29422.32.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an AMD-64 system the processor frequency that is printed during
system boot, may be different than the tsc frequency that was returned
by the hypervisor, due to value returned from calibrate_cpu. For
debugging timekeeping or other related issues it might be better to get
the tsc_khz value returned by the hypervisor.

The patch below now prints the tsc frequency that the hypervisor
returned. Please consider for tip.

--
Signed-off-by: Alok N Kataria <akataria@vmware.com>

Index: linux-tip-master/arch/x86/kernel/tsc.c
===================================================================
--- linux-tip-master.orig/arch/x86/kernel/tsc.c	2009-08-23 17:53:44.000000000 -0700
+++ linux-tip-master/arch/x86/kernel/tsc.c	2009-08-23 17:55:08.000000000 -0700
@@ -405,7 +405,10 @@ unsigned long native_calibrate_tsc(void)
 
 	hv_tsc_khz = get_hypervisor_tsc_freq();
 	if (hv_tsc_khz) {
-		printk(KERN_INFO "TSC: Frequency read from the hypervisor\n");
+		printk(KERN_INFO "TSC: Frequency read from the hypervisor : "
+				"%lu.%03lu MHz\n",
+				(unsigned long) hv_tsc_khz / 1000,
+				(unsigned long) hv_tsc_khz % 1000);
 		return hv_tsc_khz;
 	}
 


 



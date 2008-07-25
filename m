Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbYGYCGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbYGYCGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 22:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYGYCGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 22:06:13 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:32845 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbYGYCGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 22:06:12 -0400
Date: Thu, 24 Jul 2008 19:06:09 -0700
From: Chris McDermott <lcm@linux.vnet.ibm.com>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fix IBM Summit based systems' phys_cpu_present_map on
	32-bit kernels
Message-ID: <20080725020609.GB11800@us.ibm.com>
Mail-Followup-To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.6.22-15-generic
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


x86 kernels on IBM Summit based systems will only online 1 CPU because the
phys_cpu_present_map is not set up correctly. Patch below applied to 
2.6.26-git10.

thanks,

Chris McDermott <lcm@linux.vnet.ibm.com>


Signed-off-by: Chris McDermott <lcm@linux.vnet.ibm.com>
Tested-by: Tim Pepper <lnxninga@linux.vnet.ibm.com>


--- a/include/asm-x86/mach-summit/mach_apic.h	2008-07-24 18:06:39.000000000 -0700
+++ b/include/asm-x86/mach-summit/mach_apic.h	2008-07-24 18:09:29.000000000 -0700
@@ -122,7 +122,7 @@ static inline physid_mask_t ioapic_phys_
 
 static inline physid_mask_t apicid_to_cpu_present(int apicid)
 {
-	return physid_mask_of_physid(0);
+	return physid_mask_of_physid(apicid);
 }
 
 static inline void setup_portio_remap(void)

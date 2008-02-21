Return-Path: <linux-kernel-owner+w=401wt.eu-S932176AbYBULdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbYBULdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 06:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbYBULdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 06:33:00 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:15118 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752221AbYBULc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 06:32:59 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0JWL6QM-04-VEA-01
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
cc: linux-kernel@vger.kernel.org, "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH] X86: remove WARN_ON if MTRRs are all blank
Date: Thu, 21 Feb 2008 12:32:38 +0100
Message-ID: <1203593558-3391-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 21 Feb 2008 11:32:39.0168 (UTC)
 FILETIME=[76B9C800:01C8747D]
MIME-Version: 1.0
X-WSS-ID: 6BA3BED30QK12075801-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running Linux inside KVM all MTRRs are blank because there is no reason to
set them up. So doing a WARN_ON if all MTRRs are blank is not necessary. It is
sufficient to print the warning message using printk.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/cpu/mtrr/main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index b6e136f..e7f95a9 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -689,7 +689,6 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 	/* kvm/qemu doesn't have mtrr set right, don't trim them all */
 	if (!highest_pfn) {
 		printk(KERN_WARNING "WARNING: strange, CPU MTRRs all blank?\n");
-		WARN_ON(1);
 		return 0;
 	}
 
-- 
1.5.3.7




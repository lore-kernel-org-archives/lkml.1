Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbYGKLIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbYGKLIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYGKLCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:02:41 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:36777 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536AbYGKLCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:02:40 -0400
X-BigFish: VPS23(zzzz10d3izz5a6ciz32i87il61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3U9C0-01-XCQ-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86/pci: Changing subsystem initialization order for NUMA
Date: Fri, 11 Jul 2008 12:14:27 +0200
Message-ID: <1215771268-30007-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
X-OriginalArrivalTime: 11 Jul 2008 11:02:26.0195 (UTC) FILETIME=[9A5ACE30:01C8E345]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/legacy.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index 132876c..60e8caa 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -57,14 +57,14 @@ static int __init pci_legacy_init(void)
 
 int __init pci_subsys_init(void)
 {
+#ifdef CONFIG_X86_NUMAQ
+	pci_numa_init();
+#endif
 #ifdef CONFIG_ACPI
 	pci_acpi_init();
 #endif
 	pci_legacy_init();
 	pcibios_irq_init();
-#ifdef CONFIG_X86_NUMAQ
-	pci_numa_init();
-#endif
 	pcibios_init();
 
 	return 0;
-- 
1.5.5.4



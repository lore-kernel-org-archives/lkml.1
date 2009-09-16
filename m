Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbZIPInc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbZIPInc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758026AbZIPIn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:43:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:51178 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757604AbZIPInU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:43:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,396,1249282800"; 
   d="scan'208";a="551023855"
From: Sheng Yang <sheng@linux.intel.com>
To: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jun Nakajima <jun.nakajima@intel.com>, Eddie Dong <eddie.dong@intel.com>,
       linux-kernel@vger.kernel.org, xen-devel <xen-devel@lists.xensource.com>,
       Sheng Yang <sheng@linux.intel.com>
Subject: [RFC][PATCH 08/10] x86: Don't ack_APIC_irq() if lapic is disabled in GENERIC_INTERRUPT_VECTOR handler
Date: Wed, 16 Sep 2009 16:42:29 +0800
Message-Id: <1253090551-7969-9-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
References: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen hybrid guest don't use lapic, but smp_generic_interrupt() assume all it's
caller using lapic.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/kernel/irq.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index c3fe010..a887d25 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -236,7 +236,8 @@ void smp_generic_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
-	ack_APIC_irq();
+	if (!disable_apic)
+		ack_APIC_irq();
 
 	exit_idle();
 
-- 
1.5.4.5


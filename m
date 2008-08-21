Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbYHUSFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbYHUSFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbYHUSEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:04:53 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:50420 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217AbYHUSEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:04:52 -0400
X-IronPort-AV: E=Sophos;i="4.32,246,1217822400"; 
   d="scan'208";a="16837629"
From: Alex Nixon <alex.nixon@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alex Nixon <alex.nixon@citrix.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/7] Xen:  Add Xen implementation of wbinvd_halt
Date: Thu, 21 Aug 2008 19:04:44 +0100
Message-Id: <1219341888-23191-3-git-send-email-alex.nixon@citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1219341888-23191-2-git-send-email-alex.nixon@citrix.com>
References: <>
 <1219341888-23191-1-git-send-email-alex.nixon@citrix.com>
 <1219341888-23191-2-git-send-email-alex.nixon@citrix.com>
X-OriginalArrivalTime: 21 Aug 2008 18:04:52.0225 (UTC) FILETIME=[68B3CF10:01C903B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/xen/irq.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index bb04260..4e3f7f7 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -122,12 +122,19 @@ static void xen_halt(void)
 		xen_safe_halt();
 }
 
+static void xen_wbinvd_halt(void)
+{
+	native_wbinvd();
+	xen_halt();
+}
+
 static const struct pv_irq_ops xen_irq_ops __initdata = {
 	.init_IRQ = __xen_init_IRQ,
 	.save_fl = xen_save_fl,
 	.restore_fl = xen_restore_fl,
 	.irq_disable = xen_irq_disable,
 	.irq_enable = xen_irq_enable,
+	.wb_invd_halt = xen_wbinvd_halt,
 	.safe_halt = xen_safe_halt,
 	.halt = xen_halt,
 #ifdef CONFIG_X86_64
-- 
1.5.4.3


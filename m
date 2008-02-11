Return-Path: <linux-kernel-owner+w=401wt.eu-S1760477AbYBKT3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760477AbYBKT3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756740AbYBKT3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:29:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757521AbYBKT3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:29:15 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       ak@suse.de, chrisw@sous-sol.org, kiran@scalemp.com, shai@scalemp.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 5/5] [PATCH] use the paravirt helpers
Date: Mon, 11 Feb 2008 17:16:05 -0200
Message-Id: <1202757365-18634-5-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1202757365-18634-4-git-send-email-gcosta@redhat.com>
References: <1202757365-18634-1-git-send-email-gcosta@redhat.com>
 <1202757365-18634-2-git-send-email-gcosta@redhat.com>
 <1202757365-18634-3-git-send-email-gcosta@redhat.com>
 <1202757365-18634-4-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Glauber Costa <gcosta@redhat.com>
Signed-off-by: Ravikiran Thirumalai <kiran@scalemp.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
---
 arch/x86/kernel/vsmp_64.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index b93ed66..54202b1 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -87,6 +87,13 @@ void __init vsmp_init(void)
 	     PCI_DEVICE_ID_SCALEMP_VSMP_CTL))
 		return;
 
+	/* If we are, use the distinguished irq functions */
+	pv_irq_ops.irq_disable = vsmp_irq_disable;
+	pv_irq_ops.irq_enable  = vsmp_irq_enable;
+	pv_irq_ops.save_fl  = vsmp_save_fl;
+	pv_irq_ops.restore_fl  = vsmp_restore_fl;
+	pv_init_ops.patch = vsmp_patch;
+
 	/* set vSMP magic bits to indicate vSMP capable kernel */
 	cfg = read_pci_config(0, 0x1f, 0, PCI_BASE_ADDRESS_0);
 	address = early_ioremap(cfg, 8);
-- 
1.4.2


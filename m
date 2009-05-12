Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbZELX3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbZELX3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbZELXZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:25:33 -0400
Received: from 75-149-38-2-SFBA.hfc.comcastbusiness.net ([75.149.38.2]:36199
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753947AbZELXZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:25:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 13/17] xen: initialize irq 0 too
Date: Tue, 12 May 2009 16:25:20 -0700
Message-Id: <1242170724-13349-14-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242170724-13349-1-git-send-email-jeremy@goop.org>
References: <1242170724-13349-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

IRQ 0 is valid, so make sure it gets initialized properly too.
(Though in practice it doesn't matter, because its the timer
interrupt we don't use under Xen.)

[ Impact: theoretical bugfix, cleanup ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index db0c74c..381b7ab 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -53,7 +53,7 @@ int xen_register_gsi(u32 gsi, int triggering, int polarity)
 
 	printk(KERN_DEBUG "xen: --> irq=%d\n", irq);
 
-	if (irq > 0)
+	if (irq >= 0)
 		xen_set_io_apic_routing(irq,
 					triggering == ACPI_EDGE_SENSITIVE ? 0 : 1,
 					polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-- 
1.6.0.6


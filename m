Return-Path: <linux-kernel-owner+w=401wt.eu-S1760226AbZCMQqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760226AbZCMQqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759505AbZCMQnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:43:22 -0400
Received: from gw.goop.org ([64.81.55.164]:57288 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759395AbZCMQnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:43:20 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 13/17] xen: initialize irq 0 too
Date: Fri, 13 Mar 2009 09:42:34 -0700
Message-Id: <1236962558-13748-14-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236962558-13748-1-git-send-email-jeremy@goop.org>
References: <1236962558-13748-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

IRQ 0 is valid, so make sure it gets initialized properly too.
(Though in practice it doesn't matter, because its the timer
interrupt we don't use.)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index f55532d..502ff5f 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -52,7 +52,7 @@ int xen_register_gsi(u32 gsi, int triggering, int polarity)
 
 	printk(KERN_DEBUG "xen: --> irq=%d\n", irq);
 
-	if (irq > 0)
+	if (irq >= 0)
 		xen_set_io_apic_routing(irq,
 					triggering == ACPI_EDGE_SENSITIVE ? 0 : 1,
 					polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-- 
1.6.0.6


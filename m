Return-Path: <linux-kernel-owner+w=401wt.eu-S1764315AbZEHAb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764315AbZEHAb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759864AbZEHAKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:52 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52707
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754145AbZEHAKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:10:00 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 12/18] xen: initialize irq 0 too
Date: Thu,  7 May 2009 14:14:37 -0700
Message-Id: <1241730883-4917-13-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241730883-4917-1-git-send-email-jeremy@goop.org>
References: <1241730883-4917-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: theoretical bugfix, cleanup

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


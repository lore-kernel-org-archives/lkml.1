Return-Path: <linux-kernel-owner+w=401wt.eu-S1761345AbZEHAMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345AbZEHAMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbZEHAJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:09:58 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52704
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753699AbZEHAJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:54 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 18/18] xen/apic: add pin argument to setup_ioapic_entry()
Date: Thu,  7 May 2009 14:14:43 -0700
Message-Id: <1241730883-4917-19-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241730883-4917-1-git-send-email-jeremy@goop.org>
References: <1241730883-4917-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

setup_ioapic_entry() grew a 'pin' argument, so give it one.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index 5b9ee11..07b59fe 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -34,7 +34,8 @@ static void xen_set_io_apic_routing(int irq, int trigger, int polarity)
 	printk(KERN_INFO "xen_set_ioapic_routing: irq %d gsi %d vector %d ioapic %d pin %d triggering %d polarity %d\n",
 		irq, gsi, vector, ioapic, ioapic_pin, trigger, polarity);
 
-	setup_ioapic_entry(ioapic, -1, &entry, ~0, trigger, polarity, vector);
+	setup_ioapic_entry(ioapic, -1, &entry, ~0, trigger, polarity, vector,
+			   ioapic_pin);
 	ioapic_write_entry(ioapic, ioapic_pin, entry);
 }
 
-- 
1.6.0.6


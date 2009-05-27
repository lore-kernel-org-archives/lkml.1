Return-Path: <linux-kernel-owner+w=401wt.eu-S1762917AbZE0HmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762917AbZE0HmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761229AbZE0HiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:38:10 -0400
Received: from claw.goop.org ([74.207.240.146]:41718 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761236AbZE0HiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:38:08 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 13/17] xen: initialize irq 0 too
Date: Wed, 27 May 2009 00:37:26 -0700
Message-Id: <1243409850-21577-14-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243409850-21577-1-git-send-email-jeremy@goop.org>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org>
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


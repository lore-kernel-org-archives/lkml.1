Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbYKMKia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbYKMKia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 05:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYKMKiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 05:38:20 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:37190 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYKMKiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 05:38:19 -0500
From: Mark Nelson <markn@au1.ibm.com>
Organization: IBM
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] genirq: __irq_set_trigger: change pr_warning to pr_debug
Date: Thu, 13 Nov 2008 21:37:41 +1100
User-Agent: KMail/1.9.9
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
References: <200811131730.11506.markn@au1.ibm.com> <20081113074300.GC1723@elte.hu>
In-Reply-To: <20081113074300.GC1723@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811132137.41863.markn@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0c5d1eb77a8be917b638344a22afe1398236482b (genirq: record trigger
type) caused powerpc platforms that had no set_type() function in their
struct irq_chip to spew out warnings about "No set_type function for
IRQ...". This warning isn't necessarily justified though because the
generic powerpc platform code calls set_irq_type() (which in turn calls
__irq_set_trigger) with information from the device tree to establish
the interrupt mappings, regardless of whether the PIC can actually set
a type.

A platform's irq_chip might not have a set_type function for a variety
of reasons, for example: the platform may have the type essentially
hard-coded, or as in the case for Cell interrupts are just messages
past around that have no real concept of type, or the platform
could even have a virtual PIC as on the PS3.

Signed-off-by: Mark Nelson <markn@au1.ibm.com>
---
Thanks Ingo! Much appreciated

 kernel/irq/manage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: upstream/kernel/irq/manage.c
===================================================================
--- upstream.orig/kernel/irq/manage.c
+++ upstream/kernel/irq/manage.c
@@ -327,7 +327,7 @@ int __irq_set_trigger(struct irq_desc *d
 		 * IRQF_TRIGGER_* but the PIC does not support multiple
 		 * flow-types?
 		 */
-		pr_warning("No set_type function for IRQ %d (%s)\n", irq,
+		pr_debug("No set_type function for IRQ %d (%s)\n", irq,
 				chip ? (chip->name ? : "unknown") : "unknown");
 		return 0;
 	}

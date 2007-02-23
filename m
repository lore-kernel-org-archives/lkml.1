Return-Path: <linux-kernel-owner+w=401wt.eu-S932484AbXBWLRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484AbXBWLRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932515AbXBWLRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:17:31 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50670 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932484AbXBWLRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:17:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Zwane Mwaikambo <zwane@infradead.org>,
       Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 04/14] x86_64 irq: Remove the unused vector parameter from ioapic_register_intr
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070206073616.GA15016@elte.hu>
	<m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>
	<20070206222523.GA11602@elte.hu>
	<m1irecamzh.fsf@ebiederm.dsl.xmission.com>
	<m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
	<m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
	<m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
	<m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>
	<m17iuoz74f.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702111416220.24829@montezuma.fsmlabs.com>
	<m1r6swx9l2.fsf@ebiederm.dsl.xmission.com>
	<m1irdtw3jb.fsf_-_@ebiederm.dsl.xmission.com>
	<m1bqjlw2mr.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9w2kj.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b4xw2h8.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7mpunuk.fsf_-_@ebiederm.dsl.xmission.com>
Date: Fri, 23 Feb 2007 04:16:31 -0700
In-Reply-To: <m1y7mpunuk.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Fri, 23 Feb 2007 04:15:15 -0700")
Message-ID: <m1tzxdunsg.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86_64/kernel/io_apic.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index 2d154e1..a69c38b 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -799,7 +799,7 @@ static struct irq_chip ioapic_chip;
 #define IOAPIC_EDGE	0
 #define IOAPIC_LEVEL	1
 
-static void ioapic_register_intr(int irq, int vector, unsigned long trigger)
+static void ioapic_register_intr(int irq, unsigned long trigger)
 {
 	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
 			trigger == IOAPIC_LEVEL)
@@ -847,7 +847,7 @@ static void __init setup_IO_APIC_irq(int apic, int pin, int idx, int irq)
 		entry.dest = cpu_mask_to_apicid(mask);
 		entry.vector = vector;
 
-		ioapic_register_intr(irq, vector, IOAPIC_AUTO);
+		ioapic_register_intr(irq, IOAPIC_AUTO);
 		if (!apic && (irq < 16))
 			disable_8259A_irq(irq);
 	}
@@ -2133,7 +2133,7 @@ int io_apic_set_pci_routing (int ioapic, int pin, int irq, int triggering, int p
 	       mp_ioapics[ioapic].mpc_apicid, pin, entry.vector, irq,
 	       triggering, polarity);
 
-	ioapic_register_intr(irq, entry.vector, triggering);
+	ioapic_register_intr(irq, triggering);
 
 	if (!ioapic && (irq < 16))
 		disable_8259A_irq(irq);
-- 
1.5.0.g53756


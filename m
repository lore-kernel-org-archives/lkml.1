Return-Path: <linux-kernel-owner+w=401wt.eu-S1762284AbZFPUQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762284AbZFPUQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758644AbZFPUQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:16:07 -0400
Received: from claw.goop.org ([74.207.240.146]:40558 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbZFPUQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:16:04 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/16] Cleanups to io_apic.c
Date: Tue, 16 Jun 2009 13:15:39 -0700
Message-Id: <1245183355-25808-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's a series of little cleanup patches to kernel/apic/io_apic.c which
I fixed as I was reviewing the code.

There are a few classes of cleanup here:
 - Unification of 32 and 64-bit variants, where they are functionally
   identical.

 - Removing unnecessary #ifdef CONFIG_X86_32/64 (similar to unification,
   except its code which is at worst a no-op on the other platform).
   This cleans up the appearance of the code, and makes compile-test
   coverage broader.  For the 82093AA workaround, the test should be
   more fine-grained (ie, actually look at the I/O APIC version).

 - Restructure loops to use more conventional forms (lots of odd loops
   which can be easily represented by a plain for() loop)

 - Fix some comments, delete redundant decls, etc.

Jeremy Fitzhardinge (12):
      x86/acpi: acpi_parse_madt_ioapic_entries: remove redundant braces
      x86/ioapic.c: ioapic_modify_irq is too large to inline
      x86/ioapic.c: unify __mask_IO_APIC_irq()
      x86/ioapic.c: remove #ifdef for 82093AA workaround
      x86/ioapic.c: remove redundant declaration of irq_pin_list
      x86/ioapic.c: move lost comment to what seems like appropriate place
      x86/ioapic.c: convert io_apic_level_ack_pending loop to normal for() loop
      x86/ioapic.c: simplify add_pin_to_irq_node()
      x86/ioapic.c: convert replace_pin_at_irq_node to conventional for() loop
      x86/ioapic.c: clean up replace_pin_at_irq_node logic and comments
      x86/ioapic.c: convert __target_IO_APIC_irq to conventional for() loop
      x86/ioapic.c: unify ioapic_retrigger_irq()

 arch/x86/kernel/acpi/boot.c    |    3 +-
 arch/x86/kernel/apic/io_apic.c |  144 ++++++++++++----------------------------
 2 files changed, 45 insertions(+), 102 deletions(-)


Thanks,
	J


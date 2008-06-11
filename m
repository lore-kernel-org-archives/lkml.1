Return-Path: <linux-kernel-owner+w=401wt.eu-S1759393AbYFKPGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbYFKPGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757559AbYFKPGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:06:04 -0400
Received: from mail.suse.de ([195.135.220.2]:60416 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757433AbYFKPGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:06:02 -0400
From: Stefan Assmann <sassmann@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, Olaf Dabrunz <od@suse.de>,
       Stefan Assmann <sassmann@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
       Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>
Subject: [PATCH 0/5] Boot IRQ quirks and rerouting [repost]
Date: Wed, 11 Jun 2008 16:35:12 +0200
Message-Id: <12131949173532-git-send-email-sassmann@suse.de>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are against linux-2.6-tip, auto-x86-next.

The AMD/ATI and Broadcomm patches are not included yet, we're working
on getting things ready for submission.

The patch for the bootirqquirk= parameter will be released later.


When IRQ lines on secondary or higher IO-APICs are masked (as done by
RT and others), many chipsets redirect IRQs on this line to the PIC, and
thereby regularly to the first IO-APIC in the system. This causes
spurious interrupts and can lead to disabled IRQ lines.

Disabling this "boot interrupt" (as it is mostly used to supply all
IRQs to the legacy PIC during boot) is chipset-specific. It is also not
possible for all chips. This patchset disables the boot interrupt on
chipsets where this is possible and where we know how to do it.

Where disabling the boot interrupt is not possible, the patches provide a boot
parameter pci=ioapicreroute to only use the boot interrupt (on the first
IO-APIC) instead of the "original" line on the secondary (tertiary ...)
IO-APIC. The original line remains masked, and IRQs always appear on the boot
interrupt line on the first IO-APIC instead.

A second boot parameter pci=noioapicquirk allows to disable all quirks that
disable boot interrupts.

All patches are co-authored by Stefan Assmann and Olaf Dabrunz. But
according to Documentation/SubmittingPatches, the patch submission format
allows only for one author.

Documentation/kernel-parameters.txt |    7 ++++
arch/x86/pci/common.c               |    9 +++++
drivers/acpi/pci_irq.c              |   56 ++++++++++++++++++++++++++++++++++
drivers/pci/quirks.c                |   59 +++++++++++++++++++++++++++++++++++-
include/asm-x86/io_apic.h           |    8 ++++
include/asm-x86/pci.h               |    4 +-
include/linux/pci.h                 |    7 +++-
include/linux/pci_ids.h             |    6 +++
8 files changed, 151 insertions(+), 5 deletions(-)


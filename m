Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605Ab0AYVoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0AYVoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678Ab0AYVlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:41:04 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:40711 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0AYVk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:40:58 -0500
Subject: [PATCH 00/12] ACPI: processor driver vs. core
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Jan 2010 14:40:38 -0700
Message-ID: <20100125213221.28510.74078.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series cleans up some of the mess I made when introducing
early _PDC.

The major change is renaming processor_core.c to processor_driver.c,
and then renaming processor_pdc.c to processor_core.c.

The idea is that the code in processor_core.c will always be built
statically into the kernel (as long as ACPI is configured), while
allowing the ACPI processor driver to remain modular (if so desired).

We do this because part of the cleanups involves teaching the
early _PDC evaluation code how to determine if a processor is
physically present or not -- aka enumeration -- and that sort
of code doesn't really belong in a file named processor_pdc.

There are quite a few checkpatch errors in the first rename patch,
and I'll look at cleaning those up in a later series.

/ac

---

Alex Chiang (12):
      ACPI: processor: mv processor_core.c processor_driver.c
      ACPI: processor: mv processor_pdc.c processor_core.c
      ACPI: processor: export acpi_get_cpuid()
      ACPI: processor: move acpi_get_cpuid into processor_core.c
      ACPI: processor: add internal processor_physically_present()
      ACPI: processor: remove early _PDC optin quirks
      ACPI: processor: driver doesn't need to evaluate _PDC
      ACPI: processor: refactor internal map_lapic_id()
      ACPI: processor: refactor internal map_x2apic_id()
      ACPI: processor: refactor internal map_lsapic_id()
      ACPI: processor: push file static MADT pointer into internal map_madt_entry()
      ACPI: processor core: style and sparse cleanups


 Documentation/kernel-parameters.txt |    4 
 arch/ia64/kernel/acpi.c             |    3 
 arch/x86/kernel/acpi/boot.c         |    3 
 drivers/acpi/Makefile               |    4 
 drivers/acpi/processor_core.c       | 1149 +++++------------------------------
 drivers/acpi/processor_driver.c     |  976 ++++++++++++++++++++++++++++++
 drivers/acpi/processor_pdc.c        |  209 ------
 include/acpi/processor.h            |   10 
 8 files changed, 1172 insertions(+), 1186 deletions(-)
 create mode 100644 drivers/acpi/processor_driver.c
 delete mode 100644 drivers/acpi/processor_pdc.c


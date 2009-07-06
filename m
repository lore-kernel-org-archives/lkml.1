Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbZGFXdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbZGFXdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 19:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbZGFXc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:32:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47675 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbZGFXc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:32:57 -0400
Date: Mon, 6 Jul 2009 16:32:39 -0700
Message-Id: <200907062332.n66NWdTP011405@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86 fixes for 2.6.31-rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The latest batch of x86 fixes are available in:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

This includes several non-regression (or at least
non-recent-regression) fixes that were queued up before 2.6.31-rc2,
marked * below.  If you want me to create a branch without these, let
me know.

Akinobu Mita (1):
      x86: fix usage of bios intcall()

Ingo Molnar (2):
*     x86: Fix printk call in print_local_apic()
      Merge branch 'amd-iommu/fixes' of git://git.kernel.org/.../joro/linux-2.6-iommu into x86/urgent

Jan Beulich (1):
      x86: Fix fixmap ordering

Jaswinder Singh Rajput (5):
*     x86: Remove double declaration of MSR_P6_EVNTSEL0 and MSR_P6_EVNTSEL1
*     x86: Mark device_nb as static and fix NULL noise
*     x86: Declare check_efer() before it gets used
*     x86: Remove unused variable disable_x2apic
*     x86: Remove unused function lapic_watchdog_ok()

Joerg Roedel (2):
*?    amd-iommu: handle alias entries correctly in init code
*?    amd-iommu: set evt_buf_size correctly

Mathieu Desnoyers (1):
      x86: Fix fixmap page order for FIX_TEXT_POKE0,1

Mike Galbraith (2):
*     x86: Fix symbol annotation for arch/x86/lib/clear_page_64.S::clear_page_c
*     x86: Add missing annotation to arch/x86/lib/copy_user_64.S::copy_to_user

Pekka Enberg (1):
      xen: Use kcalloc() in xen_init_IRQ()

Rakib Mullick (1):
*?    x86, kvm: Fix section mismatches in kvm.c

 arch/x86/boot/video-bios.c             |    3 +--
 arch/x86/boot/video-vesa.c             |    4 ++--
 arch/x86/include/asm/fixmap.h          |   10 +++++-----
 arch/x86/include/asm/msr-index.h       |    4 ----
 arch/x86/include/asm/nmi.h             |    1 -
 arch/x86/kernel/amd_iommu.c            |    4 ++--
 arch/x86/kernel/amd_iommu_init.c       |   13 +++++++++----
 arch/x86/kernel/apic/apic.c            |    2 --
 arch/x86/kernel/apic/io_apic.c         |   31 +++++++++++++------------------
 arch/x86/kernel/cpu/perfctr-watchdog.c |    5 -----
 arch/x86/kernel/kvm.c                  |    2 +-
 arch/x86/lib/clear_page_64.S           |    5 ++---
 arch/x86/lib/copy_user_64.S            |    1 +
 arch/x86/mm/init.c                     |    1 +
 drivers/xen/events.c                   |    4 ++--
 15 files changed, 39 insertions(+), 51 deletions(-)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761284AbZD0UiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761284AbZD0UiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761113AbZD0Uhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:37:34 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:56641 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761236AbZD0Uhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:37:33 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 00/14] clean up page aligned data and bss sections
Date: Mon, 27 Apr 2009 16:32:54 -0400
Message-Id: <1240864388-26315-1-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

This patch series add new macros for .data.page_aligned and
.bss.page_aligned, and converts the various architectures to use them.
It also eliminates the few remaining uses of .data.idt by replacing
them with references to .data.page_aligned.

This patch series is a bunch of cleanup in preparation for being able
to change the names of the .data.page_aligned and .bss.page_aligned
sections to be compatabible with -ffunction-sections -fdata-sections.

The x86 patches are on top of the your commit in the x86/kbuild of
linux-tip entitled:

    x86: beautify vmlinux_64.lds.S

    -Tim Abbott

--

Tim Abbott (14):
  Add new macros for page-aligned data and bss sections.
  sh: Use macros for .bss.page_aligned section.
  mn10300: Use macros for .bss.page_aligned section.
  xtensa: Use macros for .bss.page_aligned section.
  x86: Use macros for .bss.page_aligned section.
  alpha: Use macros for .data.page_aligned.
  avr32: Use standard macros for .data.page_aligned section.
  sh: Use macros for .data.page_aligned section.
  s390: Use macros for .data.page_aligned.
  powerpc: Remove unused __page_aligned macro.
  powerpc: Use macros for .data.page_aligned section.
  mn10300: Drop unused .data.idt section.
  x86: Use section .data.page_aligned for the idt_table.
  x86: Use macros for .data.page_aligned.

 arch/alpha/kernel/vmlinux.lds.S             |    6 +-----
 arch/avr32/kernel/vmlinux.lds.S             |    3 +--
 arch/avr32/mm/init.c                        |    4 +---
 arch/mn10300/kernel/vmlinux.lds.S           |    5 +----
 arch/powerpc/include/asm/page_64.h          |    8 --------
 arch/powerpc/kernel/vdso.c                  |    2 +-
 arch/powerpc/kernel/vdso32/vdso32_wrapper.S |    3 ++-
 arch/powerpc/kernel/vdso64/vdso64_wrapper.S |    3 ++-
 arch/powerpc/kernel/vmlinux.lds.S           |    6 +-----
 arch/s390/kernel/vdso.c                     |    2 +-
 arch/s390/kernel/vdso32/vdso32_wrapper.S    |    3 ++-
 arch/s390/kernel/vdso64/vdso64_wrapper.S    |    3 ++-
 arch/s390/kernel/vmlinux.lds.S              |    6 +-----
 arch/sh/kernel/irq.c                        |    6 ++----
 arch/sh/kernel/vmlinux_32.lds.S             |    5 ++---
 arch/sh/kernel/vmlinux_64.lds.S             |    5 ++---
 arch/x86/kernel/head_32.S                   |    4 ++--
 arch/x86/kernel/head_64.S                   |    2 +-
 arch/x86/kernel/traps.c                     |    6 ++----
 arch/x86/kernel/vmlinux_32.lds.S            |    9 ++-------
 arch/x86/kernel/vmlinux_64.lds.S            |    8 ++------
 arch/xtensa/kernel/head.S                   |    2 +-
 arch/xtensa/kernel/vmlinux.lds.S            |    2 +-
 include/asm-generic/vmlinux.lds.h           |    8 ++++++++
 include/linux/linkage.h                     |    9 +++++++++
 25 files changed, 50 insertions(+), 70 deletions(-)


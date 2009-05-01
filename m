Return-Path: <linux-kernel-owner+w=401wt.eu-S1763627AbZEAAOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763627AbZEAAOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764438AbZEAACY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:02:24 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61771 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765283AbZEAACX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:02:23 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 00/11] section name cleanup for x86
Date: Thu, 30 Apr 2009 20:01:27 -0400
Message-Id: <1241136098-10376-1-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up the section names on the x86
architecture.  It requires the architecture-independent macro
definitions from this patch series:

<http://www.spinics.net/lists/mips/msg33499.html>

The long-term goal here is to add support for building the kernel with
-ffunction-sections -fdata-sections.  This requires renaming all the
magic section names in the kernel of the form .text.foo, .data.foo,
.bss.foo, and .rodata.foo to not have collisions with sections
generated for code like:

static int nosave = 0; /* -fdata-sections places in .data.nosave */
static void head(); /* -ffunction-sections places in .text.head */

These patches are on top of the x86/kbuild branch of linux-tip.

	-Tim Abbott


Anders Kaseorg (1):
  x86: fix fragile computation of vsyscall address

Tim Abbott (10):
  x86: Use macros for .bss.page_aligned section.
  x86: Use section .data.page_aligned for the idt_table.
  x86: Use macros for .data.page_aligned.
  x86: convert compressed loader to use __HEAD and HEAD_TEXT macros.
  x86: convert to use __HEAD and HEAD_TEXT macros.
  x86: use NOSAVE_DATA macro for .data.nosave section.
  x86: use new macro for .data.cacheline_aligned section.
  x86: use new macros for .data.init_task.
  x86: use new macro for .data.read_mostly section.
  x86: convert to new generic read_mostly support.

 arch/x86/Kconfig                       |    3 +
 arch/x86/boot/compressed/head_32.S     |    3 +-
 arch/x86/boot/compressed/head_64.S     |    3 +-
 arch/x86/boot/compressed/vmlinux.lds.S |    6 +-
 arch/x86/include/asm/cache.h           |    2 -
 arch/x86/kernel/head_32.S              |    6 +-
 arch/x86/kernel/head_64.S              |    4 +-
 arch/x86/kernel/init_task.c            |    3 +-
 arch/x86/kernel/traps.c                |    6 +-
 arch/x86/kernel/vmlinux.lds.S          |  119 ++++++++------------------------
 10 files changed, 49 insertions(+), 106 deletions(-)


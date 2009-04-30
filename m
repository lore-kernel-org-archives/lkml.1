Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbZEAAL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbZEAAL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765136AbZEAABd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:01:33 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61502 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765131AbZEAABc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:01:32 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 0/8] section name cleanup for powerpc
Date: Thu, 30 Apr 2009 19:56:09 -0400
Message-Id: <1241135777-9462-1-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up the section names on the powerpc
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

Note that these patches have not been boot-tested (aside from testing
the analogous changes on x86), since I don't have access to the
appropriate hardware.

	-Tim Abbott


Tim Abbott (8):
  powerpc: Remove unused __page_aligned macro.
  powerpc: share .data output section definition between 32 and 64
    bits.
  powerpc: Use macros for .data.page_aligned section.
  powerpc: use NOSAVE_DATA macro for .data.nosave section.
  powerpc: use new macro for .data.cacheline_aligned section.
  powerpc: use new macros for .data.init_task.
  powerpc: use new macro for .data.read_mostly section.
  powerpc: convert to new generic read_mostly support.

 arch/powerpc/Kconfig                        |    3 ++
 arch/powerpc/include/asm/cache.h            |    4 --
 arch/powerpc/include/asm/page_64.h          |    8 ----
 arch/powerpc/kernel/init_task.c             |    3 +-
 arch/powerpc/kernel/machine_kexec_64.c      |    4 +-
 arch/powerpc/kernel/vdso.c                  |    3 +-
 arch/powerpc/kernel/vdso32/vdso32_wrapper.S |    3 +-
 arch/powerpc/kernel/vdso64/vdso64_wrapper.S |    3 +-
 arch/powerpc/kernel/vmlinux.lds.S           |   47 ++++++--------------------
 9 files changed, 23 insertions(+), 55 deletions(-)


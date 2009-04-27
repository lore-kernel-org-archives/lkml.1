Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbZD0SG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbZD0SG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758593AbZD0SF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:05:56 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62436 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758569AbZD0SFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:05:53 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 0/8] cleanup old init and refok sections
Date: Mon, 27 Apr 2009 14:02:19 -0400
Message-Id: <1240855347-19316-1-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

This patch series cleans up the use of the deprecated section names
.text.init, .text.init.refok, .exit.text.refok, and .data.init.refok
in the Linux kernel, replacing them with the appropriate macros that
reference the current names for these sections.

The long-term goal here is to be able to change the kernel's magic
section names to those that are compatible with -ffunction-sections
-fdata-sections.  Doing so requires renaming all magic sections with
names of the form ".text.foo" or ".data.bar".

--

Tim Abbott (8):
  frv: Remove unused header asm/init.h.
  frv: Use __INIT macro instead of .text.init.
  arm: Use __INIT macro instead of .text.init.
  powerpc: Use TEXT_TEXT macro in linker script.
  powerpc: Use __REF macro instead of old .text.init.refok.
  sh: Use __INIT macro instead of .text.init.
  sparc: cleanup references to deprecated .text.init* sections.
  Remove unused support code for refok sections.

 arch/arm/mm/proc-v6.S              |    3 ++-
 arch/arm/mm/proc-v7.S              |    3 ++-
 arch/arm/mm/tlb-v6.S               |    3 ++-
 arch/arm/mm/tlb-v7.S               |    3 ++-
 arch/frv/include/asm/init.h        |   12 ------------
 arch/frv/kernel/head-mmu-fr451.S   |    3 ++-
 arch/frv/kernel/head-uc-fr401.S    |    3 ++-
 arch/frv/kernel/head-uc-fr451.S    |    3 ++-
 arch/frv/kernel/head-uc-fr555.S    |    3 ++-
 arch/powerpc/include/asm/ppc_asm.h |    5 +++--
 arch/powerpc/kernel/vmlinux.lds.S  |    3 ++-
 arch/sh/kernel/cpu/sh5/entry.S     |    5 +++--
 arch/sparc/kernel/head_32.S        |    2 +-
 arch/sparc/kernel/head_64.S        |    2 +-
 include/asm-generic/vmlinux.lds.h  |    3 ---
 include/linux/init.h               |    8 --------
 scripts/mod/modpost.c              |   18 ------------------
 17 files changed, 26 insertions(+), 56 deletions(-)
 delete mode 100644 arch/frv/include/asm/init.h


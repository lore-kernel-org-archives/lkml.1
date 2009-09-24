Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbZIXOhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbZIXOhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbZIXOhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:37:00 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33080 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884AbZIXOg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:36:59 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v2 00/11] Linker script cleanups for various architectures
Date: Thu, 24 Sep 2009 10:36:15 -0400
Message-Id: <1253802986-8132-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This patch series contains patches cleaning up the linker scripts on
several architectures (as well as one improvement to the
architecture-independent macros).  Please merge.

PATCH v2 differs from v1 in the following ways:
* I removed the m32r patches as you have a pull request from the m32r
  maintainer containing them.
* I added the lone blackfin patch that I sent you to merge on Tuesday.
* I added the patches for alpha.
* I improved the commit message for the first patch.

This cross-architecture linker script cleanup project is in
preparation for adding support for building the kernel with
-ffunction-sections -fdata-sections, which is a prerequisite for
Ksplice.

	-Tim Abbott

Geoffrey Thomas (1):
  alpha: Clean up linker script using new linker script macros.

Tim Abbott (10):
  Optimize the ordering of sections in RW_DATA_SECTION.
  parisc: Clean up linker script using new linker script macros.
  parisc: Remove useless altinstructions code copied from x86.
  xtensa: Cleanup linker script using new linker script macros.
  um: Clean up linker script using standard macros.
  h8300: Cleanup linker script using new linker script macros.
  mn10300: Clean up linker script using higher-level macros.
  blackfin: Cleanup linker script using new linker script macros.
  powerpc: Cleanup linker script using new linker script macros.
  alpha: use .data.init_task instead of .data.init_thread.

 arch/alpha/kernel/init_task.c      |    5 +-
 arch/alpha/kernel/vmlinux.lds.S    |   95 ++++-----------------------------
 arch/blackfin/kernel/vmlinux.lds.S |   56 ++-----------------
 arch/h8300/kernel/vmlinux.lds.S    |   25 +++------
 arch/mn10300/kernel/vmlinux.lds.S  |   40 ++------------
 arch/parisc/kernel/vmlinux.lds.S   |  104 ++----------------------------------
 arch/powerpc/kernel/vmlinux.lds.S  |   69 +++++-------------------
 arch/um/include/asm/common.lds.S   |   29 ++--------
 arch/um/kernel/dyn.lds.S           |    9 +---
 arch/um/kernel/uml.lds.S           |   26 ++-------
 arch/xtensa/kernel/vmlinux.lds.S   |   75 +++++---------------------
 include/asm-generic/vmlinux.lds.h  |    4 +-
 12 files changed, 78 insertions(+), 459 deletions(-)


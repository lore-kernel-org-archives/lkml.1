Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbZIVOXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbZIVOXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbZIVOXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:23:09 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:56302 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754474AbZIVOXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:23:06 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH 00/13] Linker script cleanup patches for various architectures
Date: Tue, 22 Sep 2009 10:22:14 -0400
Message-Id: <1253629347-23119-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This patch series contains patches cleaning up the linker scripts on
several architectures architectures (as well as one improvement to the
architecture-independent macros).  Everything here has been acked or
reviewed by Sam Ravnborg.  Please merge.

This cross-architecture linker script cleanup project is in
preparation for adding support for building the kernel with
-ffunction-sections -fdata-sections, which is a prerequisite for
Ksplice.

	-Tim Abbott

Tim Abbott (13):
  Optimize the ordering of sections in RW_DATA_SECTION.
  m32r: make PAGE_SIZE available to assembly.
  m32r: Define THREAD_SIZE only once.
  m32r: Move GET_THREAD_INFO definition out of asm/thread_info.h.
  m32r: Remove unused .altinstructions and .exit.* code from linker
    script.
  m32r: Move the spi_stack_top and spu_stack_top into .init.data
    section.
  m32r: Cleanup linker script using new linker script macros.
  parisc: Clean up linker script using new linker script macros.
  parisc: Remove useless altinstructions code copied from x86.
  xtensa: Cleanup linker script using new linker script macros.
  um: Clean up linker script using standard macros.
  h8300: Cleanup linker script using new linker script macros.
  mn10300: Clean up linker script using higher-level macros.

 arch/h8300/kernel/vmlinux.lds.S     |   25 ++------
 arch/m32r/include/asm/page.h        |    4 +-
 arch/m32r/include/asm/processor.h   |    2 -
 arch/m32r/include/asm/thread_info.h |   15 +----
 arch/m32r/kernel/entry.S            |    7 ++
 arch/m32r/kernel/head.S             |    4 +-
 arch/m32r/kernel/vmlinux.lds.S      |   78 +++-----------------------
 arch/mn10300/kernel/vmlinux.lds.S   |   40 +------------
 arch/parisc/kernel/vmlinux.lds.S    |  104 +---------------------------------
 arch/um/include/asm/common.lds.S    |   29 ++--------
 arch/um/kernel/dyn.lds.S            |    9 +--
 arch/um/kernel/uml.lds.S            |   26 ++-------
 arch/xtensa/kernel/vmlinux.lds.S    |   75 +++++--------------------
 include/asm-generic/vmlinux.lds.h   |    4 +-
 14 files changed, 68 insertions(+), 354 deletions(-)


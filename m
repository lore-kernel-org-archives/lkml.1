Return-Path: <linux-kernel-owner+w=401wt.eu-S1764741AbZEAAH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764741AbZEAAH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758251AbZEAAAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:00:49 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61211 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765006AbZEAAAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:00:48 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 0/7] section name cleanup for sh
Date: Thu, 30 Apr 2009 19:57:56 -0400
Message-Id: <1241135883-9766-1-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up the section names on the sh
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


Tim Abbott (7):
  sh: Use macros for .bss.page_aligned section.
  sh: Use macros for .data.page_aligned section.
  sh: use NOSAVE_DATA macro for .data.nosave section.
  sh: use new macro for .data.cacheline_aligned section.
  sh: use new macros for .data.init_task.
  sh: use new macro for .data.read_mostly section.
  sh: convert to new generic read_mostly support.

 arch/sh/Kconfig                 |    3 +++
 arch/sh/include/asm/cache.h     |    2 --
 arch/sh/kernel/init_task.c      |    3 +--
 arch/sh/kernel/irq.c            |    6 ++----
 arch/sh/kernel/vmlinux_32.lds.S |   24 ++++++------------------
 arch/sh/kernel/vmlinux_64.lds.S |   24 ++++++------------------
 6 files changed, 18 insertions(+), 44 deletions(-)


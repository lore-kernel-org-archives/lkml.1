Return-Path: <linux-kernel-owner+w=401wt.eu-S1759093AbZD3Xoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093AbZD3Xoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758361AbZD3XoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:44:13 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58862 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758371AbZD3XoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:44:12 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 0/6] section name cleanup for arm
Date: Thu, 30 Apr 2009 19:40:02 -0400
Message-Id: <1241134808-7583-1-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up the section names on the arm
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


Tim Abbott (6):
  arm: use _AC(1, UL) when defining PAGE_SIZE.
  arm: convert to use __HEAD and HEAD_TEXT macros.
  arm: use NOSAVE_DATA macro for .data.nosave section.
  arm: use new macro for .data.cacheline_aligned section.
  arm: use new macros for .data.init_task.
  arm: use PERCPU macro in linker script.

 arch/arm/include/asm/page.h   |    4 +++-
 arch/arm/kernel/head-nommu.S  |    2 +-
 arch/arm/kernel/head.S        |    2 +-
 arch/arm/kernel/init_task.c   |    3 +--
 arch/arm/kernel/vmlinux.lds.S |   29 +++++++++--------------------
 5 files changed, 15 insertions(+), 25 deletions(-)


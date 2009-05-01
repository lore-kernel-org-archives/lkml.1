Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbZEAAXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbZEAAXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761919AbZEAAEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:04:30 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62158 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765116AbZEAAE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:04:29 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 0/5] section name cleanup for ia64
Date: Thu, 30 Apr 2009 20:04:02 -0400
Message-Id: <1241136247-10623-1-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up the section names on the ia64
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

Tim Abbott (5):
  ia64: Use .ref.text, not .text.init for start_ap.
  ia64: use new macro for .data.cacheline_aligned section.
  ia64: use new macros for .data.init_task
  ia64: use new macro for .data.read_mostly section.
  ia64: convert to new generic read_mostly support.

 arch/ia64/Kconfig              |    3 +++
 arch/ia64/include/asm/cache.h  |    2 --
 arch/ia64/kernel/head.S        |    2 +-
 arch/ia64/kernel/init_task.c   |    2 +-
 arch/ia64/kernel/vmlinux.lds.S |   15 +++------------
 arch/ia64/xen/xensetup.S       |    3 ++-
 6 files changed, 10 insertions(+), 17 deletions(-)


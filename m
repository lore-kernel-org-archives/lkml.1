Return-Path: <linux-kernel-owner+w=401wt.eu-S1765166AbZEAAUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765166AbZEAAUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765404AbZEAADb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:03:31 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61966 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765361AbZEAAD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:03:29 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, "David S. Miller" <davem@davemloft.net>,
       sparclinux@vger.kernel.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 0/4] section name cleanup for sparc
Date: Thu, 30 Apr 2009 19:58:49 -0400
Message-Id: <1241135933-9913-1-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up the section names on the sparc
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


Tim Abbott (4):
  sparc: use new macro for .data.cacheline_aligned section.
  sparc: use new macros for .data.init_task.
  sparc: use new macro for .data.read_mostly section.
  sparc: convert to new generic read_mostly support.

 arch/sparc/Kconfig              |    3 +++
 arch/sparc/include/asm/cache.h  |    2 --
 arch/sparc/kernel/init_task.c   |    5 ++---
 arch/sparc/kernel/vmlinux.lds.S |   16 +++-------------
 4 files changed, 8 insertions(+), 18 deletions(-)


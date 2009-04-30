Return-Path: <linux-kernel-owner+w=401wt.eu-S1764586AbZD3XEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764586AbZD3XEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764194AbZD3XDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:03:46 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52411 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763886AbZD3XDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:03:44 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Richard Henderson <rth@twiddle.net>,
       linux-alpha@vger.kernel.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 0/4] section name cleanup for alpha
Date: Thu, 30 Apr 2009 19:00:12 -0400
Message-Id: <1241132416-7055-1-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up the section names on the alpha
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
  alpha: Use macros for .data.page_aligned.
  alpha: use new macro for .data.cacheline_aligned section.
  alpha: make THREAD_SIZE available to assembly files.
  alpha: use .data.init_task instead of .data.init_thread

 arch/alpha/include/asm/thread_info.h |    4 ++--
 arch/alpha/kernel/init_task.c        |    5 ++---
 arch/alpha/kernel/vmlinux.lds.S      |   19 ++++---------------
 3 files changed, 8 insertions(+), 20 deletions(-)


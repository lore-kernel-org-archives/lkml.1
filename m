Return-Path: <linux-kernel-owner+w=401wt.eu-S1764754AbZD3Xzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764754AbZD3Xzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764326AbZD3Xxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:53:55 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60450 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764294AbZD3Xxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:53:54 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 0/4] section name cleanup for mips
Date: Thu, 30 Apr 2009 19:53:26 -0400
Message-Id: <1241135610-9012-1-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up the section names on the mips
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
  mips: use NOSAVE_DATA macro for .data.nosave section.
  mips: use new macro for .data.cacheline_aligned section.
  mips: use new macros for .data.init_task.
  mips: use .text, not .text.start, for lasat boot loader.

 arch/mips/kernel/init_task.c           |    5 ++---
 arch/mips/kernel/vmlinux.lds.S         |   19 +++----------------
 arch/mips/lasat/image/head.S           |    2 +-
 arch/mips/lasat/image/romscript.normal |    2 +-
 4 files changed, 7 insertions(+), 21 deletions(-)


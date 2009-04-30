Return-Path: <linux-kernel-owner+w=401wt.eu-S1763351AbZEAACj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763351AbZEAACj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764052AbZD3X64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:58:56 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61090 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764861AbZD3X6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:58:55 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 0/2] section name cleanup for h8300
Date: Thu, 30 Apr 2009 19:46:13 -0400
Message-Id: <1241135175-8183-1-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up the section names on the h8300
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


Tim Abbott (2):
  h8300: use new macros for .data.init_task.
  h8300: use .head.text for compressed bootloader.

 arch/h8300/boot/compressed/head.S      |    3 ++-
 arch/h8300/boot/compressed/vmlinux.lds |    2 +-
 arch/h8300/kernel/init_task.c          |    3 +--
 arch/h8300/kernel/vmlinux.lds.S        |    3 +--
 4 files changed, 5 insertions(+), 6 deletions(-)


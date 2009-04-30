Return-Path: <linux-kernel-owner+w=401wt.eu-S1764611AbZD3Xyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764611AbZD3Xyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbZD3Xvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:51:41 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60093 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763460AbZD3Xvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:51:40 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Michal Simek <monstr@monstr.eu>,
       microblaze-uclinux@itee.uq.edu.au, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 0/2] section name cleanup for microblaze
Date: Thu, 30 Apr 2009 19:51:02 -0400
Message-Id: <1241135464-8778-1-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up the section names on the microblaze
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
  microblaze: use new macro for .data.cacheline_aligned section.
  microblaze: use new macros for .data.init_task

 arch/microblaze/kernel/init_task.c   |    3 +--
 arch/microblaze/kernel/vmlinux.lds.S |    8 ++------
 2 files changed, 3 insertions(+), 8 deletions(-)


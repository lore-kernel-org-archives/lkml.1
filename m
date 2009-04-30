Return-Path: <linux-kernel-owner+w=401wt.eu-S1764930AbZD3X7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764930AbZD3X7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764659AbZD3XzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:55:13 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60731 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764650AbZD3XzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:55:12 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, David Howells <dhowells@redhat.com>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 0/6] section name cleanup for mn10300
Date: Thu, 30 Apr 2009 19:54:15 -0400
Message-Id: <1241135661-9147-1-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up the section names on the mn10300
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
  mn10300: Use macros for .bss.page_aligned section.
  mn10300: Drop unused .data.idt section.
  mn10300: use NOSAVE_DATA macro for .data.nosave section.
  mn10300: use new macro for .data.cacheline_aligned section.
  mn10300: use new macros for .data.init_task.
  mn10300: use new macro for .data.read_mostly section.

 arch/mn10300/kernel/init_task.c   |    3 +--
 arch/mn10300/kernel/vmlinux.lds.S |   29 ++++++-----------------------
 2 files changed, 7 insertions(+), 25 deletions(-)


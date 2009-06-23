Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbZFXACd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbZFXACd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 20:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757418AbZFXACY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 20:02:24 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:43800 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757158AbZFXACX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 20:02:23 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, devel@ksplice.com,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH 0/2] Macros for section name cleanup
Date: Tue, 23 Jun 2009 19:57:30 -0400
Message-Id: <1245801452-13222-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.1
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the remaining changes from my previous macros for section
name cleanup patch series that were not subsumed by Sam Ravnborg's
recent update to vmlinux.lds.h (commit
7923f90fffa8746f6457d4eea2109fd3d6414189).

I've dropped the patch reworking __read_mostly to be a generic thing
in include/linux/cache.h.  I think the consensus on that patch was
that we should first make all the architectures support
.data.read_mostly in their linker scripts and then do a single patch
removing all the architecture implementations in favor of a single one
in include/linux/cache.h.

The long-term goal here is to add support for building the kernel with
-ffunction-sections -fdata-sections.  This requires renaming all the
magic section names in the kernel of the form .text.foo, .data.foo,
.bss.foo, and .rodata.foo to not have collisions with sections
generated for code like:

static int nosave = 0; /* -fdata-sections places in .data.nosave */
static void head(); /* -ffunction-sections places in .text.head */

Sam Ravnborg proposed that rather than just renaming all the sections
outright, we should start by first getting more control over the
section names used in the kernel so that we can later rename sections
without touching too many files.  This patch series provides the
architecture-independent macros needed for that cleanup.

Tim Abbott (2):
  Add new macros for page-aligned data and bss sections.
  Add new __init_task_data macro to be used in arch init_task.c files.

 include/linux/init_task.h |    3 +++
 include/linux/linkage.h   |    9 +++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)


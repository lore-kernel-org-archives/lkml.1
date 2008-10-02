Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbYJBXmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbYJBXmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYJBXmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:42:43 -0400
Received: from gw.goop.org ([64.81.55.164]:32769 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbYJBXmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:42:43 -0400
Message-ID: <48E55C6B.5070805@goop.org>
Date: Thu, 02 Oct 2008 16:42:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <srostedt@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen: remove unused balloon.h
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The balloon driver doesn't have any externally callable functions at
the moment, so remove the (effectively empty) header.  We can add it
back if we need to.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/balloon.c |    1 
 include/xen/balloon.h |   61 -------------------------------------------------
 2 files changed, 62 deletions(-)

===================================================================
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -53,7 +53,6 @@
 #include <asm/tlb.h>
 
 #include <xen/interface/memory.h>
-#include <xen/balloon.h>
 #include <xen/xenbus.h>
 #include <xen/features.h>
 #include <xen/page.h>
===================================================================
--- a/include/xen/balloon.h
+++ /dev/null
@@ -1,61 +0,0 @@
-/******************************************************************************
- * balloon.h
- *
- * Xen balloon driver - enables returning/claiming memory to/from Xen.
- *
- * Copyright (c) 2003, B Dragovic
- * Copyright (c) 2003-2004, M Williamson, K Fraser
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation; or, when distributed
- * separately from the Linux kernel or incorporated into other
- * software packages, subject to the following license:
- *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this source file (the "Software"), to deal in the Software without
- * restriction, including without limitation the rights to use, copy, modify,
- * merge, publish, distribute, sublicense, and/or sell copies of the Software,
- * and to permit persons to whom the Software is furnished to do so, subject to
- * the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
- * IN THE SOFTWARE.
- */
-
-#ifndef __XEN_BALLOON_H__
-#define __XEN_BALLOON_H__
-
-#include <linux/spinlock.h>
-
-#if 0
-/*
- * Inform the balloon driver that it should allow some slop for device-driver
- * memory activities.
- */
-void balloon_update_driver_allowance(long delta);
-
-/* Allocate/free a set of empty pages in low memory (i.e., no RAM mapped). */
-struct page **alloc_empty_pages_and_pagevec(int nr_pages);
-void free_empty_pages_and_pagevec(struct page **pagevec, int nr_pages);
-
-void balloon_release_driver_page(struct page *page);
-
-/*
- * Prevent the balloon driver from changing the memory reservation during
- * a driver critical region.
- */
-extern spinlock_t balloon_lock;
-#define balloon_lock(__flags)   spin_lock_irqsave(&balloon_lock, __flags)
-#define balloon_unlock(__flags) spin_unlock_irqrestore(&balloon_lock, __flags)
-#endif
-
-#endif /* __XEN_BALLOON_H__ */



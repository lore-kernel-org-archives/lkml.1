Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYAQBn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYAQBn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 20:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYAQBnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 20:43:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51527 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbYAQBnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 20:43:49 -0500
Message-ID: <478EB2CC.8000900@cn.fujitsu.com>
Date: Thu, 17 Jan 2008 09:43:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mathieu.desnoyers@polymtl.ca, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Revert "local_t Documentation update"
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit e1265205c0ee3919c3f2c750662630154c8faab2.

It's a duplicate commit of commit 74beb9db77930be476b267ec8518a642f39a04bf,
resulting in a duplicate section.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 Documentation/local_ops.txt |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/Documentation/local_ops.txt b/Documentation/local_ops.txt
index 1a45f11..4269a11 100644
--- a/Documentation/local_ops.txt
+++ b/Documentation/local_ops.txt
@@ -68,29 +68,6 @@ typedef struct { atomic_long_t a; } local_t;
   variable can be read when reading some _other_ cpu's variables.
 
 
-* Rules to follow when using local atomic operations
-
-- Variables touched by local ops must be per cpu variables.
-- _Only_ the CPU owner of these variables must write to them.
-- This CPU can use local ops from any context (process, irq, softirq, nmi, ...)
-  to update its local_t variables.
-- Preemption (or interrupts) must be disabled when using local ops in
-  process context to   make sure the process won't be migrated to a
-  different CPU between getting the per-cpu variable and doing the
-  actual local op.
-- When using local ops in interrupt context, no special care must be
-  taken on a mainline kernel, since they will run on the local CPU with
-  preemption already disabled. I suggest, however, to explicitly
-  disable preemption anyway to make sure it will still work correctly on
-  -rt kernels.
-- Reading the local cpu variable will provide the current copy of the
-  variable.
-- Reads of these variables can be done from any CPU, because updates to
-  "long", aligned, variables are always atomic. Since no memory
-  synchronization is done by the writer CPU, an outdated copy of the
-  variable can be read when reading some _other_ cpu's variables.
-
-
 * How to use local atomic operations
 
 #include <linux/percpu.h>
-- 
1.5.3.rc7


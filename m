Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbZCVRBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbZCVRBq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 13:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZCVRBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 13:01:36 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:40580 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZCVRBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 13:01:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QAxrL6h0T6JpebkBiKKSjEmTE8gVlldRGWxtDsQV39Xgwo4mEuARtJD2cEV+ax1aSL
         b2a+AU78YLkCJeRsAvpzaaxzrGcNwJc39J0fkVSRV4kYqcIRukuSNy7d7rNymenOCO0Z
         b1CAzxQFaC3rpADbtJniAnUxB6hhSjDyKAlXI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] tracing/function-graph-tracer: don't profile branches on graph tracer
Date: Sun, 22 Mar 2009 18:01:29 +0100
Message-Id: <1237741289-14926-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix slow tracing

The core kernel tracing is protected against soft branch profiling, but
not the x86 ftrace arch part. Let's fix it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 599e9a7..8d9b3f9 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -13,6 +13,7 @@ CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
+CFLAGS_ftrace.o += -DDISABLE_BRANCH_PROFILING
 endif
 
 #
-- 
1.6.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbYLCX6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbYLCX6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbYLCX60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:58:26 -0500
Received: from vpnflf.ccur.com ([12.192.68.2]:59087 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754355AbYLCX6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:58:25 -0500
Date: Wed, 3 Dec 2008 18:58:19 -0500
From: Joe Korty <joe.korty@ccur.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Change thread_info's flag field back to 32 bits
Message-ID: <20081203235819.GA17615@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change x86_64's thread_info 'flags' field back to __u32.

This was changed to 'unsigned long' when the thread_info*.h
for i386 and x86_64 were merged.  Change it back.  We can
do this as only 27 bits of 'flags' are actually used.

This change actually packs down thread_info by 64 bits:
32 bits are saved by the smaller flags, and 32 bits are
saved by the following 'mm_segment_t field' becoming
naturally 64-bit aligned.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.28-rc7/arch/x86/include/asm/thread_info.h
===================================================================
--- 2.6.28-rc7.orig/arch/x86/include/asm/thread_info.h	2008-12-03 17:53:10.000000000 -0500
+++ 2.6.28-rc7/arch/x86/include/asm/thread_info.h	2008-12-03 18:31:40.000000000 -0500
@@ -24,7 +24,7 @@
 struct thread_info {
 	struct task_struct	*task;		/* main task structure */
 	struct exec_domain	*exec_domain;	/* execution domain */
-	unsigned long		flags;		/* low level flags */
+	__u32			flags;		/* low level flags */
 	__u32			status;		/* thread synchronous flags */
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable,

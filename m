Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbXI0J5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbXI0J5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 05:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXI0J5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 05:57:03 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:5723 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbXI0J5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 05:57:01 -0400
Date: Thu, 27 Sep 2007 13:55:57 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH -mm] task_struct: move ->fpu_counter and ->oomkilladj
Message-ID: <20070927095557.GA6758@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is nice 2 byte hole after struct task_struct::ioprio field
into which we can put two 1-byte fields: ->fpu_counter and ->oomkilladj.

[cc'ing Arjan just in case ->fpu_counter placement wasn't completely random :^)]

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 include/linux/sched.h |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -960,6 +960,16 @@ struct task_struct {
 #endif
 
 	unsigned short ioprio;
+	/*
+	 * fpu_counter contains the number of consecutive context switches
+	 * that the FPU is used. If this is over a threshold, the lazy fpu
+	 * saving becomes unlazy to save the trap. This is an unsigned char
+	 * so that after 256 times the counter wraps and the behavior turns
+	 * lazy again; this to deal with bursty apps that only use FPU for
+	 * a short time
+	 */
+	unsigned char fpu_counter;
+	s8 oomkilladj; /* OOM kill score adjustment (bit shift). */
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	unsigned int btrace_seq;
 #endif
@@ -1044,16 +1054,6 @@ struct task_struct {
 	struct key *thread_keyring;	/* keyring private to this thread */
 	unsigned char jit_keyring;	/* default keyring to attach requested keys to */
 #endif
-	/*
-	 * fpu_counter contains the number of consecutive context switches
-	 * that the FPU is used. If this is over a threshold, the lazy fpu
-	 * saving becomes unlazy to save the trap. This is an unsigned char
-	 * so that after 256 times the counter wraps and the behavior turns
-	 * lazy again; this to deal with bursty apps that only use FPU for
-	 * a short time
-	 */
-	unsigned char fpu_counter;
-	s8 oomkilladj; /* OOM kill score adjustment (bit shift). */
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
 				     - access with [gs]et_task_comm (which lock
 				       it with task_lock())


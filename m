Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbYGVIG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbYGVIG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYGVIGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:06:49 -0400
Received: from ozlabs.org ([203.10.76.45]:38600 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbYGVIGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:06:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: lguest <lguest@ozlabs.org>
Subject: [PATCH] lguest: set max_pfn_mapped, growl loudly at Yinghai Lu
Date: Tue, 22 Jul 2008 18:06:32 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221806.32852.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

6af61a7614a306fe882a0c2b4ddc63b65aa66efc 'x86: clean up max_pfn_mapped
usage - 32-bit' makes the following comment:

    XEN PV and lguest may need to assign max_pfn_mapped too.

But no CC.  Yinghai, wasting fellow developers' time is a VERY bad
habit.  If you do it again, I will hunt you down and try to extract
the three hours of my life I just lost :)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>

diff -r edb477ef3b4a arch/x86/lguest/boot.c
--- a/arch/x86/lguest/boot.c	Tue Jul 22 15:31:04 2008 +1000
+++ b/arch/x86/lguest/boot.c	Tue Jul 22 17:45:40 2008 +1000
@@ -1015,6 +1015,9 @@ __init void lguest_init(void)
 	init_pg_tables_start = __pa(pg0);
 	init_pg_tables_end = __pa(pg0);
 
+	/* As described in head_32.S, we map the first 128M of memory. */
+	max_pfn_mapped = (128*1024*1024) >> PAGE_SHIFT;
+
 	/* Load the %fs segment register (the per-cpu segment register) with
 	 * the normal data segment to get through booting. */
 	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_DS) : "memory");

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbYLGLHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbYLGLHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 06:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbYLGLHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 06:07:25 -0500
Received: from ozlabs.org ([203.10.76.45]:39325 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbYLGLHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 06:07:25 -0500
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 7 Dec 2008 21:37:18 +1030
Subject: [PATCH 1/2] cpumask: Use smp_call_function_many(): sparc64
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072137.18631.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change smp_call_function_mask() callers to smp_call_function_many().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/sparc64/kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/arch/sparc64/kernel/smp.c
+++ linux-2.6/arch/sparc64/kernel/smp.c
@@ -850,7 +850,7 @@ static void tsb_sync(void *info)
 
 void smp_tsb_sync(struct mm_struct *mm)
 {
-	smp_call_function_mask(mm->cpu_vm_mask, tsb_sync, mm, 1);
+	smp_call_function_many(&mm->cpu_vm_mask, tsb_sync, mm, 1);
 }
 
 extern unsigned long xcall_flush_tlb_mm;


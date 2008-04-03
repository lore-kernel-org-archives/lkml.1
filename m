Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbYDCOxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbYDCOxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 10:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbYDCOxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 10:53:46 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41771 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757861AbYDCOxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 10:53:45 -0400
Subject: [PATCH] x86: fix miscompile
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 09:53:38 -0500
Message-Id: <1207234418.3048.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch local to the x86 tree introduced a fairly obvious compile
fault:

commit f22fc9998497af6c271385e2025e2fe71c6f15b0
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Apr 2 12:20:18 2008 +0200

    x86: allocate FPU context to init task

I've attached the fix below (INIT_THREAD is a #defined initializer, not
an actual structure).  However, if you get this tree into linux-next,
they'll do a much better job of shaking out bugs like this than I could.

James

---

diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index d4686cf..2fad98d 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -828,7 +828,7 @@ extern union thread_xstate init_xstate;
 	.sysenter_cs		= __KERNEL_CS,				  \
 	.io_bitmap_ptr		= NULL,					  \
 	.fs			= __KERNEL_PERCPU,			  \
-	.xstate			= &init_xstate;
+	.xstate			= &init_xstate,				  \
 }
 
 /*



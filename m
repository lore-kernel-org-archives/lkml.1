Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbXLFXUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbXLFXUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 18:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbXLFXUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 18:20:21 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:50719 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbXLFXUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 18:20:20 -0500
From: Zach Brown <zach.brown@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Simon Holm Thogersen <odie@cs.aau.dk>, suresh.b.siddha@intel.com
Subject: [PATCH 1/6] indirect: use asmlinkage in i386 syscall table prototype
Date: Thu,  6 Dec 2007 15:20:14 -0800
Message-Id: <11969832193635-git-send-email-zach.brown@oracle.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1196983219534-git-send-email-zach.brown@oracle.com>
References: <1196983219534-git-send-email-zach.brown@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call_indirect() was using the wrong calling convention for the system call
handlers.  system call handlers would get mixed up arguments.

Signed-off-by: Zach Brown <zach.brown@oracle.com>

diff --git a/include/asm-x86/indirect_32.h b/include/asm-x86/indirect_32.h
index a1b72ac..e3dea8e 100644
--- a/include/asm-x86/indirect_32.h
+++ b/include/asm-x86/indirect_32.h
@@ -15,8 +15,8 @@ struct indirect_registers {
 
 static inline long call_indirect(struct indirect_registers *regs)
 {
-  extern long (*sys_call_table[]) (__u32, __u32, __u32, __u32, __u32, __u32);
-
+	extern asmlinkage long (*sys_call_table[])(long, long, long,
+						   long, long, long);
   return sys_call_table[INDIRECT_SYSCALL(regs)](regs->ebx, regs->ecx,
 						regs->edx, regs->esi,
 						regs->edi, regs->ebp);
-- 
1.5.2.2


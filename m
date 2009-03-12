Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbZCLKy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbZCLKy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbZCLKyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:54:11 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:33006 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbZCLKyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:54:10 -0400
Message-Id: <49B8F355.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 10:34:45 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: remove meaningless unwind annotations
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These got left in needlessly when ret_from_fork got simplified.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/entry_64.S |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.29-rc7/arch/x86/kernel/entry_64.S	2009-03-11 17:52:10.000000000 +0100
+++ 2.6.29-rc7-x86_64-unwind-ret_from_fork/arch/x86/kernel/entry_64.S	2009-03-10 16:41:53.000000000 +0100
@@ -418,7 +418,6 @@ ENTRY(ret_from_fork)
 
 	GET_THREAD_INFO(%rcx)
 
-	CFI_REMEMBER_STATE
 	RESTORE_REST
 
 	testl $3, CS-ARGOFFSET(%rsp)		# from kernel_thread?
@@ -430,7 +429,6 @@ ENTRY(ret_from_fork)
 	RESTORE_TOP_OF_STACK %rdi, -ARGOFFSET
 	jmp ret_from_sys_call			# go to the SYSRET fastpath
 
-	CFI_RESTORE_STATE
 	CFI_ENDPROC
 END(ret_from_fork)
 




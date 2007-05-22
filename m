Return-Path: <linux-kernel-owner+w=401wt.eu-S934638AbXEVVqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934638AbXEVVqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757991AbXEVVqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:46:44 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:60267 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275AbXEVVqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:46:44 -0400
Date: Tue, 22 May 2007 17:38:31 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Roland McGrath <roland@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Current utrace breaks UML
Message-ID: <20070522213831.GB10293@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This chunk from linux-2.6-utrace.patch breaks PTRACE_SYSEMU, which UML
rather relies on.

@@ -514,9 +514,6 @@ syscall_trace_entry:
 	movl %esp, %eax
 	xorl %edx,%edx
 	call do_syscall_trace
-	cmpl $0, %eax
-	jne resume_userspace		# ret != 0 -> running under PTRACE_SYSEMU,
-					# so must skip actual syscall
 	movl PT_ORIG_EAX(%esp), %eax
 	cmpl $(nr_syscalls), %eax
 	jnae syscall_call

If the point of this patch was to completely remove ptrace support,
with later patches adding it back, then that chunk should be added
back in utrace-ptrace-compat.patch.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

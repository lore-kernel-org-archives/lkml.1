Return-Path: <linux-kernel-owner+w=401wt.eu-S932412AbXBNSDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412AbXBNSDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 13:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932410AbXBNSDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 13:03:21 -0500
Received: from [198.99.130.12] ([198.99.130.12]:33409 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932412AbXBNSDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 13:03:20 -0500
Date: Wed, 14 Feb 2007 12:55:39 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andi Kleen <ak@suse.de>, akpm@osdl.org
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64 ptrace32 needs PTRACE_OLDSETOPTIONS
Message-ID: <20070214175539.GD5801@ccure.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 ptrace32 needs to support PTRACE_OLDSETOPTIONS.  This patch
just converts the PTRACE_OLDSETOPTIONS request to PTRACE_SETOPTIONS
and falls through to the sys_ptrace call.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/x86_64/ia32/ptrace32.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/arch/x86_64/ia32/ptrace32.c
===================================================================
--- linux-2.6.orig/arch/x86_64/ia32/ptrace32.c
+++ linux-2.6/arch/x86_64/ia32/ptrace32.c
@@ -239,6 +239,8 @@ asmlinkage long sys32_ptrace(long reques
 	__u32 val;
 
 	switch (request) { 
+	case PTRACE_OLDSETOPTIONS:
+		request = PTRACE_SETOPTIONS;
 	case PTRACE_TRACEME:
 	case PTRACE_ATTACH:
 	case PTRACE_KILL:

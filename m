Return-Path: <linux-kernel-owner+w=401wt.eu-S1751231AbXBUMIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbXBUMIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 07:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbXBUMIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 07:08:46 -0500
Received: from mbox.ssc.unict.it ([151.97.230.9]:42868 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbXBUMIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 07:08:46 -0500
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
To: stable@kernel.org
Cc: Andi Kleen <ak@suse.de>, Jeff Dike <jdike@addtoit.com>,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: x86_64: PTRACE_[GS]ET_THREAD_AREA should be accepted
Date: Wed, 21 Feb 2007 13:07:41 +0100
Message-Id: <11720596612428-git-send-email-blaisorblade@yahoo.it>
X-Mailer: git-send-email 1.4.4.4.ga596b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch backports from 2.6.19 a fix to a 2.6.18 regression.

Like for PTRACE_OLDSETOPTIONS, we should fix PTRACE_[GS]ET_THREAD_AREA. This had
been done already for 2.6.19, so this is for 2.6.18-stable only.
This was tested with UML/32bit as API consumer, both before and after this
patch.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Index: linux-2.6.18/arch/x86_64/ia32/ptrace32.c
===================================================================
--- linux-2.6.18.orig/arch/x86_64/ia32/ptrace32.c
+++ linux-2.6.18/arch/x86_64/ia32/ptrace32.c
@@ -241,6 +241,8 @@ asmlinkage long sys32_ptrace(long reques
 	case PTRACE_SYSCALL:
 	case PTRACE_OLDSETOPTIONS:
 	case PTRACE_SETOPTIONS:
+	case PTRACE_SET_THREAD_AREA:
+	case PTRACE_GET_THREAD_AREA:
 		return sys_ptrace(request, pid, addr, data); 
 
 	default:



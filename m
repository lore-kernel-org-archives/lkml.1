Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbZKMTzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbZKMTzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:55:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbZKMTy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:54:58 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58030 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343AbZKMTyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:54:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OTy2nrr6z3d9z3QWtw0CiwK8nozg15SA25G1ioRhW1vI8xpbfUFOBzh4IOVirl7Y9g
         8wqlfGWQ9NnnXJuLmEAABVPIREGrv+RdG5+r2zgkgVbE6LB6UD02MeLSgrDHqL84NiND
         NwPU9cfbnmQN87jiBV2lAkYwZawWzIiRS3jGU=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] x86, 32-bit: Don't push args on stack in kernel_thread_helper
Date: Fri, 13 Nov 2009 14:54:57 -0500
Message-Id: <1258142098-3832-4-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258142098-3832-1-git-send-email-brgerst@gmail.com>
References: <1258142098-3832-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regparm(3) is the normal calling convention now.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/entry_32.S |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 2778ae3..96e9c32 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -985,11 +985,7 @@ ENTRY(kernel_thread_helper)
 	pushl $0		# fake return address for unwinder
 	CFI_STARTPROC
 	movl %edi,%eax
-	push %edi
-	CFI_ADJUST_CFA_OFFSET 4
 	call *%esi
-	push %eax
-	CFI_ADJUST_CFA_OFFSET 4
 	call do_exit
 	ud2			# padding for call trace
 	CFI_ENDPROC
-- 
1.6.2.5


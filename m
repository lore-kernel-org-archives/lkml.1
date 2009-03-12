Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbZCLL6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbZCLL6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbZCLL61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:58:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:59740 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755836AbZCLL60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:58:26 -0400
Date: Thu, 12 Mar 2009 11:57:45 GMT
From: Jan Beulich <jbeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B8F641.76E4.0078.0@novell.com>
References: <49B8F641.76E4.0078.0@novell.com>
Subject: [tip:x86/asm] x86-64: remove unnecessary spill/reload of rbx from memcpy
Message-ID: <tip-dd1ef4ec4721ddc0a1f2b73a4f67930cb320665c@git.kernel.org>
Git-Commit-ID: dd1ef4ec4721ddc0a1f2b73a4f67930cb320665c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 12 Mar 2009 11:57:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd1ef4ec4721ddc0a1f2b73a4f67930cb320665c
Gitweb:     http://git.kernel.org/tip/dd1ef4ec4721ddc0a1f2b73a4f67930cb320665c
Author:     "Jan Beulich" <jbeulich@novell.com>
AuthorDate: Thu, 12 Mar 2009 10:47:13 +0000
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 12 Mar 2009 12:04:47 +0100

x86-64: remove unnecessary spill/reload of rbx from memcpy

Impact: micro-optimization

This should slightly improve its performance.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <49B8F641.76E4.0078.0@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/lib/memcpy_64.S |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index c22981f..10c0676 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -33,9 +33,6 @@ ENDPROC(memcpy_c)
 ENTRY(__memcpy)
 ENTRY(memcpy)
 	CFI_STARTPROC
-	pushq %rbx
-	CFI_ADJUST_CFA_OFFSET 8
-	CFI_REL_OFFSET rbx, 0
 	movq %rdi,%rax
 
 	movl %edx,%ecx
@@ -102,11 +99,7 @@ ENTRY(memcpy)
 	jnz .Lloop_1
 
 .Lende:
-	popq %rbx
-	CFI_ADJUST_CFA_OFFSET -8
-	CFI_RESTORE rbx
 	ret
-.Lfinal:
 	CFI_ENDPROC
 ENDPROC(memcpy)
 ENDPROC(__memcpy)

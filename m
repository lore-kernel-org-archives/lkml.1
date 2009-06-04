Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbZFDMoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbZFDMoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757905AbZFDMoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:44:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:49890 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878AbZFDMoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:44:14 -0400
Subject: [PATCH 5/6] headers_check fix: mn10300, ptrace.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, yasutake.koichi@jp.panasonic.com,
       linux-am33-list@redhat.com
In-Reply-To: <1244118949.5172.37.camel@ht.satnam>
References: <1244118232.5172.26.camel@ht.satnam>
	 <1244118476.5172.29.camel@ht.satnam>  <1244118599.5172.31.camel@ht.satnam>
	 <1244118714.5172.33.camel@ht.satnam>  <1244118949.5172.37.camel@ht.satnam>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 18:07:19 +0530
Message-Id: <1244119039.5172.39.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make headers_check' warning:

  usr/include/asm-mn10300/ptrace.h:80: extern's make no sense in userspace

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/mn10300/include/asm/ptrace.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/mn10300/include/asm/ptrace.h b/arch/mn10300/include/asm/ptrace.h
index 7b06cc6..00aa680 100644
--- a/arch/mn10300/include/asm/ptrace.h
+++ b/arch/mn10300/include/asm/ptrace.h
@@ -77,8 +77,6 @@ struct pt_regs {
 };
 #endif
 
-extern struct pt_regs *__frame; /* current frame pointer */
-
 /* Arbitrarily choose the same ptrace numbers as used by the Sparc code. */
 #define PTRACE_GETREGS            12
 #define PTRACE_SETREGS            13
@@ -90,6 +88,8 @@ extern struct pt_regs *__frame; /* current frame pointer */
 
 #if defined(__KERNEL__)
 
+extern struct pt_regs *__frame;		/* current frame pointer */
+
 #if !defined(__ASSEMBLY__)
 #define user_mode(regs)			(((regs)->epsw & EPSW_nSL) == EPSW_nSL)
 #define instruction_pointer(regs)	((regs)->pc)
@@ -99,5 +99,4 @@ extern void show_regs(struct pt_regs *);
 #define profile_pc(regs) ((regs)->pc)
 
 #endif  /*  __KERNEL__  */
-
 #endif /* _ASM_PTRACE_H */
-- 
1.6.0.6




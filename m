Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbZICTbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbZICTbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 15:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbZICTbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 15:31:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:57756 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbZICTbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 15:31:41 -0400
Date: Thu, 3 Sep 2009 19:31:02 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       petkovbb@googlemail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       petkovbb@googlemail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <tip-f6909f394c2d4a0a71320797df72d54c49c5927e@git.kernel.org>
References: <tip-f6909f394c2d4a0a71320797df72d54c49c5927e@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, msr: Fix msr-reg.S compilation with gas 2.16.1, on 32-bit too
Message-ID: <tip-8adf65cfae2d6c2ec5c06e4521f089c62f9eff05@git.kernel.org>
Git-Commit-ID: 8adf65cfae2d6c2ec5c06e4521f089c62f9eff05
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 03 Sep 2009 19:31:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8adf65cfae2d6c2ec5c06e4521f089c62f9eff05
Gitweb:     http://git.kernel.org/tip/8adf65cfae2d6c2ec5c06e4521f089c62f9eff05
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 3 Sep 2009 21:26:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Sep 2009 21:26:34 +0200

x86, msr: Fix msr-reg.S compilation with gas 2.16.1, on 32-bit too

The macro was defined in the 32-bit path as well - breaking the
build on 32-bit platforms:

  arch/x86/lib/msr-reg.S: Assembler messages:
  arch/x86/lib/msr-reg.S:53: Error: Bad macro parameter list
  arch/x86/lib/msr-reg.S:100: Error: invalid character '_' in mnemonic
  arch/x86/lib/msr-reg.S:101: Error: invalid character '_' in mnemonic

Cc: Borislav Petkov <petkovbb@googlemail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <tip-f6909f394c2d4a0a71320797df72d54c49c5927e@git.kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/lib/msr-reg.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/msr-reg.S b/arch/x86/lib/msr-reg.S
index d5eaf53..69fa106 100644
--- a/arch/x86/lib/msr-reg.S
+++ b/arch/x86/lib/msr-reg.S
@@ -50,7 +50,7 @@ ENDPROC(native_\op\()_safe_regs)
 
 #else /* X86_32 */
 
-.macro op_safe_regs op:req
+.macro op_safe_regs op
 ENTRY(native_\op\()_safe_regs)
 	CFI_STARTPROC
 	pushl_cfi %ebx

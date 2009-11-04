Return-Path: <linux-kernel-owner+w=401wt.eu-S1751974AbZKDGeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbZKDGeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZKDGeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:34:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:46748 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbZKDGeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:34:05 -0500
Date: Wed, 4 Nov 2009 06:33:42 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257274925-15713-1-git-send-email-brgerst@gmail.com>
References: <1257274925-15713-1-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, 64-bit: Fix bstep_iret jump
Message-ID: <tip-97829de5a3b88899c5f3ac8802d11868bf4180ba@git.kernel.org>
Git-Commit-ID: 97829de5a3b88899c5f3ac8802d11868bf4180ba
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97829de5a3b88899c5f3ac8802d11868bf4180ba
Gitweb:     http://git.kernel.org/tip/97829de5a3b88899c5f3ac8802d11868bf4180ba
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Tue, 3 Nov 2009 14:02:05 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 3 Nov 2009 20:50:02 +0100

x86, 64-bit: Fix bstep_iret jump

This jump should be unconditional.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1257274925-15713-1-git-send-email-brgerst@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/entry_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index af0f4b2..1579a6c 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1501,7 +1501,7 @@ error_kernelspace:
 bstep_iret:
 	/* Fix truncated RIP */
 	movq %rcx,RIP+8(%rsp)
-	je error_swapgs
+	jmp error_swapgs
 END(error_entry)
 
 

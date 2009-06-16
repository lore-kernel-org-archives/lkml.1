Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbZFPM5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbZFPM5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbZFPMzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:55:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:44911 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193AbZFPMza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:55:30 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH v3 6/9] x86: move 32-bit vDSO padding from .data to .rodata
Date: Tue, 16 Jun 2009 14:55:26 +0200
Message-Id: <1245156929-30395-7-git-send-email-ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
References: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The padding is read-only after all, so there is no reason to put it
into a writable section.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/vdso/vdso32/int80.S   |    2 +-
 arch/x86/vdso/vdso32/syscall.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/vdso/vdso32/int80.S b/arch/x86/vdso/vdso32/int80.S
index b15b7c0..3f8c174 100644
--- a/arch/x86/vdso/vdso32/int80.S
+++ b/arch/x86/vdso/vdso32/int80.S
@@ -51,6 +51,6 @@ __kernel_vsyscall:
 	 * Pad out the segment to match the size of the sysenter.S version.
 	 */
 VDSO32_vsyscall_eh_frame_size = 0x40
-	.section .data,"aw",@progbits
+	.section .rodata,"a",@progbits
 	.space VDSO32_vsyscall_eh_frame_size-(.LENDFDEDLSI-.LSTARTFRAMEDLSI), 0
 	.previous
diff --git a/arch/x86/vdso/vdso32/syscall.S b/arch/x86/vdso/vdso32/syscall.S
index 5415b56..7def1fe 100644
--- a/arch/x86/vdso/vdso32/syscall.S
+++ b/arch/x86/vdso/vdso32/syscall.S
@@ -72,6 +72,6 @@ __kernel_vsyscall:
 	 * Pad out the segment to match the size of the sysenter.S version.
 	 */
 VDSO32_vsyscall_eh_frame_size = 0x40
-	.section .data,"aw",@progbits
+	.section .rodata,"a",@progbits
 	.space VDSO32_vsyscall_eh_frame_size-(.LENDFDE1-.LSTARTFRAME), 0
 	.previous
-- 
1.6.0.2


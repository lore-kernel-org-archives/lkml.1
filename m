Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbYLYU7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbYLYU7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 15:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYLYU65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 15:58:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51749 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbYLYU6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 15:58:55 -0500
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: Switch critical exceptions and NMI to irqstack
Date: Thu, 25 Dec 2008 22:58:46 +0200
Message-Id: <1230238726-17506-4-git-send-email-avi@redhat.com>
In-Reply-To: <1230238726-17506-1-git-send-email-avi@redhat.com>
References: <1230238726-17506-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the special exception stacks gone, the irqstack is a much safer place
than the regular task stacks.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/entry_64.S |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 245fecd..8f40593 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -917,7 +917,10 @@ END(spurious_interrupt)
 	movq %rsp,%rdi
 	movq ORIG_RAX(%rsp),%rsi
 	movq $-1,ORIG_RAX(%rsp)
+	mov %rsp, %rbp
+	enter_irqstack %rax
 	call \sym
+	mov %rbp, %rsp
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	.if \irqtrace
 	TRACE_IRQS_OFF
-- 
1.6.0.6


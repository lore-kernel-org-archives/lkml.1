Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbYLZOXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbYLZOXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 09:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYLZOWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 09:22:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47359 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbYLZOWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 09:22:30 -0500
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: jeremy@goop.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 4/4] x86: Move NMI back to interrupt stack
Date: Fri, 26 Dec 2008 16:22:24 +0200
Message-Id: <1230301344-570-5-git-send-email-avi@redhat.com>
In-Reply-To: <1230301344-570-1-git-send-email-avi@redhat.com>
References: <1230301344-570-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that interrupt stack switching is atomic, we can move the NMI handler
to the interrupt stack.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/entry_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 61c54d9..3d45880 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1496,7 +1496,7 @@ ENTRY(nmi)
 	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
 	movq %rsp,%rdi
 	movq $-1,%rsi
-	call do_nmi
+	call_in_irqstack do_nmi
 #ifdef CONFIG_TRACE_IRQFLAGS
 	/* paranoidexit; without TRACE_IRQS_OFF */
 	/* ebx:	no swapgs flag */
-- 
1.6.0.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbYLOQ42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbYLOQ42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 11:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYLOQ4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 11:56:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43459 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbYLOQ4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 11:56:20 -0500
Subject: [PATCH] x86: signal.c declare do_notify_resume before they get used
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 22:24:48 +0530
Message-Id: <1229360088.15326.3.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>

In asm/signal.h moved out do_notify_resume from __i386__ as it is common for both 32 and 64 bit.
---
 arch/x86/include/asm/signal.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/signal.h b/arch/x86/include/asm/signal.h
index 96ac44f..7761a5d 100644
--- a/arch/x86/include/asm/signal.h
+++ b/arch/x86/include/asm/signal.h
@@ -121,6 +121,10 @@ typedef unsigned long sigset_t;
 
 #ifndef __ASSEMBLY__
 
+# ifdef __KERNEL__
+extern void do_notify_resume(struct pt_regs *, void *, __u32);
+# endif /* __KERNEL__ */
+
 #ifdef __i386__
 # ifdef __KERNEL__
 struct old_sigaction {
@@ -141,8 +145,6 @@ struct k_sigaction {
 	struct sigaction sa;
 };
 
-extern void do_notify_resume(struct pt_regs *, void *, __u32);
-
 # else /* __KERNEL__ */
 /* Here we must cater to libcs that poke about in kernel headers.  */
 
-- 
1.5.5.1




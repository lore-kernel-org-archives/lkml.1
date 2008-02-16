Return-Path: <linux-kernel-owner+w=401wt.eu-S1759287AbYBPT5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbYBPT5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYBPT5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:57:06 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:37367 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbYBPT5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:57:05 -0500
Message-ID: <47B73FF4.6000804@tiscali.nl>
Date: Sat, 16 Feb 2008 20:56:36 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, hpa@zytor.com
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] [x86] arch/x86/kernel/signal_32.c: replace !likely(x)
 by likely(!x)
References: <47B7065B.8090209@tiscali.nl> <47B73963.1050702@tiscali.nl>
In-Reply-To: <47B73963.1050702@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> Roel Kluin wrote:
>> Replace !likely(x) by likely(!x)

> sorry, please ignore this patch

The patch below shouldn't change semantics.
---
replace !likely(x) by unlikely(!x)

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index caee1f0..c0fb075 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -303,7 +303,7 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs * regs, size_t frame_size)
 	 * If we are on the alternate signal stack and would overflow it, don't.
 	 * Return an always-bogus address instead so we will die with SIGSEGV.
 	 */
-	if (on_sig_stack(sp) && !likely(on_sig_stack(sp - frame_size)))
+	if (on_sig_stack(sp) && unlikely(!on_sig_stack(sp - frame_size)))
 		return (void __user *) -1L;
 
 	/* This is the X/Open sanctioned signal stack switching.  */

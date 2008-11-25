Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbYKYFmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbYKYFmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 00:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbYKYFmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 00:42:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40188 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbYKYFmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 00:42:40 -0500
Date: Tue, 25 Nov 2008 00:42:37 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Subject: [PATCH] use limited register constraint for setnz
Message-ID: <alpine.DEB.1.10.0811250040060.2977@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix in compiling

GCC can decide to use %dil when "r" is used, which is not valid for
setnz.

This bug was brought out by Stephen Rothwell's merging of the
branch tracer into linux-next.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/arch/x86/boot/tty.c b/arch/x86/boot/tty.c
index 0be77b3..c2121d2 100644
--- a/arch/x86/boot/tty.c
+++ b/arch/x86/boot/tty.c
@@ -74,7 +74,7 @@ static int kbd_pending(void)
 {
 	u8 pending;
 	asm volatile("int $0x16; setnz %0"
-		     : "=rm" (pending)
+		     : "=Qm" (pending)
 		     : "a" (0x0100));
 	return pending;
 }


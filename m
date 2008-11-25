Return-Path: <linux-kernel-owner+w=401wt.eu-S1752339AbYKYOVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbYKYOVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 09:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbYKYOVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 09:21:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51796 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbYKYOVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 09:21:33 -0500
Message-Id: <20081125142131.270469036@goodmis.org>
References: <20081125142041.038383632@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 25 Nov 2008 09:20:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Uros Bizjak <ubizjak@gmail.com>
Subject: [PATCH 1/1] use limited register constraint for setnz
Content-Disposition: inline; filename=0001-use-limited-register-constraint-for-setnz.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Impact: fix in compiling

GCC can decide to use %dil when "r" is used, which is not valid for
setnz.

This bug was brought out by Stephen Rothwell's merging of the
branch tracer into linux-next.

[ Thanks to Uros Bizjak for recommending 'q' over 'Q' ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/boot/tty.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/tty.c b/arch/x86/boot/tty.c
index 0be77b3..7e8e8b2 100644
--- a/arch/x86/boot/tty.c
+++ b/arch/x86/boot/tty.c
@@ -74,7 +74,7 @@ static int kbd_pending(void)
 {
 	u8 pending;
 	asm volatile("int $0x16; setnz %0"
-		     : "=rm" (pending)
+		     : "=qm" (pending)
 		     : "a" (0x0100));
 	return pending;
 }
-- 
1.5.6.5

-- 

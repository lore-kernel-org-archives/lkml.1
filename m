Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbYKLDLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbYKLDLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 22:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYKLDLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 22:11:41 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:36663 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYKLDLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 22:11:40 -0500
Message-ID: <491A496B.5010505@ct.jp.nec.com>
Date: Tue, 11 Nov 2008 19:11:39 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: ia32_signal: remove unnecessary padding
References: <491A48E9.8020909@ct.jp.nec.com>
In-Reply-To: <491A48E9.8020909@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Remove unnecessary paddings, this saves 4 bytes.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index bafc0b4..e886907 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -427,12 +427,10 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 		u16 poplmovl;
 		u32 val;
 		u16 int80;
-		u16 pad;
 	} __attribute__((packed)) code = {
 		0xb858,		 /* popl %eax ; movl $...,%eax */
 		__NR_ia32_sigreturn,
 		0x80cd,		/* int $0x80 */
-		0,
 	};
 
 	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
@@ -508,8 +506,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		u8 movl;
 		u32 val;
 		u16 int80;
-		u16 pad;
-		u8  pad2;
+		u8  pad;
 	} __attribute__((packed)) code = {
 		0xb8,
 		__NR_ia32_rt_sigreturn,
-- 
1.5.6


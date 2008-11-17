Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbYKQTMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbYKQTMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbYKQTLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:11:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61420 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbYKQTLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:11:46 -0500
Message-Id: <20081117191059.843727934@goodmis.org>
References: <20081117190948.619751203@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 17 Nov 2008 14:09:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/4] ftrace,ppc: fix test of branch link
Content-Disposition: inline; filename=0004-ftrace-ppc-fix-test-of-branch-link.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix positive failure of branch link on PPC

Paul Mackerras pointed out that the test to verify that the modify
code is a banch link is incorrect. It was testing the wrong bits.
This patch corrects the test.

Reported-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/kernel/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 81e338c..cc901b1 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -131,7 +131,7 @@ static int test_24bit_addr(unsigned long ip, unsigned long addr)
 
 static int is_bl_op(unsigned int op)
 {
-	return (op & 0xff000000) == 0x48000000;
+	return (op & 0xfc000003) == 0x48000001;
 }
 
 static int test_offset(unsigned long offset)
-- 
1.5.6.5

-- 

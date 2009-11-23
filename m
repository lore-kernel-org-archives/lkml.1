Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbZKWJI0 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 23 Nov 2009 04:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbZKWJI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:08:26 -0500
Received: from gw.wifiinternet.cz ([89.31.42.6]:49967 "EHLO monstr.eu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752804AbZKWJIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:08:25 -0500
X-Greylist: delayed 1579 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2009 04:08:12 EST
From: y@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: michal.simek@petalogix.com, wuzhangjin@gmail.com, mingo@elte.hu,
        rostedt@goodmis.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 2/5] microblaze: ftrace: enable HAVE_FUNCTION_TRACE_MCOUNT_TEST
Date: Mon, 23 Nov 2009 09:41:20 +0100
Message-Id: <1258965683-21302-3-git-send-email-y>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1258965683-21302-2-git-send-email-y>
References: <y>
 <1258965683-21302-1-git-send-email-y>
 <1258965683-21302-2-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Implement MCOUNT_TEST in asm code - it is faster than use
generic code

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/Kconfig         |    1 +
 arch/microblaze/kernel/mcount.S |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 18003ca..cccf3ad 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -7,6 +7,7 @@ config MICROBLAZE
 	def_bool y
 	select HAVE_LMB
 	select HAVE_FUNCTION_TRACER
+	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select USB_ARCH_HAS_EHCI
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 
diff --git a/arch/microblaze/kernel/mcount.S b/arch/microblaze/kernel/mcount.S
index a257a1b..97eef3e 100644
--- a/arch/microblaze/kernel/mcount.S
+++ b/arch/microblaze/kernel/mcount.S
@@ -85,6 +85,11 @@ ENTRY(ftrace_stub)
 ENTRY(_mcount)
 	SAVE_REGS
 	swi	r15, r1, 0;
+	/* MS: HAVE_FUNCTION_TRACE_MCOUNT_TEST begin of checking */
+	lwi	r5, r0, function_trace_stop;
+	bneid	r5, end;
+	nop;
+	/* MS: HAVE_FUNCTION_TRACE_MCOUNT_TEST end of checking */
 	/* MS: test function trace if is taken or not */
 	lwi	r20, r0, ftrace_trace_function;
 	addik	r6, r0, ftrace_stub;
-- 
1.5.5.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbZKNGgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbZKNGgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 01:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbZKNGgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 01:36:23 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:33554 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbZKNGgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 01:36:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NeGB907uLGGlZuAGEb+7w6ySubG5y9GK7iLxOfyGjRI0YAq1felsqMuKx27iHUcsa3
         85yqIA5Sqfwj7mGEUGzXhUPwZZGvEMsgELCdugb1z1nYj7vsPovhKqIAsRWTCilFsth3
         LlgVCfUfSPROxcsFyu9Iyu00AKzTHExazsAg0=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: rostedt@goodmis.org, Ralf Baechle <ralf@linux-mips.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>,
       "Maciej W . Rozycki" <macro@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, zhangfx@lemote.com, zhouqg@gmail.com
Subject: [PATCH v8 15/16] tracing: reserve $12(t0) for mcount-ra-address of gcc 4.5
Date: Sat, 14 Nov 2009 14:33:30 +0800
Message-Id: <5fac5676cfadccf569cab72094f365b130b181ed.1258177321.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <24733f375d853dd6dc44138c53f2f57493915d8f.1258177321.git.wuzhangjin@gmail.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1258177321.git.wuzhangjin@gmail.com>
 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1258177321.git.wuzhangjin@gmail.com>
 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1258177321.git.wuzhangjin@gmail.com>
 <ea337742d3ca7eec2825416041a6d4fa917d5cc4.1258177321.git.wuzhangjin@gmail.com>
 <7c7568247ad6cc109ec20387cfc3ca258d1d430f.1258177321.git.wuzhangjin@gmail.com>
 <3fcaffcfb3c8c8cd3015151ed5b7480ccaecde0f.1258177321.git.wuzhangjin@gmail.com>
 <48676d84140dbafd46e530611766121e18abc4ef.1258177321.git.wuzhangjin@gmail.com>
 <99ebd8fcb19e4cccd702fca966405ffc45f8540b.1258177321.git.wuzhangjin@gmail.com>
 <c1fe0d6822e98bc0ffd2dfee7a579fbbe21430e0.1258177321.git.wuzhangjin@gmail.com>
 <f3a54cef2de00885ee75a930b243083a716370bd.1258177321.git.wuzhangjin@gmail.com>
 <b98ca1b2048aeab8aac82ec8723ac729c2cd4b54.1258177321.git.wuzhangjin@gmail.com>
 <8a7987bba58526a0e156f531dba31d9a65d3d744.1258177321.git.wuzhangjin@gmail.com>
 <af765bca2a5f969f13de1b9f61744e6523d1afe8.1258177321.git.wuzhangjin@gmail.com>
 <24733f375d853dd6dc44138c53f2f57493915d8f.1258177321.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1258177321.git.wuzhangjin@gmail.com>
References: <cover.1258177321.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

A new option -mmcount-ra-address for gcc 4.5 have been sent by David
Daney <ddaney@caviumnetworks.com> in the thread "MIPS: Add option to
pass return address location to _mcount", which help to record the
location of the return address(ra) for the function graph tracer of MIPS
to hijack the return address easier and safer. that option used the
$12(t0) register by default, so, we reserve it for it, and use t1,t2,t3
instead of t0,t1,t2.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/kernel/mcount.S |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
index bdfef2c..522e91c 100644
--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -65,8 +65,8 @@ NESTED(ftrace_caller, PT_SIZE, ra)
 _mcount:
 	b	ftrace_stub
 	 nop
-	lw	t0, function_trace_stop
-	bnez	t0, ftrace_stub
+	lw	t1, function_trace_stop
+	bnez	t1, ftrace_stub
 	 nop
 
 	MCOUNT_SAVE_REGS
@@ -93,21 +93,21 @@ ftrace_stub:
 #else	/* ! CONFIG_DYNAMIC_FTRACE */
 
 NESTED(_mcount, PT_SIZE, ra)
-	lw	t0, function_trace_stop
-	bnez	t0, ftrace_stub
+	lw	t1, function_trace_stop
+	bnez	t1, ftrace_stub
 	 nop
-	PTR_LA	t0, ftrace_stub
-	PTR_L	t1, ftrace_trace_function /* Prepare t1 for (1) */
-	bne	t0, t1, static_trace
+	PTR_LA	t1, ftrace_stub
+	PTR_L	t2, ftrace_trace_function /* Prepare t2 for (1) */
+	bne	t1, t2, static_trace
 	 nop
 
 #ifdef	CONFIG_FUNCTION_GRAPH_TRACER
-	PTR_L	t2, ftrace_graph_return
-	bne	t0, t2, ftrace_graph_caller
+	PTR_L	t3, ftrace_graph_return
+	bne	t1, t3, ftrace_graph_caller
 	 nop
-	PTR_LA	t0, ftrace_graph_entry_stub
-	PTR_L	t2, ftrace_graph_entry
-	bne	t0, t2, ftrace_graph_caller
+	PTR_LA	t1, ftrace_graph_entry_stub
+	PTR_L	t3, ftrace_graph_entry
+	bne	t1, t3, ftrace_graph_caller
 	 nop
 #endif
 	b	ftrace_stub
@@ -117,7 +117,7 @@ static_trace:
 	MCOUNT_SAVE_REGS
 
 	move	a0, ra		/* arg1: next ip, selfaddr */
-	jalr	t1	/* (1) call *ftrace_trace_function */
+	jalr	t2		/* (1) call *ftrace_trace_function */
 	 move	a1, AT		/* arg2: the caller's next ip, parent */
 
 	MCOUNT_RESTORE_REGS
-- 
1.6.2.1


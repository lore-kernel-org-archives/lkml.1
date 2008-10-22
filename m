Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbYJVR0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbYJVR0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbYJVR03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:26:29 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:22258 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbYJVR01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=lm2Uykks+AknMdoMZg/UI1mqQ+9XAGTUDlfz7s2aL0RmX0Rofy5XcWnM7oQr0ZC2oc
         h8/WcS5w7ZhwH4KFntIOyYF33Uq2roBOw9LOycPYRp5tso5slz3bgIIeIgQoKUPJiLBQ
         gdjK9c4APKotaMNThkvDJsTpeIswAjk+63OeE=
Message-ID: <48FF623F.3010507@gmail.com>
Date: Wed, 22 Oct 2008 19:26:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH][RESEND] tracing/ftrace: Make boot tracer select the sched_switch
 tracer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the boot tracer is selected but not the sched_switch,
there will be a build failure:

kernel/built-in.o: In function `boot_trace_init':
trace_boot.c:(.text+0x5ee38): undefined reference to `sched_switch_trace'
kernel/built-in.o: In function `disable_boot_trace':
(.text+0x5eee1): undefined reference to `tracing_stop_cmdline_record'
kernel/built-in.o: In function `enable_boot_trace':
(.text+0x5ef11): undefined reference to `tracing_start_cmdline_record'

This patch fixes it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 396aea1..d09c693 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -125,6 +125,7 @@ config BOOT_TRACER
 	depends on HAVE_FTRACE
 	depends on DEBUG_KERNEL
 	select TRACING
+	select CONTEXT_SWITCH_TRACER
 	help
 	 This tracer helps developers to optimize boot times: it records
 	 the timings of the initcalls. Its aim is to be parsed by the

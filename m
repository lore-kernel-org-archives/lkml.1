Return-Path: <linux-kernel-owner+w=401wt.eu-S1760745AbYJKUwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745AbYJKUwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 16:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbYJKUwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 16:52:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:8242 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbYJKUwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 16:52:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=qiGvn8zLiYOweMEiAinnMiEwbMcWEt/vwjtn0nqgtfSFlxUAjxQDRV9x5GlCYXv4MJ
         gsKEhhGnJAkjw2SwffBgvsPK7gnkdPa+8K4Nc5LtGfCbiBvdy6FMTSO2114RnJzQ3wLp
         DPl3kWhIeJUl4hei0N60+oo+zzzL5qnNGli7E=
Message-ID: <48F111F0.3000704@gmail.com>
Date: Sat, 11 Oct 2008 22:52:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] tracing/ftrace: Make boot tracer select the sched_switch
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

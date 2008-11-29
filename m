Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYK2DNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYK2DNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 22:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYK2DMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 22:12:52 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:24541 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbYK2DMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 22:12:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=kF787jgTmeZw/ft0IBbizLXrPfimZlkQjR2pdtZas1kVoXTW5kRhJj6vIQkzjLlnrD
         kgxp2DS880mBi2ZFQIAsWZkAGpOfghJXeW/ny8JEl2+TX34vTvJPimqpgytNzhmYFVHm
         8eFfg43fPrqxKcFrF050pyrWGylQvggdSYuTg=
Message-ID: <4930B32E.6060403@gmail.com>
Date: Sat, 29 Nov 2008 04:12:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/branch-tracer: include missing irqflags.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix build error on branch tracer

This should fix a build error reported on alpha in linux-next:

 CC      kernel/trace/trace_branch.o
kernel/trace/trace_branch.c: In function 'probe_likely_condition':
kernel/trace/trace_branch.c:44: error: implicit declaration of function 'raw_local_irq_save'
kernel/trace/trace_branch.c:76: error: implicit declaration of function 'raw_local_irq_restore'

Unfortunately, I can't test it since I don't have any Alpha build environment.

Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 877ee88..bc97275 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -6,6 +6,7 @@
 #include <linux/kallsyms.h>
 #include <linux/seq_file.h>
 #include <linux/spinlock.h>
+#include <linux/irqflags.h>
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>

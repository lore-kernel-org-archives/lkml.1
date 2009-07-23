Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbZGWVC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbZGWVC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 17:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbZGWVCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 17:02:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41526 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbZGWVCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 17:02:22 -0400
Message-Id: <20090723210220.250087251@goodmis.org>
References: <20090723210047.294710482@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 17:00:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/4] tracing: show proper address for trace-printk format
Content-Disposition: inline; filename=0001-tracing-show-proper-address-for-trace-printk-format.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Since the trace_printk may use pointers to the format fields
in the buffer, they are exported via debugfs/tracing/printk_formats.
This is used by utilities that read the ring buffer in binary format.
It helps the utilities map the address of the format in the binary
buffer to what the printf format looks like.

Unfortunately, the way the output code works, it exports the address
of the pointer to the format address, and not the format address
itself. This makes the file totally useless in trying to figure
out what format string a binary address belongs to.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 7b62781..687699d 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -176,7 +176,7 @@ static int t_show(struct seq_file *m, void *v)
 	const char *str = *fmt;
 	int i;
 
-	seq_printf(m, "0x%lx : \"", (unsigned long)fmt);
+	seq_printf(m, "0x%lx : \"", *(unsigned long *)fmt);
 
 	/*
 	 * Tabs and new lines need to be converted.
-- 
1.6.3.3

-- 

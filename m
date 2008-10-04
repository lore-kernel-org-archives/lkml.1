Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbYJDUmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbYJDUmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 16:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYJDUmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 16:42:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:42265 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYJDUmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 16:42:40 -0400
Date: Sat, 4 Oct 2008 13:42:27 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "=?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker" <fweisbec@gmail.com>,
       mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [patch] fix printk format typo in boot ftracer.
Message-ID: <20081004134227.465fa20c@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When printing nanoseconds, the right printk format string is %09 not %06...

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index a7efe35..d0a5e50 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -62,14 +62,14 @@ static enum print_line_t initcall_print_line(struct trace_iterator *iter)
 	struct timespec rettime = ktime_to_timespec(it->rettime);
 
 	if (entry->type == TRACE_BOOT) {
-		ret = trace_seq_printf(s, "[%5ld.%06ld] calling  %s @ %i\n",
+		ret = trace_seq_printf(s, "[%5ld.%09ld] calling  %s @ %i\n",
 					  calltime.tv_sec,
 					  calltime.tv_nsec,
 					  it->func, it->caller);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 
-		ret = trace_seq_printf(s, "[%5ld.%06ld] initcall %s "
+		ret = trace_seq_printf(s, "[%5ld.%09ld] initcall %s "
 					  "returned %d after %lld msecs\n",
 					  rettime.tv_sec,
 					  rettime.tv_nsec,

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

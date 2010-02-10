Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab0BJQXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 11:23:50 -0500
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:34616 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab0BJQXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:23:49 -0500
Date: Wed, 10 Feb 2010 17:23:47 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tracing/kprobes: fix probe parsing
Message-ID: <20100210162346.GA6933@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Trying to add a probe like

echo p:myprobe 0x10000 > /sys/kernel/debug/tracing/kprobe_events

will fail since the wrong pointer is passed to strict_strtoul
when trying to convert the address to an unsigned long.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/trace/trace_kprobe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -689,7 +689,7 @@ static int create_trace_probe(int argc, 
 			return -EINVAL;
 		}
 		/* an address specified */
-		ret = strict_strtoul(&argv[0][2], 0, (unsigned long *)&addr);
+		ret = strict_strtoul(&argv[1][0], 0, (unsigned long *)&addr);
 		if (ret) {
 			pr_info("Failed to parse address.\n");
 			return ret;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761794AbYFMJA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761794AbYFMJA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 05:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbYFMJAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 05:00:21 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:51695 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206AbYFMJAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 05:00:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=DK5APdCElP0DCwuB9f4gL92FJlYRRd9b8w4PN6xr9+lTBSqBFuHBQ+VouZsEfPuTE1
         K/nnJcQz/1KmCUsQy2085sL3e8MORauOGtZcxMI3c+Ufw1zodd5k22tYxEpQcjI3yfsM
         8rI9TH2fTbGZpWC3VXy+0M3z4mZ1a4WGw+aiY=
Date: Fri, 13 Jun 2008 11:00:14 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] stacktrace: print_stack_trace() cleanup
Message-ID: <20080613090014.GC3139@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 13 Jun 2008 10:05:26 +0200
Subject: [PATCH] stacktrace: print_stack_trace() cleanup

This admittedly doesn't have too many benefits, these are the two I can
think of: shorter code and better atomicity with regards to printk().

(It's been tested with the backtrace self-test code on i386 and x86_64.)

Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 kernel/stacktrace.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index b71816e..2ee264b 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -11,14 +11,11 @@
 
 void print_stack_trace(struct stack_trace *trace, int spaces)
 {
-	int i, j;
+	int i;
 
 	for (i = 0; i < trace->nr_entries; i++) {
-		unsigned long ip = trace->entries[i];
-
-		for (j = 0; j < spaces + 1; j++)
-			printk(" ");
-		print_ip_sym(ip);
+		printk("%*c", 1 + spaces, ' ');
+		print_ip_sym(trace->entries[i]);
 	}
 }
 
-- 
1.5.4.1


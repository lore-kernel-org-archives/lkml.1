Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbYIRThb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbYIRThb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 15:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbYIRThY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 15:37:24 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:57432 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbYIRThY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 15:37:24 -0400
Date: Thu, 18 Sep 2008 12:37:20 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] printk: Print cpuid along with the timestamp with
	CONFIG_PRINTK_TIME
Message-ID: <20080918193720.GA21915@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found it useful to have the cpuid of the printing cpu along with the
timestamp -- especially while debugging hangs during bootups.

I don't know why this hasn't been implemened in the kernel yet, and
cannot think of a strong reason not to have it.  Yes, the cpuid prefix will
take 5 more characters per line,  but having  the cpuid info is worth it,
I think.

Thanks,
Kiran

---


Add cpuid information to printk if CONFIG_PRINTK_TIME is enabled.
This information is useful to debug hangs and bootup issues.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>

Index: linux-git/kernel/printk.c
===================================================================
--- linux-git.orig/kernel/printk.c	2008-09-16 15:37:48.000000000 -0700
+++ linux-git/kernel/printk.c	2008-09-18 12:27:10.489662938 -0700
@@ -739,9 +739,10 @@ asmlinkage int vprintk(const char *fmt, 
 
 				t = cpu_clock(printk_cpu);
 				nanosec_rem = do_div(t, 1000000000);
-				tlen = sprintf(tbuf, "[%5lu.%06lu] ",
+				tlen = sprintf(tbuf, "[%5lu.%06lu:%d] ",
 						(unsigned long) t,
-						nanosec_rem / 1000);
+						nanosec_rem / 1000,
+						printk_cpu);
 
 				for (tp = tbuf; tp < tbuf + tlen; tp++)
 					emit_log_char(*tp);

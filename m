Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbYH0PST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbYH0PST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 11:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYH0PSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 11:18:09 -0400
Received: from flusers.ccur.com ([12.192.68.2]:42171 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752967AbYH0PSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 11:18:09 -0400
Date: Wed, 27 Aug 2008 11:17:59 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] shrink printk timestamp field
Message-ID: <20080827151759.GA10678@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shrink the printk timestamp field.

Keep the printk timestamp from occupying more of the
scarce, 80-column console line space than it really needs.

We eliminate the excessive whitespace the field added to
the line, and reduce timestamp precision from six digits
(usecs) to three digits (msecs).  msecs seems adequate
for the purpose of tracking boot sequence timing issues.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.27-rc4-git4/kernel/printk.c
===================================================================
--- 2.6.27-rc4-git4.orig/kernel/printk.c	2008-08-26 18:23:03.000000000 -0400
+++ 2.6.27-rc4-git4/kernel/printk.c	2008-08-26 18:23:49.000000000 -0400
@@ -739,9 +739,9 @@
 
 				t = cpu_clock(printk_cpu);
 				nanosec_rem = do_div(t, 1000000000);
-				tlen = sprintf(tbuf, "[%5lu.%06lu] ",
+				tlen = sprintf(tbuf, "[%3lu.%03lu] ",
 						(unsigned long) t,
-						nanosec_rem / 1000);
+						nanosec_rem / 1000000);
 
 				for (tp = tbuf; tp < tbuf + tlen; tp++)
 					emit_log_char(*tp);

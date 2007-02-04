Return-Path: <linux-kernel-owner+w=401wt.eu-S1752103AbXBDGWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbXBDGWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 01:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXBDGWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 01:22:14 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:61824 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103AbXBDGWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 01:22:14 -0500
Date: Sun, 4 Feb 2007 01:22:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] kernel/time/clocksource.c needs struct task_struct on m68k
Message-ID: <20070204062211.GA10674@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 01:14:38 up 1 day, 20:22,  2 users,  load average: 1.01, 1.05, 1.03
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/time/clocksource.c needs struct task_struct on m68k.

Because it uses spin_unlock_irq(), which, on m68k, uses hardirq_count(), which
uses preempt_count(), which needs to dereference struct task_struct, we
have to include sched.h. Because it would cause a loop inclusion, we
cannot include sched.h in any other of asm-m68k/system.h,
linux/thread_info.h, linux/hardirq.h, which leaves this ugly include in
a C file as the only simple solution.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -28,6 +28,7 @@
 #include <linux/sysdev.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
 
 /* XXX - Would like a better way for initializing curr_clocksource */
 extern struct clocksource clocksource_jiffies;
-- 
OpenPGP public key:              http://krystal.dyndns.org:8080/key/compudj.gpg
Key fingerprint:     8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68 

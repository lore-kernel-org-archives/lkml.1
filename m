Return-Path: <linux-kernel-owner+w=401wt.eu-S1422890AbXCGRTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422890AbXCGRTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422908AbXCGRSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:18:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422890AbXCGRSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:18:09 -0500
Message-Id: <20070307171628.356761999@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:12:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       mathieu.desnoyers@polymtl.ca, zippel@linux-m68k.org, tglx@linutronix.de,
       mingo@elte.hu
Subject: [patch 088/101] kernel/time/clocksource.c needs struct task_struct on m68k
Content-Disposition: inline; filename=kernel-time-clocksource.c-needs-struct-task_struct-on-m68k.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

kernel/time/clocksource.c needs struct task_struct on m68k.

Because it uses spin_unlock_irq(), which, on m68k, uses hardirq_count(), which
uses preempt_count(), which needs to dereference struct task_struct, we
have to include sched.h. Because it would cause a loop inclusion, we
cannot include sched.h in any other of asm-m68k/system.h,
linux/thread_info.h, linux/hardirq.h, which leaves this ugly include in
a C file as the only simple solution.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/clocksource.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.20.1.orig/kernel/time/clocksource.c
+++ linux-2.6.20.1/kernel/time/clocksource.c
@@ -28,6 +28,7 @@
 #include <linux/sysdev.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
 
 /* XXX - Would like a better way for initializing curr_clocksource */
 extern struct clocksource clocksource_jiffies;

--

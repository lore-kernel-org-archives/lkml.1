Return-Path: <linux-kernel-owner+w=401wt.eu-S1761447AbYBTSrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761447AbYBTSrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYBTSrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:47:14 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:10835 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbYBTSrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:47:13 -0500
Message-ID: <47BC75B0.6070900@ct.jp.nec.com>
Date: Wed, 20 Feb 2008 10:47:12 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] x86_32: add power management line in /proc/cpuinfo
References: <47BC746F.2000608@ct.jp.nec.com>
In-Reply-To: <47BC746F.2000608@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Change /proc/cpuinfo. It will look like x86_64's.
'power management' line is added and power management information
will be printed at the line.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/cpu/proc.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 9bc3b04..fd3823a 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -94,7 +94,13 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
 			seq_printf(m, " %s", x86_cap_flags[i]);
 
-	for (i = 0; i < 32; i++)
+	seq_printf(m, "\nbogomips\t: %lu.%02lu\n",
+		   c->loops_per_jiffy/(500000/HZ),
+		   (c->loops_per_jiffy/(5000/HZ)) % 100);
+	seq_printf(m, "clflush size\t: %u\n", c->x86_clflush_size);
+
+	seq_printf(m, "power management:");
+	for (i = 0; i < 32; i++) {
 		if (c->x86_power & (1 << i)) {
 			if (i < ARRAY_SIZE(x86_power_flags) &&
 			    x86_power_flags[i])
@@ -104,11 +110,9 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 			else
 				seq_printf(m, " [%d]", i);
 		}
+	}
 
-	seq_printf(m, "\nbogomips\t: %lu.%02lu\n",
-		   c->loops_per_jiffy/(500000/HZ),
-		   (c->loops_per_jiffy/(5000/HZ)) % 100);
-	seq_printf(m, "clflush size\t: %u\n\n", c->x86_clflush_size);
+	seq_printf(m, "\n\n");
 
 	return 0;
 }
-- 
1.5.3.8



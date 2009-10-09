Return-Path: <linux-kernel-owner+w=401wt.eu-S1760755AbZJIKlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755AbZJIKlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 06:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760746AbZJIKlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 06:41:03 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:40690 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760745AbZJIKlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 06:41:02 -0400
Date: Fri, 9 Oct 2009 12:41:30 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Christoph Hellwig <hch@lst.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] IRQ: Change __softirq_pending to unsigned int in
	asm-generic/hardirq.h.
Message-ID: <20091009104130.GB619@linux-mips.org>
References: <1255013172-31599-1-git-send-email-wuzhangjin@gmail.com> <alpine.LFD.2.01.0910080755390.3432@localhost.localdomain> <20091009102814.GA619@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009102814.GA619@linux-mips.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the beginnings in aafe4dbed0bf6cbdb2e9f03e1d42f8a540d8541d
include/asm-generic/hardirq.h defined __softirq_pending as unsigned long
which is different from other architectures for no apparent good reason
and was causing the following warning:

kernel/time/tick-sched.c: In function 'tick_nohz_stop_sched_tick':
kernel/time/tick-sched.c:261: warning: format '%02x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'

Reported and initial patch by Wu Zhangjin <wuzhangjin@gmail.com>.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---
Tested on a big endian 64-bit MIPS SMP system.

 include/asm-generic/hardirq.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/hardirq.h b/include/asm-generic/hardirq.h
index 23bb4da..62f5908 100644
--- a/include/asm-generic/hardirq.h
+++ b/include/asm-generic/hardirq.h
@@ -6,7 +6,7 @@
 #include <linux/irq.h>
 
 typedef struct {
-	unsigned long __softirq_pending;
+	unsigned int __softirq_pending;
 } ____cacheline_aligned irq_cpustat_t;
 
 #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZFJDd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZFJDd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbZFJDdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:33:10 -0400
Received: from kroah.org ([198.145.64.141]:56553 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbZFJDdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:33:09 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:40 2009
Message-Id: <20090610002340.572069062@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:13:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 04/60] sparc64: Fix smp_callin() locking.
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=sparc64-fix-smp_callin-locking.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit 8e255baa449df3049a8827a7f1f4f12b6921d0d1 ]

Interrupts must be disabled when taking the IPI lock.

Caught by lockdep.

Reported-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc64/kernel/smp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -118,9 +118,9 @@ void __cpuinit smp_callin(void)
 	while (!cpu_isset(cpuid, smp_commenced_mask))
 		rmb();
 
-	ipi_call_lock();
+	ipi_call_lock_irq();
 	cpu_set(cpuid, cpu_online_map);
-	ipi_call_unlock();
+	ipi_call_unlock_irq();
 
 	/* idle thread is expected to have preempt disabled */
 	preempt_disable();



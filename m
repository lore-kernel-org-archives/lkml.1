Return-Path: <linux-kernel-owner+w=401wt.eu-S935458AbXEUTtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935458AbXEUTtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934070AbXEUT3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:29:07 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52632 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934057AbXEUT3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:29:04 -0400
Message-Id: <20070521191750.635243000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:17:06 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>,
       bunk@stusta.de
Subject: [patch 54/69] SPARC64: Add missing cpus_empty() check in hypervisor xcall handling.
Content-Disposition: inline; filename=sparc64-add-missing-cpus_empty-check-in-hypervisor-xcall-handling.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David Miller <davem@davemloft.net>

---
 arch/sparc64/kernel/smp.c |    3 +++
 1 file changed, 3 insertions(+)

--- linux-2.6.21.1.orig/arch/sparc64/kernel/smp.c
+++ linux-2.6.21.1/arch/sparc64/kernel/smp.c
@@ -566,6 +566,9 @@ static void hypervisor_xcall_deliver(u64
 	unsigned long flags, status;
 	int cnt, retries, this_cpu, prev_sent, i;
 
+	if (cpus_empty(mask))
+		return;
+
 	/* We have to do this whole thing with interrupts fully disabled.
 	 * Otherwise if we send an xcall from interrupt context it will
 	 * corrupt both our mondo block and cpu list state.

-- 

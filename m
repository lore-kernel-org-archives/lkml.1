Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbZF2Dn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbZF2Dn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 23:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZF2Dnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 23:43:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54904 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbZF2Dns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 23:43:48 -0400
Date: Mon, 29 Jun 2009 13:43:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Mike Travis <travis@sgi.com>
Subject: linux-next: manual merge of the rr tree with Linus' tree
Message-Id: <20090629134346.62f043c0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
arch/powerpc/platforms/powermac/setup.c between commit
7ccbe504b5ee766d33211a507189a06f3079b29b ("powerpc/pmac: Fix issues with
PowerMac "PowerSurge" SMP") from Linus' tree and commit
67e33aa4710019a5ee52979f7a9c6458729ab2ab
("cpumask:use-cpumap-accessors-powerpc") from the rr tree.

The code modified by the latter was moved to
arch/powerpc/platforms/powermac/smp.c by the former, so I applied the
latter change to this other file (see below).

There is another use of cpu_set in this file as well (which I did not
change).
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
index 6d4da7b..da12c48 100644
--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -952,7 +952,7 @@ void __init pmac_setup_smp(void)
 		int cpu;
 
 		for (cpu = 1; cpu < 4 && cpu < NR_CPUS; ++cpu)
-			cpu_set(cpu, cpu_possible_map);
+			set_cpu_possible(cpu, true);
 		smp_ops = &psurge_smp_ops;
 	}
 #endif /* CONFIG_PPC32 */

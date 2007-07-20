Return-Path: <linux-kernel-owner+w=401wt.eu-S1765064AbXGTVYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765064AbXGTVYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbXGTVYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:24:03 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43108 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbXGTVYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:24:01 -0400
Date: Fri, 20 Jul 2007 23:24:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/7] i386: fix section mismatch warning in smpboot.c
Message-ID: <20070720212454.GA25064@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: vmlinux.o(.text+0xf22d): Section mismatch: reference to .init.data:cpu_llc_id (between 'set_cpu_sibling_map' and 'initialize_secondary')
WARNING: vmlinux.o(.text+0xf23b): Section mismatch: reference to .init.data:cpu_llc_id (between 'set_cpu_sibling_map' and 'initialize_secondary')

set_cpu_sibling_map is used either from __init or __cpuinit context,
so declaring this function __cpuinit makes this warning go away.
cpu_llc_id are declared __cpuinitdata so this matches the new definition
of set_cpu_sibling_map.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/i386/kernel/smpboot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/i386/kernel/smpboot.c b/arch/i386/kernel/smpboot.c
index 5910d3f..e4f61d1 100644
--- a/arch/i386/kernel/smpboot.c
+++ b/arch/i386/kernel/smpboot.c
@@ -308,7 +308,7 @@ cpumask_t cpu_coregroup_map(int cpu)
 /* representing cpus for which sibling maps can be computed */
 static cpumask_t cpu_sibling_setup_map;
 
-void set_cpu_sibling_map(int cpu)
+void __cpuinit set_cpu_sibling_map(int cpu)
 {
 	int i;
 	struct cpuinfo_x86 *c = cpu_data;
-- 
1.5.1.rc3.g84b7-dirty


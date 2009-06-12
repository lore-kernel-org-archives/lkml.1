Return-Path: <linux-kernel-owner+w=401wt.eu-S932993AbZFLNiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993AbZFLNiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764031AbZFLNbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:04 -0400
Received: from ozlabs.org ([203.10.76.45]:55283 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761259AbZFLNbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:31:03 -0400
CC: linux-kernel@vger.kernel.org
To: Hirokazu Takata <takata@linux-m32r.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:33:14 +0930
Subject: [PATCH 2/13] cpumask: Use accessors for cpu_*_mask: m32r
Cc: Mike Travis <travis@sgi.com>
Message-Id: <20090612133105.28122DDDA1@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the accessors rather than frobbing bits directly (the new versions
are const).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/m32r/kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.28.orig/arch/m32r/kernel/smpboot.c
+++ linux-2.6.28/arch/m32r/kernel/smpboot.c
@@ -183,7 +183,7 @@ void __init smp_prepare_cpus(unsigned in
 	for (phys_id = 0 ; phys_id < nr_cpu ; phys_id++)
 		physid_set(phys_id, phys_cpu_present_map);
 #ifndef CONFIG_HOTPLUG_CPU
-	cpu_present_map = cpu_possible_map;
+	init_cpu_present(&cpu_possible_map);
 #endif
 
 	show_mp_info(nr_cpu);


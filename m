Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbXD2LFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbXD2LFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbXD2LAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:00:55 -0400
Received: from ns.suse.de ([195.135.220.2]:52067 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbXD2KxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:04 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: "Yinghai Lu" <yinghai.lu@amd.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@muc.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [14/48] x86_64: remove extra smp_processor_id calling
Message-Id: <20070429105302.89BF215108@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Yinghai Lu" <yinghai.lu@amd.com>

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/io_apic.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/arch/x86_64/kernel/io_apic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/io_apic.c
+++ linux/arch/x86_64/kernel/io_apic.c
@@ -1407,8 +1407,7 @@ static void irq_complete_move(unsigned i
 
 	vector = ~get_irq_regs()->orig_rax;
 	me = smp_processor_id();
-	if ((vector == cfg->vector) &&
-	    cpu_isset(smp_processor_id(), cfg->domain)) {
+	if ((vector == cfg->vector) && cpu_isset(me, cfg->domain)) {
 		cpumask_t cleanup_mask;
 
 		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);

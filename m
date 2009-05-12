Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbZELXcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbZELXcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbZELX1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:27:45 -0400
Received: from 75-149-38-2-SFBA.hfc.comcastbusiness.net ([75.149.38.2]:36265
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758102AbZELX1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:27:44 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 1/6] xen: set cpu_callout_mask to make mtrr work
Date: Tue, 12 May 2009 16:27:39 -0700
Message-Id: <1242170864-13560-2-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242170864-13560-1-git-send-email-jeremy@goop.org>
References: <1242170864-13560-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

The mtrr code uses num_booting_cpus() to manage its corrdinated mtrr update,
which in turn depends on cpu_callout_mask.

[ Impact: bugfix; make /proc/mtrr writes work in Xen ]
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/smp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 429834e..4706af7 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -297,6 +297,8 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
 	xen_setup_timer(cpu);
 	xen_init_lock_cpu(cpu);
 
+	cpumask_set_cpu(cpu, cpu_callout_mask);
+
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 
 	/* make sure interrupts start blocked */
-- 
1.6.0.6


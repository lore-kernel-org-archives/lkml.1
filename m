Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbYFIOWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbYFIOWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760651AbYFIOTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:19:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbYFIOTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:19:00 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: [PATCH 13/15] x86: remove cpu from maps
Date: Mon,  9 Jun 2008 11:16:56 -0300
Message-Id: <1213021018-14159-14-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213021018-14159-13-git-send-email-gcosta@redhat.com>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
 <1213021018-14159-2-git-send-email-gcosta@redhat.com>
 <1213021018-14159-3-git-send-email-gcosta@redhat.com>
 <1213021018-14159-4-git-send-email-gcosta@redhat.com>
 <1213021018-14159-5-git-send-email-gcosta@redhat.com>
 <1213021018-14159-6-git-send-email-gcosta@redhat.com>
 <1213021018-14159-7-git-send-email-gcosta@redhat.com>
 <1213021018-14159-8-git-send-email-gcosta@redhat.com>
 <1213021018-14159-9-git-send-email-gcosta@redhat.com>
 <1213021018-14159-10-git-send-email-gcosta@redhat.com>
 <1213021018-14159-11-git-send-email-gcosta@redhat.com>
 <1213021018-14159-12-git-send-email-gcosta@redhat.com>
 <1213021018-14159-13-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

during cpu disable, take cpus out of all maps in i386, instead
of just the online map.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6316d30..f6b99b6 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1321,13 +1321,11 @@ __init void prefill_possible_map(void)
 static void __ref remove_cpu_from_maps(int cpu)
 {
 	cpu_clear(cpu, cpu_online_map);
-#ifdef CONFIG_X86_64
 	cpu_clear(cpu, cpu_callout_map);
 	cpu_clear(cpu, cpu_callin_map);
 	/* was set by cpu_init() */
 	clear_bit(cpu, (unsigned long *)&cpu_initialized);
 	numa_remove_cpu(cpu);
-#endif
 }
 
 int __cpu_disable(void)
-- 
1.5.4.5


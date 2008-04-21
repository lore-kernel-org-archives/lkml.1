Return-Path: <linux-kernel-owner+w=401wt.eu-S1759613AbYDUIwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613AbYDUIwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758686AbYDUIvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:51:25 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:58485 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758710AbYDUIvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:51:24 -0400
Date: Mon, 21 Apr 2008 11:50:55 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: make {,un}map_cpu_to_logical_apicid() static
Message-ID: <20080421085055.GZ26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

{,un}map_cpu_to_logical_apicid() can again become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/kernel/smpboot.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

611727c3d07e2bfb612995ad09a69d444eb11488 diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index e60b985..679c0ca 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -186,7 +186,7 @@ static void unmap_cpu_to_node(int cpu)
 u8 cpu_2_logical_apicid[NR_CPUS] __read_mostly =
 					{ [0 ... NR_CPUS-1] = BAD_APICID };
 
-void map_cpu_to_logical_apicid(void)
+static void map_cpu_to_logical_apicid(void)
 {
 	int cpu = smp_processor_id();
 	int apicid = logical_smp_processor_id();
@@ -199,7 +199,7 @@ void map_cpu_to_logical_apicid(void)
 	map_cpu_to_node(cpu, node);
 }
 
-void unmap_cpu_to_logical_apicid(int cpu)
+static void unmap_cpu_to_logical_apicid(int cpu)
 {
 	cpu_2_logical_apicid[cpu] = BAD_APICID;
 	unmap_cpu_to_node(cpu);

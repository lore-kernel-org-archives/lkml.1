Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbYJWCTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbYJWCTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756719AbYJWCI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43387 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754671AbYJWCIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:32 -0400
Message-Id: <20081023020831.698704000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:53 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 27/35] cpumask: accessors to manipulate possible/present/online/active maps From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:cpumap-accessors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we are moving to const cpumask pointers for the maps, we need a
way to legitimately access them.  Simple accessors work well.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |    9 +++++++++
 kernel/cpu.c            |   41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
@@ -586,6 +586,15 @@ extern cpumask_t cpu_active_map;
 #define cpu_active(cpu)		((cpu) == 0)
 #endif
 
+/* Wrappers to manipulate otherwise-constant masks. */
+void set_cpu_possible(unsigned int cpu, bool possible);
+void set_cpu_present(unsigned int cpu, bool present);
+void set_cpu_online(unsigned int cpu, bool online);
+void set_cpu_active(unsigned int cpu, bool active);
+void init_cpu_present(const struct cpumask *src);
+void init_cpu_possible(const struct cpumask *src);
+void init_cpu_online(const struct cpumask *src);
+
 #define cpu_is_offline(cpu)	unlikely(!cpu_online(cpu))
 
 #define for_each_possible_cpu(cpu) for_each_cpu((cpu), &cpu_possible_map)
--- linux-2.6.28.orig/kernel/cpu.c
+++ linux-2.6.28/kernel/cpu.c
@@ -500,3 +500,44 @@ const unsigned long cpu_bit_bitmap[BITS_
 #endif
 };
 EXPORT_SYMBOL_GPL(cpu_bit_bitmap);
+
+void set_cpu_possible(unsigned int cpu, bool possible)
+{
+	if (possible)
+		cpumask_set_cpu(cpu, &cpu_possible_map);
+	else
+		cpumask_clear_cpu(cpu, &cpu_possible_map);
+}
+void set_cpu_present(unsigned int cpu, bool present)
+{
+	if (present)
+		cpumask_set_cpu(cpu, &cpu_present_map);
+	else
+		cpumask_clear_cpu(cpu, &cpu_present_map);
+}
+void set_cpu_online(unsigned int cpu, bool online)
+{
+	if (online)
+		cpumask_set_cpu(cpu, &cpu_online_map);
+	else
+		cpumask_clear_cpu(cpu, &cpu_online_map);
+}
+void set_cpu_active(unsigned int cpu, bool active)
+{
+	if (active)
+		cpumask_set_cpu(cpu, &cpu_active_map);
+	else
+		cpumask_clear_cpu(cpu, &cpu_active_map);
+}
+void init_cpu_present(const struct cpumask *src)
+{
+	cpumask_copy(&cpu_present_map, src);
+}
+void init_cpu_possible(const struct cpumask *src)
+{
+	cpumask_copy(&cpu_possible_map, src);
+}
+void init_cpu_online(const struct cpumask *src)
+{
+	cpumask_copy(&cpu_online_map, src);
+}

-- 

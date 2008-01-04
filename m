Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbYADWFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbYADWFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbYADWFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:05:03 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:54152 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbYADWFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:05:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=rGK2kV7K0fVlNGz91oDncfUlDJycriGxJ7C+tJFEGydNV5/JDCs7NBT+VVjT7aquJALwkoXs/62nzWqku0aklgPzpxfFXOXfPpl4AAvbPPYzTrjCiPpKaNwpvwcNzBHKzvsgi315d3flyhHr2qBbVADl1bP3ysQl5oGMT8FC8nU=
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: little fix in 'include/asm-x86/topology.h'
Date: Fri, 4 Jan 2008 23:04:57 +0100
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801042304.58071.mboton@gmail.com>
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before 'topology_32.h' and 'topology_64.h' were unified, topology defines in a
X86_64 kernel were declared if CONFIG_SMP was enabled.
Now, post unification, these same defines in a X86_64 kernel are only being
declared if CONFIG_NUMA and CONFIG_SMP are enabled.

This, for example, breaks 'perfmon_amd64.c' compilation.

This patch defines ENABLE_TOPO_DEFINE if this is a X86_64 kernel and we
have SMP support enabled.

Signed-off-by: Miguel Botón <mboton@gmail.com>

diff --git a/include/asm-x86/topology.h b/include/asm-x86/topology.h
index 9c25160..f95b3cc 100644
--- a/include/asm-x86/topology.h
+++ b/include/asm-x86/topology.h
@@ -79,10 +79,6 @@ extern unsigned long node_remap_size[];
 
 #else
 
-# ifdef CONFIG_SMP
-#  define ENABLE_TOPO_DEFINES
-# endif
-
 # define SD_CACHE_NICE_TRIES	2
 # define SD_IDLE_IDX		2
 # define SD_NEWIDLE_IDX		0
@@ -129,6 +125,10 @@ extern int __node_distance(int, int);
 
 extern cpumask_t cpu_coregroup_map(int cpu);
 
+#if defined(CONFIG_X86_64) && defined(CONFIG_SMP)
+# define ENABLE_TOPO_DEFINES
+#endif
+
 #ifdef ENABLE_TOPO_DEFINES
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).phys_proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)

-- 
	Miguel Botón

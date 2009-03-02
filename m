Return-Path: <linux-kernel-owner+w=401wt.eu-S1759579AbZCBKfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbZCBKfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 05:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757006AbZCBKfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 05:35:17 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:51853 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbZCBKfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 05:35:15 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 2/3] x86_32: apic/summit_32, fix section mismatch
Date: Mon,  2 Mar 2009 11:34:28 +0100
Message-Id: <1235990069-1182-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1235989134-29146-1-git-send-email-jirislaby@gmail.com>
References: <1235989134-29146-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove __init section placement for some functions/data, so that
we don't get section mismatch warnings.

Also make inline function instead of empty setup_summit macro.

[v2]
One of them was not caught by
DEBUG_SECTION_MISMATCH=y
magic. Fix it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/summit_32.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index beda620..aac52fa 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -77,9 +77,9 @@ static void summit_send_IPI_all(int vector)
 extern int use_cyclone;
 
 #ifdef CONFIG_X86_SUMMIT_NUMA
-extern void setup_summit(void);
+static void setup_summit(void);
 #else
-#define setup_summit()	{}
+static inline void setup_summit(void) {}
 #endif
 
 static int summit_mps_oem_check(struct mpc_table *mpc, char *oem,
@@ -360,15 +360,15 @@ static void summit_vector_allocation_domain(int cpu, cpumask_t *retmask)
 }
 
 #ifdef CONFIG_X86_SUMMIT_NUMA
-static struct rio_table_hdr *rio_table_hdr __initdata;
-static struct scal_detail   *scal_devs[MAX_NUMNODES] __initdata;
-static struct rio_detail    *rio_devs[MAX_NUMNODES*4] __initdata;
+static struct rio_table_hdr *rio_table_hdr;
+static struct scal_detail   *scal_devs[MAX_NUMNODES];
+static struct rio_detail    *rio_devs[MAX_NUMNODES*4];
 
 #ifndef CONFIG_X86_NUMAQ
-static int mp_bus_id_to_node[MAX_MP_BUSSES] __initdata;
+static int mp_bus_id_to_node[MAX_MP_BUSSES];
 #endif
 
-static int __init setup_pci_node_map_for_wpeg(int wpeg_num, int last_bus)
+static int setup_pci_node_map_for_wpeg(int wpeg_num, int last_bus)
 {
 	int twister = 0, node = 0;
 	int i, bus, num_buses;
@@ -430,7 +430,7 @@ static int __init setup_pci_node_map_for_wpeg(int wpeg_num, int last_bus)
 	return bus;
 }
 
-static int __init build_detail_arrays(void)
+static int build_detail_arrays(void)
 {
 	unsigned long ptr;
 	int i, scal_detail_size, rio_detail_size;
@@ -464,7 +464,7 @@ static int __init build_detail_arrays(void)
 	return 1;
 }
 
-void __init setup_summit(void)
+void setup_summit(void)
 {
 	unsigned long		ptr;
 	unsigned short		offset;
-- 
1.6.1.3


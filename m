Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbYI2Npm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbYI2Npm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 09:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYI2Npf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 09:45:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47693 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750910AbYI2Npe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 09:45:34 -0400
Date: Mon, 29 Sep 2008 08:45:29 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] - New UV genapic functions for x2apic
Message-ID: <20080929134529.GA12829@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add functions that use the infrastructure added by the x2apic code. These
functions were originally stubbed out since the UV code went into the
tree prior to the x2apic code.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/kernel/genx2apic_uv_x.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: linux/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/genx2apic_uv_x.c	2008-09-28 07:27:00.000000000 -0500
+++ linux/arch/x86/kernel/genx2apic_uv_x.c	2008-09-28 11:53:23.000000000 -0500
@@ -114,7 +114,7 @@ static void uv_send_IPI_one(int cpu, int
 	unsigned long val, apicid, lapicid;
 	int pnode;
 
-	apicid = per_cpu(x86_cpu_to_apicid, cpu); /* ZZZ - cache node-local ? */
+	apicid = per_cpu(x86_cpu_to_apicid, cpu);
 	lapicid = apicid & 0x3f;		/* ZZZ macro needed */
 	pnode = uv_apicid_to_pnode(apicid);
 	val =
@@ -202,12 +202,10 @@ static unsigned int phys_pkg_id(int inde
 	return uv_read_apic_id() >> index_msb;
 }
 
-#ifdef ZZZ		/* Needs x2apic patch */
 static void uv_send_IPI_self(int vector)
 {
 	apic_write(APIC_SELF_IPI, vector);
 }
-#endif
 
 struct genapic apic_x2apic_uv_x = {
 	.name = "UV large system",
@@ -215,15 +213,15 @@ struct genapic apic_x2apic_uv_x = {
 	.int_delivery_mode = dest_Fixed,
 	.int_dest_mode = (APIC_DEST_PHYSICAL != 0),
 	.target_cpus = uv_target_cpus,
-	.vector_allocation_domain = uv_vector_allocation_domain,/* Fixme ZZZ */
+	.vector_allocation_domain = uv_vector_allocation_domain,
 	.apic_id_registered = uv_apic_id_registered,
 	.init_apic_ldr = uv_init_apic_ldr,
 	.send_IPI_all = uv_send_IPI_all,
 	.send_IPI_allbutself = uv_send_IPI_allbutself,
 	.send_IPI_mask = uv_send_IPI_mask,
-	/* ZZZ.send_IPI_self = uv_send_IPI_self, */
+	.send_IPI_self = uv_send_IPI_self,
 	.cpu_mask_to_apicid = uv_cpu_mask_to_apicid,
-	.phys_pkg_id = phys_pkg_id,	/* Fixme ZZZ */
+	.phys_pkg_id = phys_pkg_id,
 	.get_apic_id = get_apic_id,
 	.set_apic_id = set_apic_id,
 	.apic_id_mask = (0xFFFFFFFFu),

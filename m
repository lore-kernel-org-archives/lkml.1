Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbYFEMHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbYFEMHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbYFEMHC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:07:02 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:41857 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134AbYFEMHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:07:00 -0400
X-BigFish: VPS11(z2d9bozzz10d3izzz32i6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K1ZOB6-01-8BJ-01
Date: Thu, 5 Jun 2008 14:05:57 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix compile warning in io_apic_{32,64}.c
Message-ID: <20080605120557.GB14755@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 05 Jun 2008 12:05:53.0204 (UTC) FILETIME=[80A34740:01C8C704]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 05f2d12c3563dea8c81b301f9f3cf7919af23b13
(x86: change GET_APIC_ID() from an inline function to an out-of-line function)

introduced a compile warning

arch/x86/kernel/io_apic_64.c: In function 'print_local_APIC':
arch/x86/kernel/io_apic_64.c:1152: warning: 'v' is used uninitialized in this function

in some debug code -- which is not enabled by default.
This patch reverts the code changes in print_local_APIC.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

--
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index a40d54f..9a3446f 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -1489,8 +1489,8 @@ void /*__init*/ print_local_APIC(void * dummy)
 
 	printk("\n" KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
 		smp_processor_id(), hard_smp_processor_id());
-	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v,
-			GET_APIC_ID(read_apic_id()));
+	v = apic_read(APIC_ID);
+	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, GET_APIC_ID(v));
 	v = apic_read(APIC_LVR);
 	printk(KERN_INFO "... APIC VERSION: %08x\n", v);
 	ver = GET_APIC_VERSION(v);
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index ef1a8df..59ed52c 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -1077,7 +1077,8 @@ void __apicdebuginit print_local_APIC(void * dummy)
 
 	printk("\n" KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
 		smp_processor_id(), hard_smp_processor_id());
-	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, GET_APIC_ID(read_apic_id()));
+	v = apic_read(APIC_ID);
+	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, GET_APIC_ID(v));
 	v = apic_read(APIC_LVR);
 	printk(KERN_INFO "... APIC VERSION: %08x\n", v);
 	ver = GET_APIC_VERSION(v);





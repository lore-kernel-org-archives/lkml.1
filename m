Return-Path: <linux-kernel-owner+w=401wt.eu-S1757745AbZCDWC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbZCDWC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 17:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbZCDWCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 17:02:49 -0500
Received: from relay1.sgi.com ([192.48.179.29]:54719 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754669AbZCDWCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 17:02:48 -0500
Date: Wed, 4 Mar 2009 16:02:46 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/3 v7] SGI RTC: fix uv_time for UP
Message-ID: <20090304220246.GC6288@sgi.com>
References: <20090304185413.GA24385@sgi.com> <20090304194658.GA18096@elte.hu> <20090304204522.GA25430@sgi.com> <20090304205833.GB3527@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304205833.GB3527@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix non-smp build of uv_time.c.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

This time against tip/x86/uv

 arch/x86/kernel/uv_time.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.tip-uv/arch/x86/kernel/uv_time.c
===================================================================
--- linux-2.6.tip-uv.orig/arch/x86/kernel/uv_time.c	2009-03-04 15:52:10.000000000 -0600
+++ linux-2.6.tip-uv/arch/x86/kernel/uv_time.c	2009-03-04 15:58:48.000000000 -0600
@@ -20,6 +20,9 @@
  */
 #include <linux/clockchips.h>
 
+#include <asm/apic.h>
+#include <asm/cpu.h>
+
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/bios.h>
@@ -84,7 +87,7 @@ static void uv_rtc_send_IPI(int cpu)
 	unsigned long apicid, val;
 	int pnode;
 
-	apicid = per_cpu(x86_cpu_to_apicid, cpu);
+	apicid = cpu_physical_id(cpu);
 	pnode = uv_apicid_to_pnode(apicid);
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 	      (apicid << UVH_IPI_INT_APIC_ID_SHFT) |

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbZCDUpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbZCDUpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 15:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbZCDUpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 15:45:25 -0500
Received: from relay1.sgi.com ([192.48.179.29]:39845 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754266AbZCDUpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:45:24 -0500
Date: Wed, 4 Mar 2009 14:45:22 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/3 v7] SGI RTC: fix uv_time for UP
Message-ID: <20090304204522.GA25430@sgi.com>
References: <20090304185413.GA24385@sgi.com> <20090304194658.GA18096@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304194658.GA18096@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix UP build of uv_time.c.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 arch/x86/kernel/uv_time.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/uv_time.c
===================================================================
--- linux.orig/arch/x86/kernel/uv_time.c	2009-03-04 12:32:58.000000000 -0600
+++ linux/arch/x86/kernel/uv_time.c	2009-03-04 14:23:32.000000000 -0600
@@ -19,6 +19,8 @@
  *  Copyright (c) Dimitri Sivanich
  */
 #include <linux/clockchips.h>
+#include <asm/apic.h>
+#include <asm/cpu.h>
 #include <asm/uv/uv.h>
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
@@ -81,7 +83,7 @@ static void uv_rtc_send_IPI(int cpu)
 	unsigned long apicid, val;
 	int pnode;
 
-	apicid = per_cpu(x86_cpu_to_apicid, cpu);
+	apicid = cpu_physical_id(cpu);
 	pnode = uv_apicid_to_pnode(apicid);
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 	      (apicid << UVH_IPI_INT_APIC_ID_SHFT) |

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbYIFXvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbYIFXvS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYIFXuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:50:40 -0400
Received: from relay2.sgi.com ([192.48.171.30]:38035 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753021AbYIFXuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:50:39 -0400
Message-Id: <20080906235037.333978000@polaris-admin.engr.sgi.com>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 06 Sep 2008 16:50:39 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [RFC 03/13] xen: use new for_each_online_cpu_mask_nr function
Content-Disposition: inline; filename=xen-send_IPI_mask
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Change the send_IPI_mask function in xen to not require a local
    cpumask_t variable.

Applies to linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/xen/smp.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- linux-2.6.tip.orig/arch/x86/xen/smp.c
+++ linux-2.6.tip/arch/x86/xen/smp.c
@@ -358,15 +358,11 @@ static void xen_smp_send_reschedule(int 
 	xen_send_IPI_one(cpu, XEN_RESCHEDULE_VECTOR);
 }
 
-static void xen_send_IPI_mask(const cpumask_t *inmask, enum ipi_vector vector)
+static void xen_send_IPI_mask(const cpumask_t *mask, enum ipi_vector vector)
 {
 	unsigned cpu;
-	cpumask_t mask;
 
-	mask = *inmask;
-	cpus_and(mask, mask, cpu_online_map);
-
-	for_each_cpu_mask_nr(cpu, mask)
+	for_each_online_cpu_mask_nr(cpu, *mask)
 		xen_send_IPI_one(cpu, vector);
 }
 

-- 

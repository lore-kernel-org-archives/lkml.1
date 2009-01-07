Return-Path: <linux-kernel-owner+w=401wt.eu-S1761296AbZAGT7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296AbZAGT7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbZAGT6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:58:36 -0500
Received: from relay2.sgi.com ([192.48.179.30]:53569 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754262AbZAGT6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:58:36 -0500
Message-Id: <20090107195833.012202000@polaris-admin.engr.sgi.com>
References: <20090107195832.265117000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 07 Jan 2009 11:58:37 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] cpumask: convert other misc kernel functions
Content-Disposition: inline; filename=cpumask:convert-misc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Impact: use new cpumask API.

Convert other misc kernel functions to use struct cpumask.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 lib/smp_processor_id.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.28.orig/lib/smp_processor_id.c
+++ linux-2.6.28/lib/smp_processor_id.c
@@ -22,7 +22,7 @@ notrace unsigned int debug_smp_processor
 	 * Kernel threads bound to a single CPU can safely use
 	 * smp_processor_id():
 	 */
-	if (cpus_equal(current->cpus_allowed, cpumask_of_cpu(this_cpu)))
+	if (cpumask_equal(&current->cpus_allowed, cpumask_of(this_cpu)))
 		goto out;
 
 	/*

-- 

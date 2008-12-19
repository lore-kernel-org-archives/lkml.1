Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbYLSQCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbYLSQCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbYLSQBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:01:49 -0500
Received: from relay2.sgi.com ([192.48.179.30]:35419 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751257AbYLSQBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:01:47 -0500
Message-Id: <20081219160145.808450000@polaris-admin.engr.sgi.com>
References: <20081219160144.697518000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 08:01:52 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 8/8] cpumask: convert other misc kernel functions
Content-Disposition: inline; filename=cpumask:convert-misc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Use new cpumask API.

Convert other misc kernel functions to use struct cpumask.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Steven Rostedt <srostedt@redhat.com>
---
 lib/smp_processor_id.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6-for-ingo.orig/lib/smp_processor_id.c
+++ linux-2.6-for-ingo/lib/smp_processor_id.c
@@ -22,7 +22,7 @@ notrace unsigned int debug_smp_processor
 	 * Kernel threads bound to a single CPU can safely use
 	 * smp_processor_id():
 	 */
-	if (cpus_equal(current->cpus_allowed, cpumask_of_cpu(this_cpu)))
+	if (cpumask_equal(&current->cpus_allowed, cpumask_of(this_cpu)))
 		goto out;
 
 	/*

-- 

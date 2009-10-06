Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbZJGDFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbZJGDFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 23:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZJGDFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 23:05:03 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:44344 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752911AbZJGDE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 23:04:59 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 3
	times
Message-Id: <20091006233731.227194194@gentwo.org>
References: <20091006233654.815079668@gentwo.org>
User-Agent: quilt/0.46-1
Date: Tue, 06 Oct 2009 19:37:03 -0400
From: cl@linux-foundation.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Huang Ying <ying.huang@intel.com>
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [this_cpu_xx V5 09/19] Use this_cpu_ptr in crypto subsystem
Content-Disposition: inline; filename=this_cpu_ptr_crypto
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a slight optimization that removes one array lookup.
The processor number is needed for other things as well so the
get/put_cpu cannot be removed.

Acked-by: Tejun Heo <tj@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 crypto/cryptd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/crypto/cryptd.c
===================================================================
--- linux-2.6.orig/crypto/cryptd.c	2009-09-14 08:47:15.000000000 -0500
+++ linux-2.6/crypto/cryptd.c	2009-09-15 13:47:11.000000000 -0500
@@ -99,7 +99,7 @@ static int cryptd_enqueue_request(struct
 	struct cryptd_cpu_queue *cpu_queue;
 
 	cpu = get_cpu();
-	cpu_queue = per_cpu_ptr(queue->cpu_queue, cpu);
+	cpu_queue = this_cpu_ptr(queue->cpu_queue);
 	err = crypto_enqueue_request(&cpu_queue->queue, request);
 	queue_work_on(cpu, kcrypto_wq, &cpu_queue->work);
 	put_cpu();

-- 

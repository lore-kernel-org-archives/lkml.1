Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbZE0SO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbZE0SO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761764AbZE0SN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:13:56 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:46881 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759349AbZE0SNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:13:55 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 4
	times
Message-Id: <20090527180716.802173094@gentwo.org>
References: <20090527180635.008102701@gentwo.org>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 13:47:03 -0400
From: cl@linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Huang Ying <ying.huang@intel.com>
Cc: mingo@elte.hu
Cc: rusty@rustcorp.com.au
Cc: davem@davemloft.net
Subject: [my_cpu_ptr 5/5] Use my_cpu_ptr in crypto subsystem
Content-Disposition: inline; filename=my_cpu_ptr_crypto
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a slight optimization that removes one array lookup.
The processor number is needed for other things as well so the
get/put_cpu cannot be removed.

Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 crypto/cryptd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/crypto/cryptd.c
===================================================================
--- linux-2.6.orig/crypto/cryptd.c	2009-05-27 11:55:20.000000000 -0500
+++ linux-2.6/crypto/cryptd.c	2009-05-27 11:56:55.000000000 -0500
@@ -93,7 +93,7 @@ static int cryptd_enqueue_request(struct
 	struct cryptd_cpu_queue *cpu_queue;
 
 	cpu = get_cpu();
-	cpu_queue = per_cpu_ptr(queue->cpu_queue, cpu);
+	cpu_queue = my_cpu_ptr(queue->cpu_queue);
 	err = crypto_enqueue_request(&cpu_queue->queue, request);
 	queue_work_on(cpu, kcrypto_wq, &cpu_queue->work);
 	put_cpu();

-- 

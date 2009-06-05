Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbZFEW3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbZFEW3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 18:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbZFEW3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 18:29:21 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:60343 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755455AbZFEW3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 18:29:19 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 4
	times
Message-Id: <20090605191851.776993582@gentwo.org>
References: <20090605191819.376530498@gentwo.org>
User-Agent: quilt/0.46-1
Date: Fri, 05 Jun 2009 15:18:27 -0400
From: cl@linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Huang Ying <ying.huang@intel.com>
Cc: mingo@elte.hu
Cc: rusty@rustcorp.com.au
Cc: davem@davemloft.net
Subject: [this_cpu_xx 08/11] Use this_cpu_ptr in crypto subsystem
Content-Disposition: inline; filename=this_cpu_ptr_crypto
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
+	cpu_queue = this_cpu_ptr(queue->cpu_queue);
 	err = crypto_enqueue_request(&cpu_queue->queue, request);
 	queue_work_on(cpu, kcrypto_wq, &cpu_queue->work);
 	put_cpu();

-- 

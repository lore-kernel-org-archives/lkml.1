Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbZE0Tda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbZE0Tda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbZE0TdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:33:23 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:40317 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753691AbZE0TdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:33:22 -0400
Date: Wed, 27 May 2009 15:33:12 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: linux-kernel@vger.kernel.org
cc: Tejun Heo <tj@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
       Eric Biederman <ebiederm@aristanetworks.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       David L Stevens <dlstevens@us.ibm.com>, mingo@elte.hu,
       rusty@rustcorp.com.au, davem@davemloft.net
Subject: Re: [my_cpu_ptr 3/5] Elimninate get/put_cpu
In-Reply-To: <20090527180716.187512073@gentwo.org>
Message-ID: <alpine.DEB.1.10.0905271532270.30618@gentwo.org>
References: <20090527180635.008102701@gentwo.org> <20090527180716.187512073@gentwo.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmaengine.c was not compiled.... Fixes:

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 drivers/dma/dmaengine.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/dma/dmaengine.c
===================================================================
--- linux-2.6.orig/drivers/dma/dmaengine.c	2009-05-27 14:30:32.000000000 -0500
+++ linux-2.6/drivers/dma/dmaengine.c	2009-05-27 14:31:19.000000000 -0500
@@ -328,7 +328,7 @@ struct dma_chan *dma_find_channel(enum d
 {
 	struct dma_chan *chan;

-	preempt_disable()
+	preempt_disable();
 	chan = my_cpu_ptr(channel_table[tx_type])->chan;
 	preempt_enable();

@@ -918,7 +918,7 @@ dma_async_memcpy_pg_to_pg(struct dma_cha
 	preempt_disable();
 	my_cpu_ptr(chan->local)->bytes_transferred += len;
 	my_cpu_ptr(chan->local)->memcpy_count++;
-	preempt_disable();
+	preempt_enable();

 	return cookie;
 }

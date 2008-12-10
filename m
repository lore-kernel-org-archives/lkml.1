Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbYLJSuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbYLJSuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbYLJSuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:50:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:65262 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbYLJSuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:50:06 -0500
Message-ID: <49400F2F.4050603@vlnb.net>
Date: Wed, 10 Dec 2008 21:49:19 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH][RFC 13/23]: Export of alloc_io_context() function
References: <494009D7.4020602@vlnb.net>
In-Reply-To: <494009D7.4020602@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+MIv/50Q2ai0Do8LluwhU07JCdK+CGd0wrGJH
 RWspc4m5460w2o/nMUFUMze/x/28/VxvRv8ZilqdLgwZ1gsmkY
 xFxOSaWG9f/aKRrQrApdQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exports alloc_io_context() function. For performance reasons 
SCST queues commands using a pool of IO threads. It is considerably 
better for performance (>30% increase on sequential reads) if threads in 
  a pool have the same IO context. Since SCST can be built as a module, 
it needs alloc_io_context() function exported.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  block/blk-ioc.c |    1 +
  1 file changed, 1 insertion(+)

diff -upkr linux-2.6.27.2/block/blk-ioc.c linux-2.6.27.2/block/blk-ioc.c
--- linux-2.6.27.2/block/blk-ioc.c	2008-10-10 02:13:53.000000000 +0400
+++ linux-2.6.27.2/block/blk-ioc.c	2008-11-25 21:27:01.000000000 +0300
@@ -105,6 +105,7 @@ struct io_context *alloc_io_context(gfp_
 
 	return ret;
 }
+EXPORT_SYMBOL(alloc_io_context);
 
 /*
  * If the current task has no IO context then create one and initialise it.


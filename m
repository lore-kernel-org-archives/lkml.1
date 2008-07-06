Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbYGFQDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbYGFQDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 12:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756988AbYGFQDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 12:03:16 -0400
Received: from gw.goop.org ([64.81.55.164]:44413 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607AbYGFQDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 12:03:16 -0400
Message-ID: <4870ECBA.7050901@goop.org>
Date: Sun, 06 Jul 2008 09:03:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] generic ipi function calls: wait on alloc failure fallback
References: <4870DBB6.30107@goop.org>
In-Reply-To: <4870DBB6.30107@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a GFP_ATOMIC allocation fails, smp_call_function_mask falls back
to allocating the data on the stack and converting it to a waiting call.

Make sure we actually wait in this case.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 kernel/smp.c |    1 +
 1 file changed, 1 insertion(+)

===================================================================
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -312,6 +312,7 @@ int smp_call_function_mask(cpumask_t mas
 	if (!data) {
 		data = &d;
 		data->csd.flags = CSD_FLAG_WAIT;
+		wait = 1;
 	}
 
 	spin_lock_init(&data->lock);




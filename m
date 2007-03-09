Return-Path: <linux-kernel-owner+w=401wt.eu-S2993044AbXCIHUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993044AbXCIHUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993045AbXCIHUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:20:55 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:35963 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993044AbXCIHUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:20:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=ASu8xnbPvsKHwIVHrtnxsbw6xhlsH4Yvs+NmVDEEEPrJ/i/8gQVaqnP0feEL0k2ceBp21DmCDut8Buam1g/bzInUmQnZVDnbImlfRaWDzbF+aJZf2RLQcxuWi/9KwOgRhiEmKeYuG57pLXNnO/R+41PE4HPUztNgpEYjXLB4BrA=
Date: Thu, 8 Mar 2007 23:20:35 -0800
From: Amit Choudhary <amit2030@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/slab.c: check kmalloc() return value.
Message-Id: <20070308232035.8518757c.amit2030@gmail.com>
Organization: X
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.8.15; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Description: Check the return value of kmalloc() in function setup_cpu_cache(), in file mm/slab.c.

Signed-off-by: Amit Choudhary <amit2030@gmail.com>

diff --git a/mm/slab.c b/mm/slab.c
index 84c631f..613ae61 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2021,6 +2021,7 @@ static int setup_cpu_cache(struct kmem_c
 	} else {
 		cachep->array[smp_processor_id()] =
 			kmalloc(sizeof(struct arraycache_init), GFP_KERNEL);
+		BUG_ON(!cachep->array[smp_processor_id()]);
 
 		if (g_cpucache_up == PARTIAL_AC) {
 			set_up_list3s(cachep, SIZE_L3);

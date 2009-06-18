Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbZFRUH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbZFRUH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 16:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbZFRUHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 16:07:14 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1687 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZFRUHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 16:07:13 -0400
Subject: [PATCH] bootmem.c: Avoid c90 declaration warning
From: Joe Perches <joe@perches.com>
To: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 13:07:13 -0700
Message-Id: <1245355633.29927.16.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 282df0a..09d9c98 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -536,11 +536,13 @@ static void * __init alloc_arch_preferred_bootmem(bootmem_data_t *bdata,
 		return kzalloc(size, GFP_NOWAIT);
 
 #ifdef CONFIG_HAVE_ARCH_BOOTMEM
+	{
 	bootmem_data_t *p_bdata;
 
 	p_bdata = bootmem_arch_preferred_node(bdata, size, align, goal, limit);
 	if (p_bdata)
 		return alloc_bootmem_core(p_bdata, size, align, goal, limit);
+	}
 #endif
 	return NULL;
 }



Return-Path: <linux-kernel-owner+w=401wt.eu-S1759834AbYGPQMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834AbYGPQMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757755AbYGPQMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:12:10 -0400
Received: from relay1.sgi.com ([192.48.171.29]:41360 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757376AbYGPQMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:12:08 -0400
Date: Wed, 16 Jul 2008 11:11:59 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] - Fix kernel_physical_mapping_init() for large x86 systems 
Message-ID: <20080716161159.GA23870@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bug in kernel_physical_mapping_init() that causes kernel
page table to be built incorrectly for systems with greater
than 512GB of memory.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/mm/init_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c	2008-07-15 16:43:49.000000000 -0500
+++ linux/arch/x86/mm/init_64.c	2008-07-16 11:00:25.000000000 -0500
@@ -644,7 +644,7 @@ static unsigned long __init kernel_physi
 		unsigned long pud_phys;
 		pud_t *pud;
 
-		next = start + PGDIR_SIZE;
+		next = (start + PGDIR_SIZE) & PGDIR_MASK;
 		if (next > end)
 			next = end;
 

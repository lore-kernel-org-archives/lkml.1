Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbYFXV6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbYFXV6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757180AbYFXV5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:57:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:49473 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbYFXV5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:57:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=WePZTSe1MpIWYn4V+FTeiRp6Gr39BeS+Nai9wS3UjkY6NsvPqEyp/mzDuPbRW/gR8h
         jo8xyldJ8OuphA+lPfX1QzYhtxvq+svRcFQLdOuk/gT63mPo7aguQsTNYSN3CwHD+pg5
         F5Fbo/hE19w4frj+V71SvMGCxnFbKYucI/IKA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: get max_pfn_mapped in init_memory_mapping
Date: Tue, 24 Jun 2008 14:56:20 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806241455.33199.yhlu.kernel@gmail.com>
In-Reply-To: <200806241455.33199.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241456.20753.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so don't shift that in the loop

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 0c92624..8bad202 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -398,7 +398,7 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end)
 	__flush_tlb_all();
 	update_page_count(PG_LEVEL_1G, pages);
 
-	return last_map_addr >> PAGE_SHIFT;
+	return last_map_addr;
 }
 
 static void __init find_early_table_space(unsigned long end)
@@ -606,7 +606,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start, unsigned lon
 	if (!after_bootmem)
 		early_memtest(start_phys, end_phys);
 
-	return last_map_addr;
+	return last_map_addr >> PAGE_SHIFT;
 }
 
 #ifndef CONFIG_NUMA

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYDOIMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYDOIMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYDOILs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:11:48 -0400
Received: from hs-out-0708.google.com ([64.233.178.241]:36415 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbYDOILq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:11:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=auSJa4C58aRwMmFY20V/xt8g2TwqzkSucGyaxaJTxFKlKPn4tmvCfUbbhFyElHqhcLRJGmEVQHZI70JLs6bqN9Dg4jfeVnbYDS/n5kr18i1JkKzKyd7ioM5HyHGZn9irItJAnjTuAYiXU8ZlZZ2drsP8eJ/YIYdwD3UJASa8S/Q=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86_64/mm: check and print vmemmap allocation continuous -fix
Date: Tue, 15 Apr 2008 01:11:21 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Christoph Lameter" <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>
References: <200804120119.24868.yhlu.kernel@gmail.com> <20080414235348.a5ddffee.akpm@linux-foundation.org>
In-Reply-To: <20080414235348.a5ddffee.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804150111.21990.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 058552e..2368f40 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -969,7 +969,7 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)
 							PAGE_KERNEL_LARGE);
 			set_pmd(pmd, __pmd(pte_val(entry)));
 
-			/* check if we got continous */
+			/* check to see if we have contiguous blocks */
 			if (p_end != p || node_start != node) {
 				if (p_start)
 					printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b695875..286d315 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1229,6 +1229,7 @@ void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
 int vmemmap_populate_basepages(struct page *start_page,
 						unsigned long pages, int node);
 int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
+void vmemmap_populate_print_last(void);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */

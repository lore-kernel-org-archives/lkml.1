Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbYBEQXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbYBEQXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758925AbYBEQXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:23:22 -0500
Received: from po-out-1718.google.com ([72.14.252.156]:57896 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208AbYBEQXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:23:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fT0bOEb6BHDQgYYi5t+ifn9rXyqprZsVIVLkrfSgUhp46fAJkirnIWRPDzOji+cahnLza0IqGhIOu8Sa98NncROoEkmlV4AkgxCdxXohQwaC/vRVR2jQbATsF2ClvlQy5L8dBwsnQVQnuYRzjQB+ZcY0WLaaIt4fz8YpxdkOCRQ=
Date: Wed, 6 Feb 2008 00:20:09 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@linux.intel.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [-mm Patch] arch/um/kernel/mem.c: fix a shadowed variable
Message-ID: <20080205162009.GB2966@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203171634.58ab668b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix a shadowed variable in arch/um/kernel/mem.c,
since there is a global variable has the same name.

Cc: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

Index: linux/arch/um/kernel/mem.c
===================================================================
--- linux.orig/arch/um/kernel/mem.c
+++ linux/arch/um/kernel/mem.c
@@ -299,7 +299,7 @@ void show_mem(void)
 {
 	int pfn, total = 0, reserved = 0;
 	int shared = 0, cached = 0;
-	int highmem = 0;
+	int high_mem = 0;
 	struct page *page;
 
 	printk(KERN_INFO "Mem-info:\n");
@@ -311,7 +311,7 @@ void show_mem(void)
 		page = pfn_to_page(pfn);
 		total++;
 		if (PageHighMem(page))
-			highmem++;
+			high_mem++;
 		if (PageReserved(page))
 			reserved++;
 		else if (PageSwapCache(page))
@@ -320,7 +320,7 @@ void show_mem(void)
 			shared += page_count(page) - 1;
 	}
 	printk(KERN_INFO "%d pages of RAM\n", total);
-	printk(KERN_INFO "%d pages of HIGHMEM\n", highmem);
+	printk(KERN_INFO "%d pages of HIGHMEM\n", high_mem);
 	printk(KERN_INFO "%d reserved pages\n", reserved);
 	printk(KERN_INFO "%d pages shared\n", shared);
 	printk(KERN_INFO "%d pages swap cached\n", cached);

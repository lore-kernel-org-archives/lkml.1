Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbXIYWDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbXIYWDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 18:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbXIYWDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 18:03:09 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55473 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbXIYWDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 18:03:06 -0400
Subject: Re: 2.6.23-rc8-mm1
From: Badari Pulavarty <pbadari@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, apw@shadowen.org
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070925014625.3cd5f896.akpm@linux-foundation.org>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 15:05:53 -0700
Message-Id: <1190757954.13955.44.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

One the patch you created in -mm is causing compile warning.
Here is the fix. Please verify.

Thanks,
Badari

arch/powerpc/mm/init_64.c: In function `vmemmap_populated':
arch/powerpc/mm/init_64.c:211: warning: passing arg 1 of `vmemmap_section_start' makes pointer from integer without a cast

vmemmap_section_start() gets called with an argument which is unsigned long.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>

Index: linux-2.6.23-rc8/arch/powerpc/mm/init_64.c
===================================================================
--- linux-2.6.23-rc8.orig/arch/powerpc/mm/init_64.c	2007-09-25 09:18:13.000000000 -0700
+++ linux-2.6.23-rc8/arch/powerpc/mm/init_64.c	2007-09-25 14:50:44.000000000 -0700
@@ -189,10 +189,9 @@ void pgtable_cache_init(void)
  * do this by hand as the proffered address may not be correctly aligned.
  * Subtraction of non-aligned pointers produces undefined results.
  */
-unsigned long __meminit vmemmap_section_start(struct page *page)
+unsigned long __meminit vmemmap_section_start(unsigned long page)
 {
-	unsigned long offset = ((unsigned long)page) -
-						((unsigned long)(vmemmap));
+	unsigned long offset = page - ((unsigned long)(vmemmap));
 
 	/* Return the pfn of the start of the section. */
 	return (offset / sizeof(struct page)) & PAGE_SECTION_MASK;



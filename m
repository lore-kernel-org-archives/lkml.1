Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbXGGBew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbXGGBew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 21:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbXGGBeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 21:34:44 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59324 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbXGGBen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 21:34:43 -0400
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
From: Badari Pulavarty <pbadari@gmail.com>
To: Andrea Arcangeli <andrea@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070706222651.GG5777@v2.random>
References: <20070706222651.GG5777@v2.random>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 18:36:21 -0700
Message-Id: <1183772181.21234.25.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-07 at 00:26 +0200, Andrea Arcangeli wrote:
> Hello,
> 
..
> 
> If you want to help/look here the patch:
> 
> 	http://www.kernel.org/pub/linux/kernel/people/andrea/patches/v2.6/2.6.22-rc7/hard-page-size
> 

Very interesting patch set. I really would like to support for it.
I would like to play with, please keep the patchset uptodate.

Here is the small nit fix ..

Thanks,
Badari

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22-rc7/mm/migrate.c
===================================================================
--- linux-2.6.22-rc7.orig/mm/migrate.c	2007-07-01 12:54:24.000000000 -0700
+++ linux-2.6.22-rc7/mm/migrate.c	2007-07-06 19:58:43.000000000 -0700
@@ -169,7 +169,7 @@ static void remove_migration_pte(struct 
 		goto out;
 
 	get_page(new);
-	pte = pte_mkold(mk_pte(new, vma->vm_page_prot));
+	pte = pte_mkold(mk_pte(new, addr, vma->vm_page_prot));
 	if (is_write_migration_entry(entry))
 		pte = pte_mkwrite(pte);
 	set_pte_at(mm, addr, ptep, pte);




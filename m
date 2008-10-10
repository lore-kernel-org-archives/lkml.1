Return-Path: <linux-kernel-owner+w=401wt.eu-S1763749AbYJJVzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763749AbYJJVzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759469AbYJJVy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:54:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759321AbYJJVy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:54:59 -0400
Date: Fri, 10 Oct 2008 14:54:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: apw@shadowen.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kniht@linux.vnet.ibm.com, mel@csn.ul.ie
Subject: Re: [PATCH 1/1] hugetlb: pull gigantic page initialisation out of
 the default path
Message-Id: <20081010145418.4d0236ba.akpm@linux-foundation.org>
In-Reply-To: <200810082331.45359.nickpiggin@yahoo.com.au>
References: <1223458499-12752-1-git-send-email-apw@shadowen.org>
	<200810082331.45359.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2008 23:31:45 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Wednesday 08 October 2008 20:34, Andy Whitcroft wrote:
> > As we can determine exactly when a gigantic page is in use we can optimise
> > the common regular page cases by pulling out gigantic page initialisation
> > into its own function.  As gigantic pages are never released to buddy we
> > do not need a destructor.  This effectivly reverts the previous change
> > to the main buddy allocator.  It also adds a paranoid check to ensure we
> > never release gigantic pages from hugetlbfs to the main buddy.
> 
> Thanks for doing this. Can prep_compound_gigantic_page be #ifdef HUGETLB?

Yup.

--- a/mm/page_alloc.c~hugetlb-pull-gigantic-page-initialisation-out-of-the-default-path-fix
+++ a/mm/page_alloc.c
@@ -280,6 +280,7 @@ void prep_compound_page(struct page *pag
 	}
 }
 
+#ifdef CONFIG_HUGETLBFS
 void prep_compound_gigantic_page(struct page *page, unsigned long order)
 {
 	int i;
@@ -294,6 +295,7 @@ void prep_compound_gigantic_page(struct 
 		p->first_page = page;
 	}
 }
+#endif
 
 static void destroy_compound_page(struct page *page, unsigned long order)
 {
_


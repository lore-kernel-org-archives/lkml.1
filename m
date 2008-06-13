Return-Path: <linux-kernel-owner+w=401wt.eu-S1760314AbYFMAXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760314AbYFMAXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 20:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349AbYFMAXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 20:23:15 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48440 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbYFMAXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 20:23:14 -0400
Date: Fri, 13 Jun 2008 09:25:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] 2.6.26-rc5-mm3 kernel BUG at mm/filemap.c:575!
Message-Id: <20080613092520.fb35cd70.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200806122138.59969.nickpiggin@yahoo.com.au>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org>
	<4850E1E5.90806@linux.vnet.ibm.com>
	<20080612015746.172c4b56.akpm@linux-foundation.org>
	<200806122138.59969.nickpiggin@yahoo.com.au>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 21:38:59 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> +int putback_lru_page(struct page *page)
> +{
> +       int lru;
> +       int ret = 1;
> +       int was_unevictable;
> +
> +       VM_BUG_ON(!PageLocked(page));
> +       VM_BUG_ON(PageLRU(page));
> +
> +       lru = !!TestClearPageActive(page);
> +       was_unevictable = TestClearPageUnevictable(page); /* for 
> page_evictable() */
> +
> +       if (unlikely(!page->mapping)) {
> +               /*
> +                * page truncated.  drop lock as put_page() will
> +                * free the page.
> +                */
> +               VM_BUG_ON(page_count(page) != 1);
> +               unlock_page(page);
>                 ^^^^^^^^^^^^^^^^^^
> 
> 
> This is a rather wild thing to be doing. It's a really bad idea
> to drop a lock that's taken several function calls distant and
> across different files...
> 
I agree and strongly hope this unlock should be removed.
The caller can do unlock by itself, I think.

Thanks,
-Kame


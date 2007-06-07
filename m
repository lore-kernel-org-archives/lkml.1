Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbXFGMqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbXFGMqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 08:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbXFGMqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 08:46:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55134 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbXFGMqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 08:46:15 -0400
Date: Thu, 7 Jun 2007 21:47:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, clameter@sgi.com,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: 2.6.22-rc4-mm1
Message-Id: <20070607214706.3efc5870.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070606020737.4663d686.akpm@linux-foundation.org>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Question.

While writing memory unplug, I noticed this code.
==
static int
fixup_anon_page(pte_t *pte, unsigned long start, unsigned long end, void *priv)
{
        struct vm_area_struct *vma = priv;
        struct page *page = vm_normal_page(vma, start, *pte);

        if (page && PageAnon(page))
                page->index = linear_page_index(vma, start);

        return 0;
}

static int fixup_anon_pages(struct vm_area_struct *vma)
{
        struct mm_walk walk = {
                .pte_entry = fixup_anon_page,
        };

        return walk_page_range(vma->vm_mm,
                        vma->vm_start, vma->vm_end, &walk, vma);
}
==

I think that 'pte' passed to fixup_anon_page() by walk_page_range()
is not guaranteed to be 'Present'.

Then, vm_normal_page() will show print_bad_pte().

If this never occur now, I'll add my own check code for memory migration by kernel here.

(Sorry, I can't find who should be CCed.)

-Kame



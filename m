Return-Path: <linux-kernel-owner+w=401wt.eu-S1759106AbZFYPns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106AbZFYPns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbZFYPnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:43:41 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:59549 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754337AbZFYPnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:43:40 -0400
Date: Thu, 25 Jun 2009 11:43:43 -0400
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Coldfire 5271 hitting BUG_ON(page_count(buddy) != 0);
Message-ID: <20090625154343.GA10189@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am hitting a memory management bug and I would love some hints as to
how to track down the bug and fix it.

The bug hit is line 423 of page_alloc.c which is:

BUG_ON(page_count(buddy) != 0);

The function it is part of is:

static inline int page_is_buddy(struct page *page, struct page *buddy,
                                                                int order)
{
        if (!pfn_valid_within(page_to_pfn(buddy)))
                return 0;

        if (page_zone_id(page) != page_zone_id(buddy))
                return 0;

        if (PageBuddy(buddy) && page_order(buddy) == order) {
                BUG_ON(page_count(buddy) != 0);
                return 1;
        }
        return 0;
}

I am seeing this both with 2.6.29.1 and 2.6.30 so far.  I unfortunately
haven't poked much at the memory management code, so I am not even sure
what this is supposed to be doing.  The cpu us a coldfire 5271.

I also see crashes causing the kernel to dump lots of hex values.
Building the kernel with debug enabled unfortunately seems to move things
around enough to make it just lock up instead without any output.

-- 
Len Sorensen

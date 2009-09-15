Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZIOQCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZIOQCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbZIOQCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:02:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbZIOQCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:02:45 -0400
Message-ID: <4AAFBA76.109@redhat.com>
Date: Tue, 15 Sep 2009 12:01:58 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: use-once mapped file pages
References: <1252971975-15218-1-git-send-email-hannes@cmpxchg.org> <28c262360909150826s2a0f5f0dpd111640f92d0f5ff@mail.gmail.com>
In-Reply-To: <28c262360909150826s2a0f5f0dpd111640f92d0f5ff@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim wrote:

> http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=commitdiff;h=fe23e022c442bb917815e206c4765cd9150faef5
> 
> At that time, Rik added following as.
> ( I hate wordwrap, but my google webmail will do ;( )
> 
> +       /* File is mmap'd by somebody. */
> +       if (!list_empty(&mapping->i_mmap) ||
> !list_empty(&mapping->i_mmap_shared))
> +               return 1;
> 
> It made your case worse as you noticed.

Other things changed since that code was added.

At the time, we set the page referenced bit at page fault
time, while today we propagate the referenced bit from the
page table to the struct page at MUNMAP time.

The code above was put in place to make sure the kernel
would cache often used (but very briefly mmaped) pages,
like the ones containing exec(3) in glibc.

However, propagating the referenced bit at munmap time
should have the same effect, allowing us to get rid of
my old page_mapping_inuse() code.

Frankly, I'm happy to see that code go :)

-- 
All rights reversed.

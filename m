Return-Path: <linux-kernel-owner+w=401wt.eu-S1751141AbZGUHRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbZGUHRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 03:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbZGUHQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 03:16:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:60251 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbZGUHQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 03:16:58 -0400
Date: Tue, 21 Jul 2009 09:16:54 +0200
From: Nick Piggin <npiggin@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Izik Eidus <ieidus@redhat.com>, akpm@linux-foundation.org,
       hugh.dickins@tiscali.co.uk, aarcange@redhat.com, chrisw@redhat.com,
       avi@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 05/10] ksm: no debug in page_dup_rmap()
Message-ID: <20090721071654.GB7816@wotan.suse.de>
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com> <1247851850-4298-2-git-send-email-ieidus@redhat.com> <1247851850-4298-3-git-send-email-ieidus@redhat.com> <1247851850-4298-4-git-send-email-ieidus@redhat.com> <1247851850-4298-5-git-send-email-ieidus@redhat.com> <1247851850-4298-6-git-send-email-ieidus@redhat.com> <4A64B342.8070002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A64B342.8070002@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 02:11:14PM -0400, Rik van Riel wrote:
> Izik Eidus wrote:
> >From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> >
> >page_dup_rmap(), used on each mapped page when forking,  was originally
> >just an inline atomic_inc of mapcount.  2.6.22 added CONFIG_DEBUG_VM
> >out-of-line checks to it, which would need to be ever-so-slightly
> >complicated to allow for the PageKsm() we're about to define.
> >
> >But I think these checks never caught anything.  And if it's coding
> >errors we're worried about, such checks should be in page_remove_rmap()
> >too, not just when forking; whereas if it's pagetable corruption we're
> >worried about, then they shouldn't be limited to CONFIG_DEBUG_VM.
> 
> Acked-by: Rik van Riel <riel@redhat.com>

I like debug code like this as it helps comment the code a litte
bit too. We've got lots of debug checks in the VM and probably
very few of them catch anything useful... I'd kind of like to see
it be ever-so-slightly complicated with PageKsm, and even a call
to page_check_anon_rmap put into page_remove_rmap (which is a good
idea).

pagetable corruption/struct page corruption I think is good to
check for, but it is fine to have such checks under DEBUG_VM --
we have a couple of orders of magnitude more memory that is not
for struct page, so decent coverage of memory corruption kind of
wants slab and page debugging too, don't you think?

/checks the sky for pigs...
  

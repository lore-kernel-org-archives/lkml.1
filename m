Return-Path: <linux-kernel-owner+w=401wt.eu-S1765624AbZDBTtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765624AbZDBTtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbZDBTtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:49:31 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20825 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbZDBTta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:49:30 -0400
Date: Thu, 2 Apr 2009 21:49:27 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Chris Wright <chrisw@redhat.com>
cc: Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       aarcange@redhat.com, riel@redhat.com, jeremy@goop.org,
       mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net, yaniv@redhat.com,
       dmonakhov@openvz.org
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux
In-Reply-To: <20090402193920.GF10392@x200.localdomain>
Message-ID: <alpine.LNX.2.00.0904022147450.4265@swampdragon.chaosbits.net>
References: <1238457560-7613-1-git-send-email-ieidus@redhat.com> <alpine.LNX.2.00.0904022114040.4265@swampdragon.chaosbits.net> <20090402193920.GF10392@x200.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009, Chris Wright wrote:

> * Jesper Juhl (jj@chaosbits.net) wrote:
> > Do you rely only on the checksum or do you actually compare pages to check 
> > they are 100% identical before sharing?
> 
> Checksum has absolutely nothing to do w/ finding if two pages match.
> It's only used as a heuristic to suggest whether a single page has
> changed.  If that page is changing we won't bother trying to find a
> match for it.  Here's an example of the life of a page w.r.t checksum.
> 
> 1. checksum = uninitialized
> 2. first time page is found, checksum it (checksum = A).
>    if checksum has changed (uninitialize != A) don't go any further w/ that page
> 3. next time page is found, checksum it (checksum = B).
>    if checksum has change (A != B) don't go any further w/ that page
> 4. next time page is found, checksum it (checksum = B).
>    if checksum has changed (B == B)...it hasn't, continue processing the
>    page
> 
> later if a match is found in the tree (which is sorted by _contents_,
> i.e. memcmp) we'll attempt to merge the pages which at it's very core
> does:
> 
> 	if (pages_identical(oldpage, newpage))
> 		ret = replace_page(vma, oldpage, newpage, orig_pte, newprot);
> 
> pages_identical?  you guessed it...just does:
> 
> 	r = memcmp(addr1, addr2, PAGE_SIZE)
> 

Thank you for that explanation, it set my mind at ease :-)


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html


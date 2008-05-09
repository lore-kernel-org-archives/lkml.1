Return-Path: <linux-kernel-owner+w=401wt.eu-S1759147AbYEIPWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbYEIPWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 11:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYEIPWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 11:22:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbYEIPWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 11:22:07 -0400
Date: Fri, 9 May 2008 08:21:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russ Anderson <rja@sgi.com>
cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 0/3] ia64: Migrate data off physical pages with correctable
 errors v3
In-Reply-To: <20080509150937.GA16523@sgi.com>
Message-ID: <alpine.LFD.1.10.0805090817280.3142@woody.linux-foundation.org>
References: <20080509150937.GA16523@sgi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 May 2008, Russ Anderson wrote:
> 
>   [2/3] page.discard.v2: Avoid putting a bad page back on the LRU.
> 
> 	page.discard are the arch independent changes.  It adds a new
> 	page flag (PG_memerror) to mark the page as bad and prevent it
> 	from being put back on the LRU.  PG_memerror is only defined
> 	on 64 bit architectures. 

So I haven't looked at this a lot, but it strikes me that it look to be 
much simple if you were to just increment the page count instead of 
playing games in mm/page_alloc.c.

That will make sure that it never goes back on any free lists, and 
requires no changes to the allocator. Hmm?

I'm also not really seeing why this triggers on lru_cache_add(), since 
that should only happen to new pages anyway. Who does lru_cache_add() on 
old pages?

			Linus

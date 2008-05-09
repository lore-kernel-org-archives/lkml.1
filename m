Return-Path: <linux-kernel-owner+w=401wt.eu-S932906AbYEIQig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906AbYEIQig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbYEIQi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:38:27 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59154 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754563AbYEIQi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:38:26 -0400
Date: Fri, 9 May 2008 09:38:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Russ Anderson <rja@sgi.com>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 0/3] ia64: Migrate data off physical pages with correctable
 errors v3
In-Reply-To: <alpine.LFD.1.10.0805090817280.3142@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805090935520.18195@schroedinger.engr.sgi.com>
References: <20080509150937.GA16523@sgi.com>
 <alpine.LFD.1.10.0805090817280.3142@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008, Linus Torvalds wrote:

> So I haven't looked at this a lot, but it strikes me that it look to be 
> much simple if you were to just increment the page count instead of 
> playing games in mm/page_alloc.c.

We are taking a refcount when isolating the page from the LRU. The 
problem is that the migration code attempts to free the page. That code 
could be changed to do something else instead like putting the page on the 
bad list.
 
> I'm also not really seeing why this triggers on lru_cache_add(), since 
> that should only happen to new pages anyway. Who does lru_cache_add() on 
> old pages?

Migration code does the adding back to the LRU when migration is complete. 
So he hooked into that I guess.


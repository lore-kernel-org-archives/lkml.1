Return-Path: <linux-kernel-owner+w=401wt.eu-S1030185AbXCOMvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030185AbXCOMvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 08:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030194AbXCOMvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 08:51:05 -0400
Received: from ns2.suse.de ([195.135.220.15]:57376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030185AbXCOMvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 08:51:02 -0400
Date: Thu, 15 Mar 2007 13:50:56 +0100
From: Nick Piggin <npiggin@suse.de>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Ashif Harji <asharji@cs.uwaterloo.ca>,
       Xiaoning Ding <dingxn@cse.ohio-state.edu>,
       Andreas Mohr <andi@rhlx01.fht-esslingen.de>, linux-mm@kvack.org,
       Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] mm/filemap.c: unconditionally call mark_page_accessed
Message-ID: <20070315125056.GE8321@wotan.suse.de>
References: <Pine.GSO.4.64.0703081612290.1080@cpu102.cs.uwaterloo.ca> <Pine.GSO.4.64.0703150045550.18191@cpu102.cs.uwaterloo.ca> <1173962816.14380.8.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173962816.14380.8.camel@kleikamp.austin.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 07:46:56AM -0500, Dave Kleikamp wrote:
> On Thu, 2007-03-15 at 01:22 -0400, Ashif Harji wrote:
> 
> > I would tend to agree with David that:  "Any application doing many 
> > tiny-sized reads isn't exactly asking for great performance."  As well, 
> > applications concerned with performance and caching problems can read in a 
> > file in PAGE_SIZE chunks.  I still think the simple fix of removing the 
> > condition is the best approach, but I'm certainly open to alternatives.
> 
> A possible alternative might be to store the offset within the page in
> the readahead state, and call mark_page_accessed() when the read offset
> is less than or equal to the previous offset.

That could be a good idea.

We definitely want to look at ways to solve with within the existing
approach before any large scale change in behaviour.


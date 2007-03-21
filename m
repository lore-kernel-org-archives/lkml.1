Return-Path: <linux-kernel-owner+w=401wt.eu-S933953AbXCUXqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953AbXCUXqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934013AbXCUXqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:46:51 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59502 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933953AbXCUXqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:46:49 -0400
Date: Wed, 21 Mar 2007 16:46:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andy Whitcroft <apw@shadowen.org>, Mel Gorman <mel@csn.ul.ie>,
       Bob Picco <bob.picco@hp.com>, Dave Hansen <hansendc@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] add pfn_valid_within helper for sub-MAX_ORDER hole
 detection
Message-Id: <20070321164633.fa90d959.akpm@linux-foundation.org>
In-Reply-To: <4601BE6F.3000003@yahoo.com.au>
References: <exportbomb.1174504472@pinky>
	<2b7fba2bc49877d95f3ad13735324444@pinky>
	<4601BE6F.3000003@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 10:23:27 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Andy Whitcroft wrote:
> > Generally we work under the assumption that memory the mem_map
> > array is contigious and valid out to MAX_ORDER_NR_PAGES block
> > of pages, ie. that if we have validated any page within this
> > MAX_ORDER_NR_PAGES block we need not check any other.  This is not
> > true when CONFIG_HOLES_IN_ZONE is set and we must check each and
> > every reference we make from a pfn.
> > 
> > Add a pfn_valid_within() helper which should be used when scanning
> > pages within a MAX_ORDER_NR_PAGES block when we have already
> > checked the validility of the block normally with pfn_valid().
> > This can then be optimised away when we do not have holes within
> > a MAX_ORDER_NR_PAGES block of pages.
> 
> Nice cleanup. Horrible name ;) Calls read like "is the pfn valid
> within pfn".

yeah
 
> I can't think of anything really good, but I think, say,
> pfn_valid_within_block or pfn_valid_within_valid_block would be a
> bit better. You still get a slight net savings in keystrokes!

Neither of those identifiers seem to really fit, and I can't think of anything
suitable either.  Oh well, at least pfn_valid_within() has a nice comment
explaining what it does.

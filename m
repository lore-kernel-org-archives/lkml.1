Return-Path: <linux-kernel-owner+w=401wt.eu-S1764429AbXKOLAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764429AbXKOLAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 06:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbXKOLA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 06:00:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48915 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294AbXKOLAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 06:00:24 -0500
Date: Thu, 15 Nov 2007 02:59:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mel@skynet.ie (Mel Gorman)
Cc: linuxppc-dev@ozlabs.org, sfr@canb.auug.org.au, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix boot problem with iSeries lacking hugepage support
Message-Id: <20071115025940.ca1994a0.akpm@linux-foundation.org>
In-Reply-To: <20071115105237.GD5128@skynet.ie>
References: <20071115101322.GA5128@skynet.ie>
	<20071115023943.a54b0464.akpm@linux-foundation.org>
	<20071115105237.GD5128@skynet.ie>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 10:52:38 +0000 mel@skynet.ie (Mel Gorman) wrote:

> > Shouldn't this have been HUGETLB_PAGE_ORDER?
> > 
> 
> As a #define, possibly but as a static inline - definitly not.
> 
> In this context, the define is not used because set_pageblock_order()
> is a no-op when CONFIG_HUGETLB_PAGE_SIZE_VARIABLE is unset.
> pageblock_default_order() is only defined for symmetry as set_pageblock_order()
> is defined in both contexts. However, as a #define it might make more sense
> to a casual reader to see HUGETLB_PAGE_ORDER even if it has no effect. I
> can send a version of the patch that does this with a comment explaining
> what is going on with set_pageblock_order() if you like.
> 
> However, in a follow-up fix, you make pageblock_default_order() a static
> inline. If it tries to return HUGETLB_PAGE_ORDER, it will fail to compile
> when CONFIG_HUGETLB_PAGE is not set.
> 
> Which would you prefer?

Don't care really.  Something which is fixed up ;)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbXEULiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbXEULiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 07:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbXEULh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 07:37:58 -0400
Received: from holomorphy.com ([66.93.40.71]:36357 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbXEULh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 07:37:58 -0400
Date: Mon, 21 May 2007 04:37:47 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: that page count overflow thing
Message-ID: <20070521113747.GK19966@holomorphy.com>
References: <20070519.152649.102577495.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070519.152649.102577495.davem@davemloft.net>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 03:26:49PM -0700, David Miller wrote:
> I think we may be able to fix that one without making the
> counter larger, it's silly overhead for such an extreme
> case IMHO.
> Perhaps it might be possible to just make the counter stick at it's
> maximum, and when it's there we have an rbtree of external "large"
> counters, keyed by page struct address.
> So basically externalize counters that go over the maximally
> representable value.  In this way only the idiotic cases pay
> the price.

This could be awkward with allocation requirements. How about an
open-addressed hash table? It can be made so large as to never
need to expand in advance with a very small constant factor space
overhead.


-- wli

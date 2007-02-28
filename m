Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbXB1SOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbXB1SOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 13:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932078AbXB1SOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 13:14:33 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54743 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932065AbXB1SOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 13:14:33 -0500
Date: Wed, 28 Feb 2007 10:14:30 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrew Morton <akpm@osdl.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/5] Lumpy Reclaim V3
In-Reply-To: <96f80944962593738d72a803797dbddc@kernel>
Message-ID: <Pine.LNX.4.64.0702281008330.21257@schroedinger.engr.sgi.com>
References: <exportbomb.1172604830@kernel> <96f80944962593738d72a803797dbddc@kernel>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Feb 2007, Andy Whitcroft wrote:

> +static int __isolate_lru_page(struct page *page, int active)
> +{
> +	int ret = -EINVAL;
> +
> +	if (PageLRU(page) && (PageActive(page) == active)) {
> +		ret = -EBUSY;
> +		if (likely(get_page_unless_zero(page))) {
> +			/*
> +			 * Be careful not to clear PageLRU until after we're
> +			 * sure the page is not being freed elsewhere -- the
> +			 * page release code relies on it.
> +			 */
> +			ClearPageLRU(page);
> +			ret = 0;

Is that really necessary? PageLRU is clear when a page is freed right? 
And clearing PageLRU requires the zone->lru_lock since we have to move it 
off the LRU.

> -			ClearPageLRU(page);
> -			target = dst;
> +		active = PageActive(page);

Why are we saving the active state? Page cannot be moved between LRUs 
while we hold the lru lock anyways.

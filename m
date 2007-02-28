Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbXB1SRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbXB1SRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 13:17:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932194AbXB1SRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 13:17:06 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54901 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932190AbXB1SRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 13:17:05 -0500
Date: Wed, 28 Feb 2007 10:17:03 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrew Morton <akpm@osdl.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/5] lumpy: isolate_lru_pages wants to specifically take
 active or inactive pages
In-Reply-To: <f2cdac47f652dc10d19f6041997e85b1@kernel>
Message-ID: <Pine.LNX.4.64.0702281015340.21257@schroedinger.engr.sgi.com>
References: <exportbomb.1172604830@kernel> <f2cdac47f652dc10d19f6041997e85b1@kernel>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Feb 2007, Andy Whitcroft wrote:

> The caller of isolate_lru_pages specifically knows whether it wants
> to take either inactive or active pages.  Currently we take the
> state of the LRU page at hand and use that to scan for matching
> pages in the order sized block.  If that page is transiting we
> can scan for the wrong type.  The caller knows what they want and
> should be telling us.  Pass in the required active/inactive state
> and match against that.

The page cannot be transiting since we hold the lru lock?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbZGHVcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbZGHVcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbZGHVcC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:32:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755522AbZGHVcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:32:01 -0400
Date: Wed, 8 Jul 2009 14:29:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: kamezawa.hiroyu@jp.fujitsu.com, narayanan.g@samsung.com,
       linux-mm@kvack.org, cl@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, stable@kernel.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Performance degradation seen after using one list for hot/cold
 pages.
Message-Id: <20090708142946.83c40331.akpm@linux-foundation.org>
In-Reply-To: <20090622100632.GB3981@csn.ul.ie>
References: <70875432E21A4185AD2E007941B6A792@sisodomain.com>
	<20090622164147.720683f8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090622100632.GB3981@csn.ul.ie>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc stable, linux-kernel and linux-scsi)

> On Mon, 22 Jun 2009 11:06:32 +0100 Mel Gorman <mel@csn.ul.ie> wrote:
> [PATCH] page-allocator: Preserve PFN ordering when __GFP_COLD is set
> 
> The page allocator tries to preserve contiguous PFN ordering when returning
> pages such that repeated callers to the allocator have a strong chance of
> getting physically contiguous pages, particularly when external fragmentation
> is low. However, of the bulk of the allocations have __GFP_COLD set as
> they are due to aio_read() for example, then the PFNs are in reverse PFN
> order. This can cause performance degration when used with IO
> controllers that could have merged the requests.
> 
> This patch attempts to preserve the contiguous ordering of PFNs for
> users of __GFP_COLD.

Thanks.

I'll add the rather important text:

  Fix a post-2.6.24 performance regression caused by
  3dfa5721f12c3d5a441448086bee156887daa961 ("page-allocator: preserve PFN
  ordering when __GFP_COLD is set").

This was a pretty major screwup.

This is why changing core MM is so worrisome - there's so much secret and
subtle history to it, and performance dependencies are unobvious and quite
indirect and the lag time to discover regressions is long.

Narayanan, are you able to quantify the regression more clearly?  All I
have is "2 MBps lower" which isn't very useful.  What is this as a
percentage, and with what sort of disk controller?  Thanks.


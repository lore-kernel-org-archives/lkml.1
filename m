Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbZJALxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbZJALxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 07:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756500AbZJALxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 07:53:21 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:51569 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756482AbZJALxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 07:53:20 -0400
X-Trace: 265430322/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.10.79/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.10.79
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEADY1xEpPRQpP/2dsb2JhbACBUNRzhCkE
X-IronPort-AV: E=Sophos;i="4.44,487,1249254000"; 
   d="scan'208";a="265430322"
Date: Thu, 1 Oct 2009 12:53:14 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Suresh Jayaraman <sjayaraman@suse.de>
cc: Rafael Wysocki <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] swapfile: avoid NULL pointer dereference in swapon when
 s_bdev is NULL
In-Reply-To: <4AC492E2.7060205@suse.de>
Message-ID: <Pine.LNX.4.64.0910011252220.13515@sister.anvils>
References: <4AC1FC41.2060807@suse.de> <Pine.LNX.4.64.0910011052330.7682@sister.anvils>
 <4AC492E2.7060205@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009, Suresh Jayaraman wrote:
> 
> Yeah, perhaps. I stumbled upon one more of such error - a NULL pointer
> dereference in blkdev_issue_discard() called from get_swap_page() when I ran
> memhog, a simple program to generate a memory hog with Swap over NFS patches.
> 
> The call sequence is add_to_swap() -> get_swap_page() ->  scan_swap_map()
> -> discard_swap_cluster() -> blkdev_issue_discard().
> 
> Wrapping the code around a NULL check fixes the Oops for me.

That's odd: scan_swap_map() should only discard_swap_cluster() if
SWP_DISCARDABLE got set, and your first patch made sure that it wasn't.

So I don't think this second patch should be necessary: you did have
your first applied when you found this?

I wonder if there's a funny little issue like si->lowest_alloc not
being reset to 0 where it should be.  Were you switching between
NFS swap and SSD swap in your testing?

Hugh

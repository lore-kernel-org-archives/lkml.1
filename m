Return-Path: <linux-kernel-owner+w=401wt.eu-S2993132AbXEBNSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993132AbXEBNSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 09:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993144AbXEBNSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 09:18:00 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33774 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993132AbXEBNR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 09:17:59 -0400
Date: Wed, 2 May 2007 14:17:45 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: mm-more-rmap-checking
In-Reply-To: <4637EC95.2010501@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0705021355390.16517@blonde.wat.veritas.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705011458060.16979@blonde.wat.veritas.com>
 <4637EC95.2010501@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 02 May 2007 13:17:58.0917 (UTC) FILETIME=[4DBAB350:01C78CBC]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBsaW51eC1tbUBrdmFjay5vcmcAbmlja3BpZ2dpbkB5YWhvby5jb20uYXUA
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Nick Piggin wrote:
> 
> Yes, but IIRC I put that in because there was another check in
> SLES9 that I actually couldn't put in, but used this one instead
> because it also caught the bug we saw.
>... 
> This was actually a rare corruption that is also in 2.6.21, and
> as few rmap callsites as we have, it was never noticed until the
> SLES9 bug check was triggered.

You are being very mysterious.  Please describe this bug (privately
if you think it's exploitable), and let's work on the patch to fix it,
rather than this "debug" patch.

> Hmm, I didn't notice the do_swap_page change, rather just derived
> its safety by looking at the current state of the code (which I
> guess must have been post-do_swap_page change)...

Your addition of page_add_new_anon_rmap clarified the situation too.

> Do you have a pointer to the patch, for my interest?

The patch which changed do_swap_page?

commit c475a8ab625d567eacf5e30ec35d6d8704558062
Author: Hugh Dickins <hugh@veritas.com>
Date:   Tue Jun 21 17:15:12 2005 -0700
[PATCH] can_share_swap_page: use page_mapcount

Or my intended PG_swapcache to PAGE_MAPPING_SWAP patch,
which does assume PageLocked in page_add_anon_rmap?
Yes, I can send you its current unsplit state if you like
(but have higher priorities before splitting and commenting
it for posting).

Hugh

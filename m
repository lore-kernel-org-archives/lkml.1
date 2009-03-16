Return-Path: <linux-kernel-owner+w=401wt.eu-S1761309AbZCPS4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761309AbZCPS4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbZCPSy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:54:58 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:33283 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162AbZCPSy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:54:56 -0400
Date: Mon, 16 Mar 2009 12:17:15 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 23/35] Update NR_FREE_PAGES only as necessary
In-Reply-To: <1237196790-7268-24-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903161214080.32577@qirst.com>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-24-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009, Mel Gorman wrote:

> When pages are being freed to the buddy allocator, the zone
> NR_FREE_PAGES counter must be updated. In the case of bulk per-cpu page
> freeing, it's updated once per page. This retouches cache lines more
> than necessary. Update the counters one per per-cpu bulk free.

Not sure about the reasoning here since the individual updates are batched
and you are touching the same cacheline as the pcp you are operating on
and have to touch anyways.

But if its frequent that __rmqueue_smallest() and free_pages_bulk() are
called with multiple pages then its always a win.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

> +	__mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << order) * i);

A multiplication? Okay with contemporary cpus I guess.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbZBXRkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbZBXRkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758798AbZBXRkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:40:19 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:45034 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757936AbZBXRkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:40:17 -0500
Date: Tue, 24 Feb 2009 12:31:41 -0500 (EST)
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
Subject: Re: [PATCH 10/19] Calculate the preferred zone for allocation only
 once
In-Reply-To: <1235477835-14500-11-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0902241229450.32227@qirst.com>
References: <1235477835-14500-1-git-send-email-mel@csn.ul.ie> <1235477835-14500-11-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, Mel Gorman wrote:

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 6f26944..074f9a6 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1399,24 +1399,19 @@ static void zlc_mark_zone_full(struct zonelist *zonelist, struct zoneref *z)
>   */
>  static struct page *
>  get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
> -		struct zonelist *zonelist, int high_zoneidx, int alloc_flags)
> +		struct zonelist *zonelist, int high_zoneidx, int alloc_flags,
> +		struct zone *preferred_zone)
>  {

This gets into a quite a number of parameters now. Pass a structure like in
vmscan.c? Or simplify things to be able to run get_page_from_freelist with
less parameters? The number of parameters seem to be too high for a
fastpath function.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbYHROKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbYHROKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbYHROJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:09:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589AbYHROJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:09:58 -0400
Message-ID: <48A98259.7030101@linux-foundation.org>
Date: Mon, 18 Aug 2008 09:08:25 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Matthew Wilcox <matthew@wil.cx>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <48A5DC22.5010507@linux-foundation.org> <20080818190407.60D4.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080818193143.60D7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080818193143.60D7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

> new patch is here.
> 
> Index: b/mm/slub.c
> ===================================================================
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1326,9 +1326,11 @@ static struct page *get_any_partial(stru
>          * expensive if we do it every time we are trying to find a slab
>          * with available objects.
>          */
> +#if 0
>         if (!s->remote_node_defrag_ratio ||
>                         get_cycles() % 1024 > s->remote_node_defrag_ratio)
>                 return NULL;
> +#endif
> 
>         zonelist = node_zonelist(slab_node(current->mempolicy), flags);
>         for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {

Hmmm.... So always take from partial lists works? That is the same effect that
the setting of the remote_defrag_ratio to 100 should have had (its multiplied
by 10 when storing it).

So its a NUMA only phenomenon. How is performance affected?

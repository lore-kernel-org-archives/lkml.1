Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbZEDAiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbZEDAiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 20:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbZEDAiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 20:38:15 -0400
Received: from smtp-out.google.com ([216.239.45.13]:60827 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbZEDAiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 20:38:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=YPlfwuIw82uhbjlFD2zC2KESDh5TjQp+xzo+JCTsw3sNZa1k1p67aJ1FyukzdB2J/
	eJbiDa+I6KRClx5zfHapw==
Date: Sun, 3 May 2009 17:38:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Wu Fengguang <fengguang.wu@intel.com>, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
In-Reply-To: <200905040210.10153.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.0905031734190.24114@chino.kir.corp.google.com>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905031830.49690.rjw@sisk.pl> <200905040208.43040.rjw@sisk.pl> <200905040210.10153.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009, Rafael J. Wysocki wrote:

> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -1620,7 +1620,8 @@ nofail_alloc:
>  		}
>  
>  		/* The OOM killer will not help higher order allocs so fail */
> -		if (order > PAGE_ALLOC_COSTLY_ORDER) {
> +		if (order > PAGE_ALLOC_COSTLY_ORDER ||
> +				(gfp_mask & __GFP_NO_OOM_KILL)) {
>  			clear_zonelist_oom(zonelist, gfp_mask);
>  			goto nopage;
>  		}

This is inconsistent because __GFP_NO_OOM_KILL now implies __GFP_NORETRY 
(the "goto nopage" above), but only for allocations with __GFP_FS set and 
__GFP_NORETRY clear.

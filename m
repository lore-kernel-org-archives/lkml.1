Return-Path: <linux-kernel-owner+w=401wt.eu-S932793AbYDBWF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793AbYDBWF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbYDBWFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:05:47 -0400
Received: from relay1.sgi.com ([192.48.171.29]:44046 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753228AbYDBWFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:05:46 -0400
Date: Wed, 2 Apr 2008 15:03:12 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: akpm@linux-foundation.org, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2 of 8] Moves all mmu notifier methods outside the PT
 lock (first and not last
In-Reply-To: <fe00cb9deeb314673963.1207171803@duo.random>
Message-ID: <Pine.LNX.4.64.0804021459560.31247@schroedinger.engr.sgi.com>
References: <fe00cb9deeb314673963.1207171803@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Andrea Arcangeli wrote:

> diff --git a/mm/memory.c b/mm/memory.c
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1626,9 +1626,10 @@
>  			 */
>  			page_table = pte_offset_map_lock(mm, pmd, address,
>  							 &ptl);
> -			page_cache_release(old_page);
> +			new_page = NULL;
>  			if (!pte_same(*page_table, orig_pte))
>  				goto unlock;
> +			page_cache_release(old_page);
>  
>  			page_mkwrite = 1;
>  		}

This is deferring frees and not moving the callouts. KVM specific? What 
exactly is this doing?

A significant portion of this seems to be undoing what the first patch 
did.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbZFDKGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbZFDKGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 06:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZFDKGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 06:06:43 -0400
Received: from cmpxchg.org ([85.214.51.133]:42039 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbZFDKGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 06:06:43 -0400
Date: Thu, 4 Jun 2009 12:04:36 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch][v2] swap: virtual swap readahead
Message-ID: <20090604100436.GA1602@cmpxchg.org>
References: <20090602223738.GA15475@cmpxchg.org> <20090604104628.99520342.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604104628.99520342.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 10:46:28AM +0900, KAMEZAWA Hiroyuki wrote:

> I wonder (I just wonder..) can we add code like following here ?
> 
>    /* we do _readahead_ here. Then, we don't want to add too much jobs to vm/IO*/
>    if (swp != entry)
> 	gfp_mask &= ~__GFP_WAIT
> > +		page = read_swap_cache_async(swp, gfp_mask, vma, pos);
> 
> too slow ?

Good idea, certainly worth evaluating.  But not in this patch, I don't
want to change _everything_ at once :-)

	Thanks, Hannes

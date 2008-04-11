Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbYDKI7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbYDKI7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758096AbYDKI7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:59:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757645AbYDKI7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:59:32 -0400
Date: Fri, 11 Apr 2008 10:59:28 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, pj@sgi.com,
       kniht@linux.vnet.ibm.com
Subject: Re: [patch 11/17] hugetlbfs: support larger than MAX_ORDER
Message-ID: <20080411085928.GC20253@wotan.suse.de>
References: <20080410170232.015351000@nick.local0.net> <20080410171101.551336000@nick.local0.net> <20080411081317.GQ10019@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411081317.GQ10019@one.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 10:13:17AM +0200, Andi Kleen wrote:
> >  	spin_lock(&hugetlb_lock);
> > -	if (h->surplus_huge_pages_node[nid]) {
> > +	if (h->surplus_huge_pages_node[nid] && h->order <= MAX_ORDER) {
> 
> As Andrew Hastings pointed out earlier this all needs to be h->order < MAX_ORDER
> [got pretty much all the checks wrong off by one]. It won't affect anything
> on x86-64 but might cause problems on archs which have exactly MAX_ORDER
> sized huge pages.

Ah, hmm, I might have missed a couple of emails worth of feedback when
you last posted. Thanks for pointing this out, I'll read over them again.


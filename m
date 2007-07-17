Return-Path: <linux-kernel-owner+w=401wt.eu-S934128AbXGQUCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128AbXGQUCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbXGQUBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:01:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60162 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754202AbXGQUBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:01:50 -0400
Date: Tue, 17 Jul 2007 13:01:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Joe Jin <joe.jin@oracle.com>, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-Id: <20070717130118.bc78d31a.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707172044001.5286@blonde.wat.veritas.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
	<20070712221842.f5e47065.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0707171558470.26771@blonde.wat.veritas.com>
	<20070717093228.3a3638aa.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0707171818080.19489@blonde.wat.veritas.com>
	<20070717115849.9f5e435c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0707172044001.5286@blonde.wat.veritas.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 20:49:25 +0100 (BST) Hugh Dickins <hugh@veritas.com> wrote:

> --- 2.6.22-git9/mm/hugetlb.c	2007-07-17 20:29:33.000000000 +0100
> +++ linux/mm/hugetlb.c	2007-07-17 20:32:51.000000000 +0100
> @@ -107,15 +107,12 @@ static int alloc_fresh_huge_page(void)
>  {
>  	static int prev_nid;
>  	struct page *page;
> -	static DEFINE_SPINLOCK(nid_lock);
>  	int nid;
>  
> -	spin_lock(&nid_lock);
>  	nid = next_node(prev_nid, node_online_map);
>  	if (nid == MAX_NUMNODES)
>  		nid = first_node(node_online_map);
>  	prev_nid = nid;
> -	spin_unlock(&nid_lock);

Given that we've now gone and added deliberate-but-we-hope-benign 
races into this code, an elaborate comment which explains and justifies
it all is pretty much obligatory, IMO.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757770AbYFJTA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbYFJTA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbYFJTAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:00:51 -0400
Received: from relay2.sgi.com ([192.48.171.30]:54699 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751955AbYFJTAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:00:50 -0400
Date: Tue, 10 Jun 2008 12:00:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: npiggin@suse.de
cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org
Subject: Re: [patch 7/7] powerpc: lockless get_user_pages_fast
In-Reply-To: <20080605094826.128415000@nick.local0.net>
Message-ID: <Pine.LNX.4.64.0806101159110.17798@schroedinger.engr.sgi.com>
References: <20080605094300.295184000@nick.local0.net>
 <20080605094826.128415000@nick.local0.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008, npiggin@suse.de wrote:

> Index: linux-2.6/include/linux/mm.h
> ===================================================================
> --- linux-2.6.orig/include/linux/mm.h
> +++ linux-2.6/include/linux/mm.h
> @@ -244,7 +244,7 @@ static inline int put_page_testzero(stru
>   */
>  static inline int get_page_unless_zero(struct page *page)
>  {
> -	VM_BUG_ON(PageTail(page));
> +	VM_BUG_ON(PageCompound(page));
>  	return atomic_inc_not_zero(&page->_count);
>  }

This is reversing the modification to make get_page_unless_zero() usable 
with compound page heads. Will break the slab defrag patchset.



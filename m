Return-Path: <linux-kernel-owner+w=401wt.eu-S1761198AbXIZTbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761198AbXIZTbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755938AbXIZTbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:31:41 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:21902 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbXIZTbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:31:40 -0400
Date: Wed, 26 Sep 2007 20:31:02 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: clameter@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       ricknu-0@student.ltu.se, magnus.damm@gmail.com
Subject: Re: [RFC][PATCH] page->mapping clarification [1/3] base functions
In-Reply-To: <20070922034234.bdb947e4.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0709262015030.7064@blonde.wat.veritas.com>
References: <20070919164308.281f9960.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0709201120510.8801@schroedinger.engr.sgi.com>
 <20070921095054.6386bae1.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0709211716220.20783@blonde.wat.veritas.com>
 <20070922034234.bdb947e4.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2007, KAMEZAWA Hiroyuki wrote:
> On Fri, 21 Sep 2007 18:02:47 +0100 (BST)
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > Or should I now leave PG_swapcache as is,
> > given your designs on page->mapping?
> > 
>  will conflict with my idea ?
> ==
> http://marc.info/?l=linux-mm&m=118956492926821&w=2
> ==

I asked because I had thought it would be a serious conflict: obviously
the patches as such would conflict quite a bit, but that's not serious,
one or the other just gets fixed up.

But now I don't see it - we both want to grab a further bit from the
low bits of the page->mapping pointer, you PAGE_MAPPING_INFO and me
PAGE_MAPPING_SWAP; but that's okay, so long as whoever is left using
bit (1<<2) is careful about the 32-bit case and remembers to put
__attribute__((aligned(sizeof(long long))))
on the declarations of struct address_space and struct anon_vma
and your struct page_mapping_info.

Would that waste a little memory?  I think not with SLUB,
but perhaps with SLOB, which packs a little tighter.

Hugh

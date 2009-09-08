Return-Path: <linux-kernel-owner+w=401wt.eu-S1752416AbZIHXfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbZIHXfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbZIHXfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:35:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbZIHXfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:35:19 -0400
Message-ID: <4AA6EA27.70407@redhat.com>
Date: Tue, 08 Sep 2009 19:35:03 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 7/8] mm: reinstate ZERO_PAGE
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils> <Pine.LNX.4.64.0909072238320.15430@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909072238320.15430@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> KAMEZAWA Hiroyuki has observed customers of earlier kernels taking
> advantage of the ZERO_PAGE: which we stopped do_anonymous_page() from
> using in 2.6.24.  And there were a couple of regression reports on LKML.
> 
> Following suggestions from Linus, reinstate do_anonymous_page() use of
> the ZERO_PAGE; but this time avoid dirtying its struct page cacheline
> with (map)count updates - let vm_normal_page() regard it as abnormal.
> 
> Use it only on arches which __HAVE_ARCH_PTE_SPECIAL (x86, s390, sh32,
> most powerpc): that's not essential, but minimizes additional branches
> (keeping them in the unlikely pte_special case); and incidentally
> excludes mips (some models of which needed eight colours of ZERO_PAGE
> to avoid costly exceptions).
> 
> Don't be fanatical about avoiding ZERO_PAGE updates: get_user_pages()
> callers won't want to make exceptions for it, so increment its count
> there.  Changes to mlock and migration? happily seems not needed.
> 
> In most places it's quicker to check pfn than struct page address:
> prepare a __read_mostly zero_pfn for that.  Does get_dump_page()
> still need its ZERO_PAGE check? probably not, but keep it anyway.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.

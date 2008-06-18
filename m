Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbYFRH0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbYFRH0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 03:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbYFRH0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 03:26:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50139 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYFRH0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 03:26:33 -0400
Date: Wed, 18 Jun 2008 16:26:09 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -mm][BUGFIX] migration_entry_wait fix. v2
Cc: kosaki.motohiro@jp.fujitsu.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       "hugh@veritas.com" <hugh@veritas.com>
In-Reply-To: <20080618162944.2f8fd265.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080618155233.7dd79312.kamezawa.hiroyu@jp.fujitsu.com> <20080618162944.2f8fd265.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20080618162532.37B0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In speculative page cache look up protocol, page_count(page) is set to 0
> while radix-tree modification is going on, truncation, migration, etc...
> 
> While page migration, a page fault to page under migration does
>  - look up page table
>  - find it is migration_entry_pte
>  - decode pfn from migration_entry_pte and get page of pfn_page(pfn)
>  - wait until page is unlocked 
> 
> It does get_page() -> wait_on_page_locked() -> put_page() now.
> 
> In page migration's radix-tree replacement, page_freeze_refs() ->
> page_unfreeze_refs() is called. And page_count(page) turns to be zero
> and must be kept to be zero while radix-tree replacement.
> 
> If get_page() is called against a page under radix-tree replacement,
> the kernel panics(). To avoid this, we shouldn't increment page_count()
> if it is zero. This patch uses get_page_unless_zero().
> 
> Even if get_page_unless_zero() fails, the caller just retries.
> But will be a bit busier.

Great!
	Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



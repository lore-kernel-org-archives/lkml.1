Return-Path: <linux-kernel-owner+w=401wt.eu-S1765066AbXGZQJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765066AbXGZQJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758728AbXGZQJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:09:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49219 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758081AbXGZQJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:09:05 -0400
Date: Fri, 27 Jul 2007 01:08:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] flush icache before set_pte on ia64 take3
Message-Id: <20070727010825.a5934cb0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <46A8BA30.7000508@bull.net>
References: <20070726171323.a9c17eda.kamezawa.hiroyu@jp.fujitsu.com>
	<46A8BA30.7000508@bull.net>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 17:13:52 +0200
Zoltan Menyhart <Zoltan.Menyhart@bull.net> wrote:

> I can agree:
> - lazy_mmu_prot_update() is not the right place for a flush
> - to flush I-cache before inserting PTE (at least for the
>   machines with physical address tagged caches)
> 
> Can we have a separate, specific exec_flush_phtag_icache_page()
> that is to be called before inserting a PTE with the exec bit on
> for physical address tagged I-caches) ?
> It is defined in asm-generic/cacheflush.h as NO-OP.
> 
> Or exec_flush_icache_page_before_set_pte() ?
> 
Thank you for advise. Hmm..how about this ?
==
 /*
  * synchronize icache and dcache if the hardware doesn't do it automatically
  * and the page is executable.
  */
static inline arch_sync_icache_dcache(pte_t pte, page) {

}
==

Anyway, I understand your point. Thanks!

Regards,
- Kame

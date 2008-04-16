Return-Path: <linux-kernel-owner+w=401wt.eu-S1759909AbYDPBpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909AbYDPBpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 21:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYDPBpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 21:45:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58185 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbYDPBpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 21:45:24 -0400
Date: Wed, 16 Apr 2008 10:48:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org
Subject: Re: [patch] mm: sparsemem memory_present() memory corruption fix
Message-Id: <20080416104854.b481237e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080416000356.GA24737@elte.hu>
References: <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org>
	<20080415161532.GA15088@elte.hu>
	<alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org>
	<Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com>
	<20080415195430.GA23015@elte.hu>
	<Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com>
	<20080415201734.GA25628@elte.hu>
	<4805115D.5030703@cs.helsinki.fi>
	<20080415204025.GA29784@elte.hu>
	<alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org>
	<20080416000356.GA24737@elte.hu>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm sorry to be too late here..

On Wed, 16 Apr 2008 02:03:56 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  mm/sparse.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> Index: linux/mm/sparse.c
> ===================================================================
> --- linux.orig/mm/sparse.c
> +++ linux/mm/sparse.c
> @@ -149,8 +149,18 @@ static inline int sparse_early_nid(struc
>  /* Record a memory area against a node. */
>  void __init memory_present(int nid, unsigned long start, unsigned long end)
>  {
> +	unsigned long max_arch_pfn = 1ULL << (MAX_PHYSMEM_BITS-PAGE_SHIFT);
>  	unsigned long pfn;
>  
how about

max_arch_pfn = NR_MEM_SECTIONS * PAGES_PER_SECTION.

?
Thanks,
-Kame


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761206AbYDPRuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761206AbYDPRuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYDPRtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:49:55 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:26365 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbYDPRty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:49:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KpymU0HlDtDOUG6FZ1+Fn0vovTr8irYHUphpiWY+jVBS/DMSMyeYDFEGWk8HohTYsjrIC6M9wV+BmcEc0E1ch0p77IP3h287YdQehxvkfIT32Vnv9vhfiCga09a2TbmhP87Atg6mTcqniYa7TJ9dBIJVnRBYJ7jgNVfD0NnaLQw=
Message-ID: <86802c440804161049l1e4bc00cjb51b0a4267dd2adc@mail.gmail.com>
Date: Wed, 16 Apr 2008 10:49:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [RFC][patch 1/5] mm: Revert "mm: fix boundary checking in free_bootmem_core"
Cc: LKML <linux-kernel@vger.kernel.org>, "Linux MM" <linux-mm@kvack.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080416113718.946786067@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080416113629.947746497@skyscraper.fehenstaub.lan>
	 <20080416113718.946786067@skyscraper.fehenstaub.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 4:36 AM, Johannes Weiner <hannes@saeurebad.de> wrote:
> This reverts commit 5a982cbc7b3fe6cf72266f319286f29963c71b9e.
>
>  The intention behind this patch was to make the free_bootmem()
>  interface more robust with regards to the specified range and to let
>  it operate on multiple node setups as well.
>
>  However, it made free_bootmem_core()
>
>   1. handle bogus node/memory-range combination input by just
>      returning early without informing the callsite or screaming BUG()
>      as it did before
>   2. round slightly out of node-range values to the node boundaries
>      instead of treating them as the invalid parameters they are
>
>  This was partially done to abuse free_bootmem_core() for node
>  iteration in free_bootmem (just feeding it every node on the box and
>  let it figure out what it wants to do with it) instead of looking up
>  the proper node before the call to free_bootmem_core().
>
>  It also affects free_bootmem_node() which relies on
>  free_bootmem_core() and on its sanity checks now removed.
>
>  Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>  CC: Yinghai Lu <yhlu.kernel@gmail.com>
>  CC: Andi Kleen <andi@firstfloor.org>
>  CC: Yasunori Goto <y-goto@jp.fujitsu.com>
>  CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>  CC: Ingo Molnar <mingo@elte.hu>
>  CC: Christoph Lameter <clameter@sgi.com>
>  CC: Andrew Morton <akpm@linux-foundation.org>
>  ---
>   mm/bootmem.c |   25 ++++++-------------------
>   1 files changed, 6 insertions(+), 19 deletions(-)
>
>  diff --git a/mm/bootmem.c b/mm/bootmem.c
>  index 2ccea70..f6ff433 100644
>  --- a/mm/bootmem.c
>  +++ b/mm/bootmem.c
>  @@ -125,7 +125,6 @@ static int __init reserve_bootmem_core(bootmem_data_t *bdata,
>         BUG_ON(!size);
>         BUG_ON(PFN_DOWN(addr) >= bdata->node_low_pfn);
>         BUG_ON(PFN_UP(addr + size) > bdata->node_low_pfn);
>  -       BUG_ON(addr < bdata->node_boot_start);
>
>         sidx = PFN_DOWN(addr - bdata->node_boot_start);
>         eidx = PFN_UP(addr + size - bdata->node_boot_start);

can you keep the change with reserve_bootmem_core? another patch
regarding reserve_bootmem will update it further.

YH

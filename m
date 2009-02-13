Return-Path: <linux-kernel-owner+w=401wt.eu-S1760872AbZBMXi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760872AbZBMXi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 18:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZBMXiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 18:38:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51404 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbZBMXiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 18:38:19 -0500
Message-ID: <2d734ee52c2801a284a4c8fa2d76dc49.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090213142032.09b4a4da.akpm@linux-foundation.org>
References: <20090212161920.deedea35.kamezawa.hiroyu@jp.fujitsu.com>
    <20090212162203.db3f07cb.kamezawa.hiroyu@jp.fujitsu.com>
    <20090213142032.09b4a4da.akpm@linux-foundation.org>
Date: Sat, 14 Feb 2009 08:38:16 +0900 (JST)
Subject: Re: [PATCH 1/2] clean up for early_pfn_to_nid
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kosaki.motohiro@jp.fujitsu.com, davem@davemlloft.net,
       heiko.carstens@de.ibm.com, stable@kernel.org
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 12 Feb 2009 16:22:03 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> Declaration of early_pfn_to_nid() is scattered over per-arch include
>> files,
>> and it seems it's complicated to know when the declaration is used.
>> I think it makes fix-for-memmap-init not easy.
>>
>> This patch moves all declaration to include/linux/mm.h
>>
>> After this,
>>   if !CONFIG_NODES_POPULATES_NODE_MAP &&
>> !CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
>>      -> Use static definition in include/linux/mm.h
>>   else if !CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
>>      -> Use generic definition in mm/page_alloc.c
>>   else
>>      -> per-arch back end function will be called.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> ---
>>  arch/ia64/include/asm/mmzone.h   |    4 ----
>>  arch/ia64/mm/numa.c              |    2 +-
>>  arch/x86/include/asm/mmzone_32.h |    2 --
>>  arch/x86/include/asm/mmzone_64.h |    2 --
>>  arch/x86/mm/numa_64.c            |    2 +-
>>  include/linux/mm.h               |   19 ++++++++++++++++---
>>  mm/page_alloc.c                  |    8 +++++++-
>>  7 files changed, 25 insertions(+), 14 deletions(-)
>
> It's rather unfortunate that this bugfix includes a fair-sized cleanup
> patch, because we should backport it into 2.6.28.x.
>
> Oh well.
>
Sorry..but this part was too ugly to write a patch that convince me
this patch is correct. If I should rewrite, I'll do.

> I queued these as
>
> mm-clean-up-for-early_pfn_to_nid.patch
> mm-fix-memmap-init-for-handling-memory-hole.patch
>
> and tagged them as needed-in-2.6.28.x.  I don't recall whether they are
> needed in earlier -stable releases?
>
Maybe necessary for some machines, which may access memory holes.

> I don't have a record here of davem having tested these new patches, btw
> ;)
Sorry for bad CC.
This fix's logic itself is not different from original one.

-Kame






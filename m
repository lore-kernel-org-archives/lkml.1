Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYIMRY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYIMRY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 13:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYIMRYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 13:24:50 -0400
Received: from cpsmtpo-eml04.kpnxchange.com ([213.75.38.153]:14267 "EHLO
	cpsmtpo-eml04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380AbYIMRYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 13:24:49 -0400
From: Frans Pop <elendil@planet.nl>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [patch 1/2] x86: track memtype for RAM in page struct
Date: Sat, 13 Sep 2008 19:24:45 +0200
User-Agent: KMail/1.9.9
Cc: arjan@linux.intel.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       andi@firstfloor.org, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, venkatesh.pallipadi@intel.com
References: <20080913000003.732756000@linux-os.sc.intel.com> <20080913000051.819383000@linux-os.sc.intel.com>
In-reply-To: <20080913000051.819383000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809131924.46859.elendil@planet.nl>
X-OriginalArrivalTime: 13 Sep 2008 17:24:47.0372 (UTC) FILETIME=[9ECC9CC0:01C915C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrections for a few typos and some suggestions for minor improvements
in the comment.

Cheers,
FJP

Venkatesh Pallipadi wrote:
> --- tip.orig/arch/x86/mm/pat.c  2008-09-12 16:03:33.000000000 -0700
> +++ tip/arch/x86/mm/pat.c       2008-09-12 16:23:33.000000000 -0700
> @@ -211,6 +211,75 @@ static struct memtype *cached_entry;
> static u64 cached_start;
> 
> /*
> + * RED-PEN:  TODO: Add PageReserved() check aswell here,

"as well"

> + * once we add SetPageReserved() to all the drivers using
> + * set_memory_* or set_pages_*
> + *
> + * This will help prevent accidentally freeing pages
> + * before setting the attribute back to WB.
> + */
> +
> +/*
> + * For RAM pages, mark the pages with non WB attribute using

s/non WB/without the WB/ ?

> + * PG_arch_1. We allow only one set_memory_uc() or set_memory_wc()
> + * on a RAM page at a time before marking it as WB again. This is ok,
> + * because only one(driver) will be owning the page and doing

"one (driver)"
Maybe move "set_memory_*()" to next line (looks better).

> + * set_memory_*() calls.
> + *
> + * For now, we use PG_arch_1 to track that the RAM page is being mapped
> + * as non WB. In future, based on the need we can use one or more flags

s/based on the need/if needed,/

> + * (or some other mechanism in page_struct) to keep track of the actual
> + * attribute that the page is mapped to.
> + */

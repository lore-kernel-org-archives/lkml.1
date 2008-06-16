Return-Path: <linux-kernel-owner+w=401wt.eu-S1760392AbYFPHFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760392AbYFPHFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758031AbYFPHF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 03:05:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:55137 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759679AbYFPHFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:05:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZaoQHrZeQcmZglHzAmiGq2U5x1gaAJWAkp1VDngOAuSbnVlIHugQ37/Qp4wFZzkkaC
         e0g/srRgofmRzUnhWf1fNjtAejhYsDurW/zKloV+FjoYBOGT+m/cY83goO1/3PCB511l
         KcLlLKO4QDWOz/4MR2hNaFSJoqnercuF/vXY0=
Message-ID: <86802c440806160005q151ee44drac956dc0a3048643@mail.gmail.com>
Date: Mon, 16 Jun 2008 00:05:23 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH 7/8] x86 boot: show pfn addresses in hex not decimal in some kernel info printks
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Jack Steiner" <steiner@sgi.com>, "Mike Travis" <travis@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080616063016.14597.78459.sendpatchset@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	 <20080616063016.14597.78459.sendpatchset@polaris-admin.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 11:30 PM, Paul Jackson <pj@sgi.com> wrote:
> From: Paul Jackson <pj@sgi.com>
>
> Page frame numbers (the portion of physical addresses above the low
> order page offsets) are displayed in several kernel debug and info
> prints in decimal, not hex.  Decimal addresse are unreadable.  Use hex.
>
> Signed-off-by: Paul Jackson <pj@sgi.com>
>
> ---
>  arch/x86/kernel/e820.c |    2 +-
>  mm/page_alloc.c        |   12 ++++++------
>  2 files changed, 7 insertions(+), 7 deletions(-)
>
> --- linux.orig/arch/x86/kernel/e820.c   2008-06-15 21:51:59.643086905 -0700
> +++ linux/arch/x86/kernel/e820.c        2008-06-15 21:51:59.787095630 -0700
> @@ -816,7 +816,7 @@ unsigned long __init e820_end_of_ram(voi
>        if (last_pfn > end_user_pfn)
>                last_pfn = end_user_pfn;
>
> -       printk(KERN_INFO "last_pfn = %lu max_arch_pfn = %lu\n",
> +       printk(KERN_INFO "last_pfn = 0x%lx max_arch_pfn = 0x%lx\n",
>                         last_pfn, max_arch_pfn);
>        return last_pfn;
>  }
> --- linux.orig/mm/page_alloc.c  2008-06-15 21:51:56.890920168 -0700
> +++ linux/mm/page_alloc.c       2008-06-15 21:57:04.525557420 -0700
> @@ -529,7 +529,7 @@ static void __free_pages_ok(struct page
>        int i;
>        int reserved = 0;
>
> -       trace_mark(mm_page_free, "order %u pfn %lu",
> +       trace_mark(mm_page_free, "order %u pfn 0x%lx",
>                order, page_to_pfn(page));
>
>        for (i = 0 ; i < (1 << order) ; ++i)
> @@ -998,7 +998,7 @@ static void free_hot_cold_page(struct pa
>        struct per_cpu_pages *pcp;
>        unsigned long flags;
>
> -       trace_mark(mm_page_free, "order %u pfn %lu", 0, page_to_pfn(page));
> +       trace_mark(mm_page_free, "order %u pfn 0x%lx", 0, page_to_pfn(page));
>
>        if (PageAnon(page))
>                page->mapping = NULL;
> @@ -1665,7 +1665,7 @@ nopage:
>        }
>  got_pg:
>        if (page)
> -               trace_mark(mm_page_alloc, "order %u pfn %lu", order,
> +               trace_mark(mm_page_alloc, "order %u pfn 0x%lx", order,
>                           page_to_pfn(page));
>        return page;
>  }
> @@ -3546,7 +3546,7 @@ void __init add_active_range(unsigned in
>  {
>        int i;
>
> -       printk(KERN_DEBUG "Entering add_active_range(%d, %lu, %lu) "
> +       printk(KERN_DEBUG "Entering add_active_range(%d, 0x%lx, 0x%lx) "
>                          "%d entries of %d used\n",
>                          nid, start_pfn, end_pfn,
>                          nr_nodemap_entries, MAX_ACTIVE_REGIONS);
> @@ -3945,7 +3945,7 @@ void __init free_area_init_nodes(unsigne
>        for (i = 0; i < MAX_NR_ZONES; i++) {
>                if (i == ZONE_MOVABLE)
>                        continue;
> -               printk("  %-8s %8lu -> %8lu\n",
> +               printk("  %-8s 0x%8lx -> 0x%8lx\n",
>                                zone_names[i],
>                                arch_zone_lowest_possible_pfn[i],
>                                arch_zone_highest_possible_pfn[i]);
> @@ -3961,7 +3961,7 @@ void __init free_area_init_nodes(unsigne
>        /* Print out the early_node_map[] */
>        printk("early_node_map[%d] active PFN ranges\n", nr_nodemap_entries);
>        for (i = 0; i < nr_nodemap_entries; i++)
> -               printk("  %3d: %8lu -> %8lu\n", early_node_map[i].nid,
> +               printk("  %3d: 0x%8lx -> 0x%8lx\n", early_node_map[i].nid,
>                                                early_node_map[i].start_pfn,
>                                                early_node_map[i].end_pfn);
>

wonder if we need 0x?

YH

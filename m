Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbYC1B0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbYC1B0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 21:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYC1B0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 21:26:24 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48782 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbYC1B0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 21:26:24 -0400
Date: Fri, 28 Mar 2008 10:27:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] hotplug-memory: adding non-section-aligned
 memory is bad
Message-Id: <20080328102719.3ab9162b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <e0b16cc8349b38a5f3f9.1206664118@localhost>
References: <patchbomb.1206664116@localhost>
	<e0b16cc8349b38a5f3f9.1206664118@localhost>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008 17:28:38 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -784,6 +784,9 @@
>  #define PAGES_PER_SECTION       (1UL << PFN_SECTION_SHIFT)
>  #define PAGE_SECTION_MASK	(~(PAGES_PER_SECTION-1))
>  
> +#define SECTION_SIZE		(1UL << SECTION_SIZE_BITS)
> +#define SECTION_SIZE_MASK	(SECTION_SIZE - 1)
> +
>  #define SECTION_BLOCKFLAGS_BITS \
>  	((1UL << (PFN_SECTION_SHIFT - pageblock_order)) * NR_PAGEBLOCK_BITS)
>  
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -300,6 +300,11 @@
>  	int ret;
>  	u64 start = res->start;
>  	u64 size = res->end - res->start + 1;
> +
> +	/* Adding non-section-aligned memory will give unexpected
> +	   and unintuitive results. */
> +	WARN_ON((start & SECTION_SIZE_MASK) != 0);
> +	WARN_ON((size & SECTION_SIZE_MASK) != 0);
>  
Why just WARNING ? not BUG_ON?

Thanks,
-Kame


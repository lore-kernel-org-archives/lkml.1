Return-Path: <linux-kernel-owner+w=401wt.eu-S1160997AbXBGGdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160997AbXBGGdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 01:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965544AbXBGGdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 01:33:50 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36058 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965539AbXBGGdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 01:33:49 -0500
Date: Tue, 6 Feb 2007 22:33:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh@veritas.com>, Paul Mundt <lethal@linux-sh.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3 take2] smaps: add clear_refs file to clear reference
Message-Id: <20070206223336.74595ecc.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702062214400.13931@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0702062212550.13931@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0702062214070.13931@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0702062214400.13931@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007 22:15:59 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> +static void clear_refs_pte_func(struct pte_walker *walker, pte_t *pte,
> +				unsigned long addr)
> +{
> +	struct page *page;
> +	pte_t ptent;
> +
> +	ptent = *pte;
> +	if (!pte_present(ptent))
> +		return;
> +
> +	page = vm_normal_page(walker->vma, addr, ptent);
> +	if (!page)
> +		return;
> +	pte_mkold(ptent);

That only changed the local variable, and not the pagetable entry.

> +	ClearPageReferenced(page);
> +}

Please, do some good runtime testing.  Write a script to monitor the
overall working set, run it for some sample workloads (your X server or
mozilla would be good choices).  Share the results with us so we can marvel
at the efficiency of modern applications.  Include these examples in the
changelog.

Also, we will need to do tlb writeback and invalidation prior to this
operation.  Documentation/cachetlb.txt has details.

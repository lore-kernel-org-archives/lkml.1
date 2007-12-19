Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbXLSRPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbXLSRPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 12:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXLSRO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 12:14:57 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45132 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbXLSRO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 12:14:56 -0500
Subject: Re: [PATCH] Move page_assign_page_cgroup to VM_BUG_ON in
	free_hot_cold_page
From: Dave Hansen <haveblue@us.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20071219061834.8461.3974.sendpatchset@balbir-laptop>
References: <20071219061834.8461.3974.sendpatchset@balbir-laptop>
Content-Type: text/plain
Date: Wed, 19 Dec 2007 09:14:33 -0800
Message-Id: <1198084473.15321.48.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-19 at 11:48 +0530, Balbir Singh wrote:
> diff -puN mm/page_alloc.c~memory-controller-move-to-bug-on-in-free_hot_cold_page mm/page_alloc.c
> --- linux-2.6.24-rc5/mm/page_alloc.c~memory-controller-move-to-bug-on-in-free_hot_cold_page     2007-12-19 11:31:46.000000000 +0530
> +++ linux-2.6.24-rc5-balbir/mm/page_alloc.c     2007-12-19 11:33:45.000000000 +0530
> @@ -995,7 +995,7 @@ static void fastcall free_hot_cold_page(
>  
>         if (!PageHighMem(page))
>                 debug_check_no_locks_freed(page_address(page), PAGE_SIZE);
> -       page_assign_page_cgroup(page, NULL);
> +       VM_BUG_ON(page_get_page_cgroup(page));
>         arch_free_page(page, 0);
>         kernel_map_pages(page, 1, 0); 

Hi Balbir,

You generally want to do these like:

	foo = page_assign_page_cgroup(page, NULL);
	VM_BUG_ON(foo);

Some embedded people have been known to optimize kernel size like this:

	#define VM_BUG_ON(x) do{}while(0)

-- Dave


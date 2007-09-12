Return-Path: <linux-kernel-owner+w=401wt.eu-S1764045AbXILDXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764045AbXILDXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 23:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758014AbXILDXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 23:23:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47456 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757543AbXILDXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 23:23:44 -0400
Date: Tue, 11 Sep 2007 20:23:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX] x86_64: NX bit handling in change_page_attr
Message-Id: <20070911202332.c539f1fe.akpm@linux-foundation.org>
In-Reply-To: <1187328518.28497.6.camel@caritas-dev.intel.com>
References: <1187328518.28497.6.camel@caritas-dev.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007 13:28:38 +0800 "Huang, Ying" <ying.huang@intel.com> wrote:

> This patch fixes a bug of change_page_attr/change_page_attr_addr on
> Intel x86_64 CPU. After changing page attribute to be executable with
> these functions, the page remains un-executable on Intel x86_64
> CPU. Because on Intel x86_64 CPU, only if the "NX" bits of all four
> level page tables are cleared, the corresponding page is executable
> (refer to section 4.13.2 of Intel 64 and IA-32 Architectures Software
> Developer's Manual). So, the bug is fixed through clearing the "NX"
> bit of PMD when splitting the huge PMD.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
> 
> Index: linux-2.6.23-rc2-mm2/arch/x86_64/mm/pageattr.c
> ===================================================================
> --- linux-2.6.23-rc2-mm2.orig/arch/x86_64/mm/pageattr.c	2007-08-17 12:50:25.000000000 +0800
> +++ linux-2.6.23-rc2-mm2/arch/x86_64/mm/pageattr.c	2007-08-17 12:50:48.000000000 +0800
> @@ -147,6 +147,7 @@
>  			split = split_large_page(address, prot, ref_prot2);
>  			if (!split)
>  				return -ENOMEM;
> +			pgprot_val(ref_prot2) &= ~_PAGE_NX;
>  			set_pte(kpte, mk_pte(split, ref_prot2));
>  			kpte_page = split;
>  		}

What happened with this?  Still valid?

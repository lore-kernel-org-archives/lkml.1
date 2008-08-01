Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbYHABLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbYHABLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 21:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYHABLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 21:11:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:52278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbYHABLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 21:11:38 -0400
Date: Fri, 1 Aug 2008 03:11:37 +0200
From: Nick Piggin <npiggin@suse.de>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] powerpc/mm: Implement _PAGE_SPECIAL & pte_special() for 32-bit
Message-ID: <20080801011137.GA20407@wotan.suse.de>
References: <Pine.LNX.4.64.0807311345380.8012@blarg.am.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807311345380.8012@blarg.am.freescale.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 01:48:31PM -0500, Kumar Gala wrote:
> Implement _PAGE_SPECIAL and pte_special() for 32-bit powerpc. This bit will
> be used by the fast get_user_pages() to differenciate PTEs that correspond
> to a valid struct page from special mappings that don't such as IO mappings
> obtained via io_remap_pfn_ranges().
> 
> We currently only implement this on sub-arch that support SMP or will so
> in the future (6xx, 44x, FSL-BookE) and not (8xx, 40x).
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

Cool

> ---
> Nick, do you forsee using _PAGE_SPECIAL for other applications that would
> be of interested to non-SMP hw?
> 
> We can look at adding it into 8xx and 40x, but was being lazy as I assume
> there is no point.

I don't forsee it being used for anything else, but it is possible I guess.

We currently will also use it in the VM (vm_normal_page), turning
that function into a much more compact and simple version. It doesn't
do a great deal for performance, but you _may_ want to consider using it
just so the entire powerpc architecture takes this same path.

Not a big deal though.

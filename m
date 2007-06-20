Return-Path: <linux-kernel-owner+w=401wt.eu-S1761235AbXFTDCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761235AbXFTDCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 23:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759434AbXFTDC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 23:02:29 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:49695 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758504AbXFTDC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 23:02:28 -0400
Date: Wed, 20 Jun 2007 12:00:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Bernd Schmidt <bernds_cb1@t-online.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, "Wu, Bryan" <Bryan.Wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Ungerer <gerg@snapgear.com>
Subject: Re: [PATCH, RFD]: Unbreak no-mmu mmap
Message-ID: <20070620030052.GA29161@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Bernd Schmidt <bernds_cb1@t-online.de>,
	Robin Getz <rgetz@blackfin.uclinux.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	David Howells <dhowells@redhat.com>,
	"Wu, Bryan" <Bryan.Wu@analog.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Ungerer <gerg@snapgear.com>
References: <46695F6D.5050600@t-online.de> <200706191926.20210.rgetz@blackfin.uclinux.org> <46695F6D.5050600@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706191926.20210.rgetz@blackfin.uclinux.org> <46695F6D.5050600@t-online.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 03:53:49PM +0200, Bernd Schmidt wrote:
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 2b16b00..7480a95 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
[snip]
> +	/*
> +	 * Must always set the VM_SPLIT_PAGES flag for single-page allocations,
> +	 * to avoid trying to get the order of the compound page later on.
> +	 */
> +	if (len == PAGE_SIZE)
> +		vma->vm_flags |= VM_SPLIT_PAGES;
> +	else if (flags & MAP_SPLIT_PAGES

And now you've just broken every non-blackfin nommu platform, as you've
only defined MAP_SPLIT_PAGES in asm-blackfin/mman.h.

> +#ifdef CONFIG_NP2
> +	    || len < total_len
> +#endif

And what is this? It only shows up in the blackfin defconfig. This is not
the place to be putting board-specific hacks.

On Tue, Jun 19, 2007 at 07:26:19PM -0400, Robin Getz wrote:
> I'm assuming that since no one had any large objections, that this is OK, and 
> we should send to Andrew to live in -mm for awhile?
> 
No real objections to the approach, but it would be nice if these sorts
of things were test compiled for at least one platform that isn't yours,
so the obviously broken stuff is fixed before it's posted and someone
else has to find out about it later.

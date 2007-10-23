Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbXJWWdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbXJWWdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbXJWWcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:32:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46868 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504AbXJWWcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:32:50 -0400
Date: Tue, 23 Oct 2007 15:32:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Emil Medve <Emilian.Medve@freescale.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH rebased] Use the new sg_page() helper
In-Reply-To: <1193160745-16984-1-git-send-email-Emilian.Medve@Freescale.com>
Message-ID: <alpine.LFD.0.999.0710231530300.30120@woody.linux-foundation.org>
References: <1193160745-16984-1-git-send-email-Emilian.Medve@Freescale.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Oct 2007, Emil Medve wrote:
>  
> -		sg->dma_address = page_to_phys(sg->page) + sg->offset;
> +		sg->dma_address = page_to_phys(sg_page(sg)) + sg->offset;

This is "sg_phys(sg)"

> -		consistent_sync(page_address(sg->page) + sg->offset,
> +		consistent_sync(page_address(sg_page(sg)) + sg->offset,
> -		consistent_sync(page_address(sg->page) + sg->offset,
> +		consistent_sync(page_address(sg_page(sg)) + sg->offset,
> -		consistent_sync(page_address(sg->page) + sg->offset,
> +		consistent_sync(page_address(sg_page(sg)) + sg->offset,

Please write "page_address(sg_page(sg)) + sg->offset" as "sg_virt(sg)" 
instead.

And send the patch to Jens, since he's the person who is in charge of 
getting this all sorted out ;)

Ok?

		Linus

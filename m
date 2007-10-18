Return-Path: <linux-kernel-owner+w=401wt.eu-S1764973AbXJRQ4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764973AbXJRQ4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 12:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbXJRQ4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 12:56:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39163 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756901AbXJRQ4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 12:56:15 -0400
Date: Thu, 18 Oct 2007 09:55:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
In-Reply-To: <20071018082145.GK5063@kernel.dk>
Message-ID: <alpine.LFD.0.999.0710180952070.26902@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org>
 <20071018080048O.fujita.tomonori@lab.ntt.co.jp>
 <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org>
 <20071017.181907.63126798.davem@davemloft.net>
 <20071018082145.GK5063@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Oct 2007, Jens Axboe wrote:
> -		unsigned long addr = page_to_phys(s->page) + s->offset; 
> +		unsigned long addr = page_to_phys(sg_page(s)) + s->offset; 

Umm. May I suggest (I haven't read the whole thread yet, maybe somebody 
else already did) that

	static inline unsigned long sg_phys(struct scatterlist *sg)
	{
		return 	page_to_phys(sg_page(sg)) + sg->offset;
	}

would be a good thing to have?

Very few drivers should care so much about the *page* itself (or the 
offset). That's something that the generic allocation code etc cares 
about, but the driver is almost bound to care mostly about the actual DMA 
address, so adding that helper function that abstracts the sg access would 
be helpful in hiding some of the cruft?

		Linus

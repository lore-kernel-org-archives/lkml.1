Return-Path: <linux-kernel-owner+w=401wt.eu-S1757779AbYCKPfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbYCKPfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 11:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYCKPey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 11:34:54 -0400
Received: from vena.lwn.net ([206.168.112.25]:42088 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663AbYCKPex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 11:34:53 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [6/13] Core maskable allocator 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Fri, 07 Mar 2008 10:07:16 +0100."
             <20080307090716.9D3E91B419C@basil.firstfloor.org> 
Date: Tue, 11 Mar 2008 09:34:53 -0600
Message-ID: <26256.1205249693@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andi,

As I dig through this patch, I find it mostly makes sense; seems like it
could be a good idea.  I did have one little API question...

> +struct page *
> +alloc_pages_mask(gfp_t gfp, unsigned size, u64 mask)
> +{
> +	unsigned long max_pfn = mask >> PAGE_SHIFT;

The "mask" parameter isn't really a mask - it's an upper bound on the
address of the allocated memory.  Might it be better to call it
"max_addr" or "limit" or "ceiling" or some such so callers understand
for sure how it's interpreted?  The use of the term "mask" throughout
the interface could maybe create a certain amount of confusion.

Thanks,

jon

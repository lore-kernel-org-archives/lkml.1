Return-Path: <linux-kernel-owner+w=401wt.eu-S1757775AbYCKPw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775AbYCKPw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 11:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbYCKPwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 11:52:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49897 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbYCKPwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 11:52:50 -0400
Date: Tue, 11 Mar 2008 16:54:45 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [6/13] Core maskable allocator
Message-ID: <20080311155445.GB27593@one.firstfloor.org>
References: <20080307090716.9D3E91B419C@basil.firstfloor.org> <26256.1205249693@vena.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26256.1205249693@vena.lwn.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 09:34:53AM -0600, Jonathan Corbet wrote:
> Hi, Andi,
> 
> As I dig through this patch, I find it mostly makes sense; seems like it
> could be a good idea. 

Thanks.
> 
> > +struct page *
> > +alloc_pages_mask(gfp_t gfp, unsigned size, u64 mask)
> > +{
> > +	unsigned long max_pfn = mask >> PAGE_SHIFT;
> 
> The "mask" parameter isn't really a mask - it's an upper bound on the

Actually it's both.

> address of the allocated memory.  Might it be better to call it
> "max_addr" or "limit" or "ceiling" or some such so callers understand

mask is the standard term used by the PCI-DMA API for the same
thing and since one of the main purposes of the mask allocator is to 
implement underlying support for that interface it seemed fitting to use 
the same convention.

-Andi

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbZHEOBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbZHEOBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 10:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933270AbZHEOBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 10:01:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbZHEOBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 10:01:46 -0400
Date: Wed, 5 Aug 2009 16:01:45 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com,
       hidehiro.kawai.ez@hitachi.com
Subject: Re: [PATCH] [11/19] HWPOISON: Refactor truncate to allow direct truncating of page v2
Message-ID: <20090805140145.GB28563@wotan.suse.de>
References: <200908051136.682859934@firstfloor.org> <20090805093638.D3754B15D8@basil.firstfloor.org> <20090805102008.GB17190@wotan.suse.de> <20090805134607.GH11385@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805134607.GH11385@basil.fritz.box>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 03:46:08PM +0200, Andi Kleen wrote:
> On Wed, Aug 05, 2009 at 12:20:08PM +0200, Nick Piggin wrote:
> > >  truncate_complete_page(struct address_space *mapping, struct page *page)
> > >  {
> > >  	if (page->mapping != mapping)
> > > -		return;
> > > +		return -EIO;
> > 
> > Hmm, at this point, the page must have been removed from pagecache,
> > so I don't know if you need to pass an error back?
> 
> It could be reused, which would be bad for us?
 
I haven't brought up the caller at this point, but IIRC you had
the page locked and mapping confirmed at this point anyway so
it would never be an error for your code.

Probably it would be nice to just force callers to verify the page.
Normally IMO it is much nicer and clearer to do it at the time the
page gets locked, unless there is good reason otherwise.


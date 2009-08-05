Return-Path: <linux-kernel-owner+w=401wt.eu-S934447AbZHENqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934447AbZHENqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933803AbZHENqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:46:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48460 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933662AbZHENqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:46:11 -0400
Date: Wed, 5 Aug 2009 15:46:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, hidehiro.kawai.ez@hitachi.com
Subject: Re: [PATCH] [11/19] HWPOISON: Refactor truncate to allow direct
	truncating of page v2
Message-ID: <20090805134607.GH11385@basil.fritz.box>
References: <200908051136.682859934@firstfloor.org> <20090805093638.D3754B15D8@basil.firstfloor.org> <20090805102008.GB17190@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805102008.GB17190@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 12:20:08PM +0200, Nick Piggin wrote:
> >  truncate_complete_page(struct address_space *mapping, struct page *page)
> >  {
> >  	if (page->mapping != mapping)
> > -		return;
> > +		return -EIO;
> 
> Hmm, at this point, the page must have been removed from pagecache,
> so I don't know if you need to pass an error back?

It could be reused, which would be bad for us?

The final check is the page error count in the end anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

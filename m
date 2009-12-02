Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbZLBNoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbZLBNoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZLBNoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:44:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51893 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbZLBNoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:44:09 -0500
Date: Wed, 2 Dec 2009 14:44:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/24] HWPOISON: abort on failed unmap
Message-ID: <20091202134415.GJ18989@one.firstfloor.org>
References: <20091202031231.735876003@intel.com> <20091202043044.293905787@intel.com> <20091202131150.GE18989@one.firstfloor.org> <20091202132819.GC13277@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202132819.GC13277@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 09:28:19PM +0800, Wu Fengguang wrote:
> On Wed, Dec 02, 2009 at 09:11:50PM +0800, Andi Kleen wrote:
> > >  	 * Now take care of user space mappings.
> > > +	 * Abort on fail: __remove_from_page_cache() assumes unmapped page.
> > >  	 */
> > > -	hwpoison_user_mappings(p, pfn, trapno);
> > > +	if (hwpoison_user_mappings(p, pfn, trapno) != SWAP_SUCCESS) {
> > > +		res = -EBUSY;
> > > +		goto out;
> > 
> > It would be good to print something in this case.
> 
> OK.

I'll add it.

> 
> > Did you actually see it during testing?
> 
> Perhaps not.
> 
> > Or maybe loop forever in the unmapper.
> 
> !SWAP_SUCCESS should be rare, so not necessary to loop forever?

I think the loop I originally added was overcautious and could
be even removed possibly now. It probably needs some more analysis how l
ikely unmapping failures really are.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

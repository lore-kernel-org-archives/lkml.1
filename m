Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbZLBN2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbZLBN2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbZLBN2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:28:55 -0500
Received: from mga03.intel.com ([143.182.124.21]:55534 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbZLBN2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:28:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217908251"
Date: Wed, 2 Dec 2009 21:28:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/24] HWPOISON: abort on failed unmap
Message-ID: <20091202132819.GC13277@localhost>
References: <20091202031231.735876003@intel.com> <20091202043044.293905787@intel.com> <20091202131150.GE18989@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202131150.GE18989@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 09:11:50PM +0800, Andi Kleen wrote:
> >  	 * Now take care of user space mappings.
> > +	 * Abort on fail: __remove_from_page_cache() assumes unmapped page.
> >  	 */
> > -	hwpoison_user_mappings(p, pfn, trapno);
> > +	if (hwpoison_user_mappings(p, pfn, trapno) != SWAP_SUCCESS) {
> > +		res = -EBUSY;
> > +		goto out;
> 
> It would be good to print something in this case.

OK.

> Did you actually see it during testing?

Perhaps not.

> Or maybe loop forever in the unmapper.

!SWAP_SUCCESS should be rare, so not necessary to loop forever?

Thanks,
Fengguang


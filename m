Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbZLBNbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbZLBNbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbZLBNbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:31:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:43356 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308AbZLBNbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:31:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217909187"
Date: Wed, 2 Dec 2009 21:31:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/24] HWPOISON: make it possible to unpoison pages
Message-ID: <20091202133126.GE13277@localhost>
References: <20091202031231.735876003@intel.com> <20091202043045.150526892@intel.com> <20091202131530.GG18989@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202131530.GG18989@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 09:15:30PM +0800, Andi Kleen wrote:
> > Note that it may leak pages silently - those who have been removed from
> > LRU cache, but not isolated from page cache/swap cache at hwpoison time.
> 
> It would be better if we could detect that somehow and at least warn.
> 
> >  }
> >  
> > +static int hwpoison_forget(void *data, u64 val)
> > +{
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EPERM;
> > +
> > +	return forget_memory_failure(val);
> > +}
> > +
> >  DEFINE_SIMPLE_ATTRIBUTE(hwpoison_fops, NULL, hwpoison_inject, "%lli\n");
> > +DEFINE_SIMPLE_ATTRIBUTE(unpoison_fops, NULL, hwpoison_forget, "%lli\n");
> 
> I'll rename it to unpoison, not forget. I think that's a more clear
> name.

OK. Will repost the whole updated patchset.

Thanks,
Fengguang

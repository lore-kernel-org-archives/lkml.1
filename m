Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbYEIUti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbYEIUti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 16:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbYEIUta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 16:49:30 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:56734 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbYEIUt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 16:49:29 -0400
Date: Fri, 9 May 2008 21:48:39 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Packard, Keith" <keith.packard@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git head] X86_PAT & mprotect
In-Reply-To: <20080509200930.GA12061@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0805092134200.6603@blonde.site>
References: <200805022122.03576.elendil@planet.nl> <200805040910.57088.elendil@planet.nl>
 <200805050857.57661.jesse.barnes@intel.com> <200805051932.41827.elendil@planet.nl>
 <20080506224240.GA18706@linux-os.sc.intel.com> <20080507070217.GD32195@elte.hu>
 <Pine.LNX.4.64.0805071941140.18916@blonde.site> <20080507232326.GB10757@linux-os.sc.intel.com>
 <20080509100818.GD19617@elte.hu> <20080509200519.GA10897@linux-os.sc.intel.com>
 <20080509200930.GA12061@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008, Venki Pallipadi wrote:
> 
> There is a defect in mprotect, which lets the user to change the page
> cache type bits by-passing the kernel reserve_memtype and free_memtype
> wrappers. Fix the problem by not letting mprotect change the PAT bits.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Thanks a lot for finalizing that, Venki: looks good to me.
I didn't originally sign-off my version of your patch, but am happy
to do so now that you've gone over it again and fixed the pte_modify
issue (though I'm not sure what the order of our signoffs should be).

I shall need to cover the MAP_PRIVATE COW issue in do_wp_page,
but I think that's better done as a separate patch: I'll attend
to it in a few days, it's not something that will upset anyone
bisecting, my mind is elsewhere at present.

Hugh

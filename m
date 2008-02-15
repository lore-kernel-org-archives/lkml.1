Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbYBOHJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbYBOHJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 02:09:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762135AbYBOHI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 02:08:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59071 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761662AbYBOHI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 02:08:57 -0500
Date: Fri, 15 Feb 2008 08:08:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@osdl.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
Message-ID: <20080215070843.GA6975@elte.hu>
References: <20080214131317.GA27769@basil.nowhere.org> <20080214161218.GA28152@elte.hu> <1203050886.30010.19.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203050886.30010.19.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang, Ying <ying.huang@intel.com> wrote:

> On Thu, 2008-02-14 at 17:12 +0100, Ingo Molnar wrote: 
> > this is indeed a bug (we change the attributes for a larger area than 
> > needed), but your fix is unclean. Find below a cleaner solution.
> > 
> > Ying, if you agree with this fix could you please test and ACK it before 
> > we push it to Linus? (this fix is also in the latest x86.git#mm)
> 
> I think the patch following may be better, because it is possible that 
> the EFI_PAGE_SHIFT and PAGE_SHIFT are different.

right now, EFI page size is 4096:

  include/linux/efi.h:#define EFI_PAGE_SHIFT          12

i doubt we'll ever change PAGE_SIZE on x86 - ia64's variable lowlevel 
pagesizes are not particularly useful IMO. I think we'll at most have 
some generic kernel feature that allows a larger PAGE_CACHE_SHIFT - but 
on the lowlevel MMU level we'll always stay at 4K.

and i doubt EFI_PAGE_SHIFT would want to (ever) go away from 12 either. 

So perhaps, at least as far as arch/x86/kernel/efi*.c files go, it would 
be cleaner to just replace EFI_PAGE_SHIFT with PAGE_SHIFT and 
EFI_PAGE_SIZE with PAGE_SIZE?

	Ingo

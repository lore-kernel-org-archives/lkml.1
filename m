Return-Path: <linux-kernel-owner+w=401wt.eu-S1759374AbYBKRqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbYBKRqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYBKRqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:46:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:4812 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbYBKRqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:46:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,334,1199692800"; 
   d="scan'208";a="516664608"
Date: Mon, 11 Feb 2008 09:36:06 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [7/8] CPA: Don't flush caches on CPUs that support self-snoop
Message-ID: <20080211173606.GB21564@linux-os.sc.intel.com>
References: <200802111050.372086035@suse.de> <200802111612.56662.ak@suse.de> <20080211072109.029bb6c5@laptopd505.fenrus.org> <200802111627.23751.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802111627.23751.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 04:27:23PM +0100, Andi Kleen wrote:
> 
> > > That is exactly the situation in pageattr.c. You're saying the manual
> > > is wrong here?
> > 
> > I'm saying that we are not following step 2 (marking the pages not present) 
> 
> Yes that's true. It's one of the design problems of the intent API that makes
> fixing this hard unfortunately.

BTW, making pages not present is required only while changing the attribute
from WB to WC or WC to WB. I think this step is for avoiding attribute aliasing
for speculative accesses. For UC, we don't have speculative accesses and such we
probably don't need it.

So WC support through PAT should take care of it.

> (intent API assumes that the caller doesn't fully own the page to change, and
> if you can't control it 100% it is not possible to unmap it temporarily) 

True. Perhaps for WC chages we can assume the ownership?

thanks,
suresh

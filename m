Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbZHCJTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbZHCJTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbZHCJTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:19:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51695 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbZHCJTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:19:13 -0400
Date: Mon, 3 Aug 2009 11:18:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@linux.ie>
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
       Arjan van de Ven <arjan@infradead.org>, suresh.b.siddha@intel.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] x86: Fix CPA memtype reserving in the set_pages_array
	cases
Message-ID: <20090803091842.GA9074@elte.hu>
References: <1249284345-7654-1-git-send-email-thellstrom@vmware.com> <20090803081110.GB32258@elte.hu> <alpine.DEB.2.00.0908030928280.496@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908030928280.496@skynet.skynet.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Airlie <airlied@linux.ie> wrote:

> > hm, i'm missing a description about how this bug was triggered. 
> > How did you end up getting highmem pages to a cpa call?
> 
> GEM and TTM both allocate page arrays and just pass them to cpa, 
> we don't know what type of pages the allocator gives us back and 
> we really shouldn't have to, so having cpa ignore highmem pages is 
> certainly the right option.
> 
> GEM just uses shmem code to alloc the pages and TTM has its own 
> allocator.

Neither of my questions was answered though: do highmem pages ever 
get passed in and what were the effects of the bug and how was it 
noticed?

If no highmem pages can be passed in then the right solution is not 
to ignore them silently but to add a WARN_ONCE() to enforce that 
they are not used in the future either.

If they are used today then i'd like to know where exactly and 
double check that all the cache attributes are consistent: as a 
highmem page might be visible to user-space as well or might be 
mapped via the vmalloc space, etc.

And yes, if it happens and all the other mapping aliases are fine 
then ignoring them is the right solution.

	Ingo

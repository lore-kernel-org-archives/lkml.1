Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbYLLRE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbYLLRE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 12:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757999AbYLLRET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 12:04:19 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:57906 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757773AbYLLRES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 12:04:18 -0500
Subject: Re: [PATCH 07/15] kmemleak: Add memleak_alloc callback from
	alloc_large_system_hash
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <84144f020812111147h77587bd2t9dbe03f132cb1153@mail.gmail.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182732.30323.39834.stgit@pc1117.cambridge.arm.com>
	 <1228935860.9737.98.camel@nimitz>
	 <1228989052.332.12.camel@pc1117.cambridge.arm.com>
	 <1229016618.17206.2.camel@nimitz>
	 <1229017098.332.45.camel@pc1117.cambridge.arm.com>
	 <1229017506.17206.7.camel@nimitz>
	 <84144f020812111147h77587bd2t9dbe03f132cb1153@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 12 Dec 2008 17:04:12 +0000
Message-Id: <1229101452.15045.60.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2008 17:04:13.0251 (UTC) FILETIME=[A8623130:01C95C7B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-11 at 21:47 +0200, Pekka Enberg wrote:
> On Thu, 2008-12-11 at 17:38 +0000, Catalin Marinas wrote:
> >> Do you mean a comment? I can do this.
> 
> On Thu, Dec 11, 2008 at 7:45 PM, Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> > Yeah, something like
> >
> > /*
> >  * kmemleak doesn't actually allocate memory when called this early
> >  * so the GFP_ATOMIC here is actually meaningless, but consistent
> >  * with the rest of this function.
> >  */
> >
> > Maybe that's too verbose. :)
> 
> I'd suggest just doing a separate kmemleak_early_alloc() hook without
> the gfp flag.

It looks to me like alloc_large_system_hash() could also be called at
some later point and it may even invoke __vmalloc() if hashdist is set.
So I would prefer not to introduce another hook and additional if's to
know which one to call. BTW, I think the callback should actually be (to
avoid duplicating the vmalloc call, with proper comment):

	if (!hashdist)
		memleak_alloc(table, size, 1, GFP_ATOMIC);

-- 
Catalin


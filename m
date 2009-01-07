Return-Path: <linux-kernel-owner+w=401wt.eu-S1761043AbZAGTcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761043AbZAGTcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbZAGTcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:32:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42323 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759539AbZAGTcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:32:12 -0500
Date: Wed, 7 Jan 2009 20:46:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] [3/5] Mark complex bitops.h inlines as __always_inline
Message-ID: <20090107194613.GL496@one.firstfloor.org>
References: <200901051236.281008835@firstfloor.org> <20090104233640.6A7453E6653@basil.firstfloor.org> <20090106101710.GA22134@elte.hu> <20090106143215.GD496@one.firstfloor.org> <20090107132653.GA22229@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107132653.GA22229@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

> Yes, simple functions should always be inlined, nobody will argue about 
> that. But GCC's inliner will never be fixed (for the kernel domain at 
> least) if we keep working it around and if we keep micro-managing it.

To my knowledge the inliner is already fixed. We're just talking about 
old gccs.

Also to be honest I never quite believed in the basic idea of
"hurt users to get someone else to do something" strategies like
you're advocating here.

> 
> We work around GCC bugs only if it hurts visibly (and generally if it 
> affects default-enabled features/optimizations): if it can be quantified 
> either via stability/robustness problems or there's excesssive size / 
> efficiency problems.

Not inlining bitops qualifies as the later I believe. 

I agree with you if we're talking about random static function
in .c files, but widely used functions in .h files that are 
not expected to change are a little different. The main
reason to not use __always_inline normally is that when people
change the function to contain more code they typically don't 
drop these markers and then it eventually leads to bloat.
But for the bitops style functions I changed here it's not really
expected that they change this way.

Also I don't think adding a few __always_inline for functions which
really need it will hurt maintainability or anything else. In fact
we already have them in a couple of places (e.g. uaccess.h)

> 
> You simply have not made that argument via any numbers here. So i have no 

That's true, I just reacted to Hugh's report. I don't use old
compilers on my own.

-Andi

-- 
ak@linux.intel.com

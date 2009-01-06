Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbZAFOS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbZAFOS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 09:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZAFOSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 09:18:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47539 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbZAFOSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 09:18:20 -0500
Date: Tue, 6 Jan 2009 15:32:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] [3/5] Mark complex bitops.h inlines as __always_inline
Message-ID: <20090106143215.GD496@one.firstfloor.org>
References: <200901051236.281008835@firstfloor.org> <20090104233640.6A7453E6653@basil.firstfloor.org> <20090106101710.GA22134@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106101710.GA22134@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Your patch is wrong because it prevents a good compiler from doing the 
> right inlining decisions.

One or two instruction bitops should be always inlined, not inlining them
always generates much worse code than inlining them. That's easy
to prove just based on code size: the call overhead is larger 
than the inlined code.

This patch just makes sure they get always inlined by marking
those explicitely. There's no reason ever to not inline
those, so giving the compiler a choice doesn't make sense.

Even on a compiler with perfect inlining algorithm (which 
no compiler has) that's true and stating that explicitely 
is correct.

Also to handle inlines in all cases that have code that collapses at compile
time (e.g. __builtin_constant_p tests and similar) correctly the compiler
needs the new "early inlining + optimization" pass that was 
added with gcc 4.4 only. But 4.4 is not even out yet, so obviously
most people don't use it.

That is why *_user() for example always needs to be marked
__always_inline. This patch just extends it a bit more to
more functions with the same problem.

-Andi

-- 
ak@linux.intel.com

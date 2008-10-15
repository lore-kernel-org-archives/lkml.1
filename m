Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbYJOSBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbYJOSBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbYJOSBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:01:15 -0400
Received: from waste.org ([66.93.16.53]:33787 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbYJOSBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:01:14 -0400
Subject: Re: [rfc] SLOB memory ordering issue
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0810151033170.3288@nehalem.linux-foundation.org>
References: <200810160334.13082.nickpiggin@yahoo.com.au>
	 <1224089658.3316.218.camel@calx>
	 <200810160410.49894.nickpiggin@yahoo.com.au>
	 <alpine.LFD.2.00.0810151028110.3288@nehalem.linux-foundation.org>
	 <alpine.LFD.2.00.0810151033170.3288@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 12:58:33 -0500
Message-Id: <1224093513.3316.250.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-15 at 10:36 -0700, Linus Torvalds wrote:
> 
> On Wed, 15 Oct 2008, Linus Torvalds wrote:
> > 
> > If you make an allocation visible to other CPU's, you would need to make 
> > sure that allocation is stable with a smp_wmb() before you update the 
> > pointer to that allocation.
> 
> Just to clarify a hopefully obvious issue..
> 
> The assumption here is that you don't protect things with locking. Of 
> course, if all people accessing the new pointer always have the 
> appropriate lock, then memory ordering never matters, since the locks take 
> care of it.

Right. This is the 99.9% case and is why we should definitely not put an
additional barrier in the allocator.

Lockless users are already on their own with regard to memory ordering
issues, so it makes sense for them to absorb the (often nil) incremental
cost of ensuring object initialization gets flushed.

I feel like we ought to document this in the SLAB API, but at the same
time, I think we'll scare more people than we'll enlighten.

-- 
Mathematics is the supreme nostalgia of our time.


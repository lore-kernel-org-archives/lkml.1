Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbYKHSjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbYKHSjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 13:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYKHSi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 13:38:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981AbYKHSi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 13:38:59 -0500
Date: Sat, 8 Nov 2008 10:38:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [git pull] scheduler updates
In-Reply-To: <alpine.LFD.2.00.0811081026280.3468@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0811081035370.3468@nehalem.linux-foundation.org>
References: <20081108170224.GA553@elte.hu> <alpine.LFD.2.00.0811081026280.3468@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 8 Nov 2008, Linus Torvalds wrote:
> 
> Can we please just remove that idiocy? Or can somebody give a _sane_ 
> argument for it?

Btw, the only _possible_ sane argument I see is 

 - two consecutive rdtsc calls
 - timing the code in between
 - the code in between is not self-serializing

and quite frankly, if that's the case, then it's _that_ code that should 
have the barriers, not some generic "[v]get_cycles()". 

IOW, the rdtsc_barrier may make sense when you're synchronizing the TSC to 
some other hardware event (eg the "tie the TSC to the HPET" kind of 
code), but then the barriers are about the code, not about the TSC access 
itself.

			Linus

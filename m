Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799AbZJGVWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbZJGVWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZJGVWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:22:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753694AbZJGVWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:22:45 -0400
Date: Wed, 7 Oct 2009 14:20:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc][patch] store-free path walking
In-Reply-To: <20091007210651.GB1656@one.firstfloor.org>
Message-ID: <alpine.LFD.2.01.0910071417300.3432@localhost.localdomain>
References: <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de> <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain> <alpine.LFD.2.01.0910070911080.3432@localhost.localdomain>
 <20091007164622.GX30316@wotan.suse.de> <alpine.LFD.2.01.0910071222230.3432@localhost.localdomain> <87eipfymcv.fsf@basil.nowhere.org> <alpine.LFD.2.01.0910071349190.3432@localhost.localdomain> <20091007210651.GB1656@one.firstfloor.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Oct 2009, Andi Kleen wrote:
> 
> It won't double it, because there are many more cache lines from
> all kinds of other things in these paths.

Not all that many. The big part of the D$ is the hash table lookup in this 
path.

> The point was just to hide the latency of fetching two at different 
> times. The actual cache foot print is not that important, as long as 
> it's not excessive

You're full of sh*t.

Every extra line you fetch pushes out another line. No amount of 
prefetching will hide that. So stop spreading idiotic fairytales.

The best optimization is to not do the work at all. It really is that 
simple.  Prefetching as an optimization technique absolutely sucks.

		Linus

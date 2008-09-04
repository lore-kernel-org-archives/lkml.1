Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbYIDVff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbYIDVff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbYIDVf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:35:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754062AbYIDVf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:35:26 -0400
Date: Thu, 4 Sep 2008 14:34:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <alpine.LFD.1.10.0809041428520.3117@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809041432070.3117@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org> <20080904160036.GA18382@elte.hu> <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org>
 <20080904190728.59634020@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org> <20080904204305.GA29065@elte.hu> <20080904205236.GA3864@elte.hu>
 <alpine.LFD.1.10.0809041403450.3117@nehalem.linux-foundation.org> <20080904212130.GA12406@elte.hu> <alpine.LFD.1.10.0809041428520.3117@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Sep 2008, Linus Torvalds wrote:
> 
> Face it, if somebody tries to make QUICK_PIT_MS be so large as to that be 
> an issue, then the whole point of the function goes away.

Btw, the same is true of adding any random "sanity checking". The point of 
that thing was to simply only work when the PIT works as advertized, and 
fail immediately if it doesn't. Even *if* you were to pick a big 
calibration delay *and* if you happened to have a PIT that is broken and 
doesn't wrap correctly, the design of the thing would mean that it would 
then fail the calibration already.

Exactly because it would _see_ that it's not wrapping.

So then it returns zero, and the slow and complicated case can run.

Take a look at the generated assembly language. I literally wrote it so 
that you could imagine that it's an old-time asm hacker that wrote the 
asm. Don't screw it up.

			Linus

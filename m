Return-Path: <linux-kernel-owner+w=401wt.eu-S1757649AbZDPQwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbZDPQwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756593AbZDPQvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:51:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756381AbZDPQvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:51:52 -0400
Date: Thu, 16 Apr 2009 09:44:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v3
In-Reply-To: <20090416093152.6605612d@hobbes>
Message-ID: <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain>
References: <bug-11103-13546@http.bugzilla.kernel.org/> <200904101913.n3AJDhMm018684@demeter.kernel.org> <49DFABCC.3070001@kernel.org> <49E00E9F.8030605@kernel.org> <49E4F6D6.6030709@kernel.org> <49E4F71F.10107@kernel.org> <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain>
 <49E52A7A.4070607@kernel.org> <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Apr 2009, Jesse Barnes wrote:
> 
> Any comments on this one, Linus?  Should I include your ack?

I'm not ready to ack it, no. I don't think the suggested patch is very 
clean or necessarily sensible as-is. It seems very ad-hoc. 

I was literally thinking of something like 
 "round up from the last RAM by X"
 "round up from the last reserved region by Y"
 "pick the bigger of the two"

with helper functions for the two cases and comments along the lines of 
why we do it. Something that was a bit more obvious about what it's doing 
and why.

And no, I realize that the old code isn't that way. But the old code isn't 
the issue - the old code is proven over _years_ and years of testing, and 
works wonderfully well for a ton of very different machines. It has _one_ 
single known failure case, and while there clearly must be others, the 
point is, the old code is not what needs to be worried about. 

So when changing that code that has all that testing, and when the 
failures are so nasty and hard to debug and likely only happen on some 
random old laptop that has crap e820 tables and _just_ the right amount 
of memory, I'd really like the replacement code to be better.

			Linus

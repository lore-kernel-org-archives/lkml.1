Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbZB1DxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbZB1DxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 22:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbZB1Dwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 22:52:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752345AbZB1Dwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 22:52:50 -0500
Date: Fri, 27 Feb 2009 19:52:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 2/2] x86-64: seccomp: fix 32/64 syscall hole
In-Reply-To: <alpine.LFD.2.00.0902271932520.3111@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0902271948570.3111@localhost.localdomain>
References: <20090228030226.C0D34FC3DA@magilla.sf.frob.com> <20090228030413.5B915FC3DA@magilla.sf.frob.com> <alpine.LFD.2.00.0902271932520.3111@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Feb 2009, Linus Torvalds wrote:
> 
> Ok, please explain this madness.
> 
> The whole crazy IS_COMPAT_TASK dance seems to be too messy for words. Why? 
> What's going on?

Ok, I can see what's going on. And it's disgusting.

Just make everybody do that "is_compat_task()" thing. parisc already did, 
and you just made x86-64 do so too. The only remaining TIF_32BIT users are 
powerpc and sparc. So instead of having this insane crud, please just add 
the trivial definitions to the two remaining places, and we don't have to 
have this insane mess. Ok?

It is clear that TIF_32BIT is _not_ a generic flag for 32/64-bit system 
calls, so let's stop pretending it is, and then having ugly special cases 
for when it's not.

			Linus

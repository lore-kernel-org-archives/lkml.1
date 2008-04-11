Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbYDKPAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbYDKPAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760570AbYDKPAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:00:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760479AbYDKPAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:00:15 -0400
Date: Fri, 11 Apr 2008 07:58:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kyle McMartin <kyle@mcmartin.ca>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] reorganize <linux/linkage.h>
In-Reply-To: <20080411050019.GC27073@phobos.i.cabal.ca>
Message-ID: <alpine.LFD.1.00.0804110747370.3143@woody.linux-foundation.org>
References: <20080411050019.GC27073@phobos.i.cabal.ca>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 11 Apr 2008, Kyle McMartin wrote:
>
> Commit 54a015104136974262afa4b8ddd943ea70dec8a2 adds some new magic
> asmlinkage_protect gizmo, but that can only be used from C code, not
> assembly. Protect relevant bits of <linux/linkage.h> with !__ASSEMBLY__
> so this can't leak into assembly source.

Ok, so s390 had a similar issue, and I assumed that they were just usign a 
broken C pre-processor for asm, but now I'm starting to wonder about it.

Why cannot your pre-processor handle that thing?

It doesn't matter if it is C or assembly, the pre-processor should be the 
same. That #define isn't used for asm, so it shouldn't _matter_ for asm. 
What's going on?

I'm starting to suspect that it's the fact that some architectures still 
have

	EXTRA_AFLAGS  := -traditional

or equivalent and I'm wondering whether that is really necessary. IIRC x86 
got rid of the use of --traditional a long time ago, exactly because it 
caused problems with any fancier C preprocessor things.

It would probably be much better to try to lose that -traditional from 
affected architectures, because otherwise issues like this will keep 
popping up just because the most common architecture doesn't use the 
limited preprocessor..

		Linus

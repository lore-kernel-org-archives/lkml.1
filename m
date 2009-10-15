Return-Path: <linux-kernel-owner+w=401wt.eu-S934983AbZJOQrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934983AbZJOQrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 12:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933351AbZJOQrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 12:47:37 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59751 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933344AbZJOQrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 12:47:36 -0400
Date: Thu, 15 Oct 2009 12:46:13 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: sam@ravnborg.org, linuxppc-dev@lists.ozlabs.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: powerpc problem with .data.page_aligned -> __page_aligned_data
 conversion
In-Reply-To: <1255584772.2347.86.camel@pasglop>
Message-ID: <alpine.DEB.1.10.0910150832290.27415@dr-wily.mit.edu>
References: <1255584772.2347.86.camel@pasglop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Benjamin Herrenschmidt wrote:

> What do you recommend I do ? 
> I can ban gcc < 4.3 but that's a bit harsh :-) 

Yeah, let's try to avoid that.

> I know a few people that won't be happy to be unable to build newer 
> kernels with current distro gccs.
> 
> Or can do the above making the macro definition drop the alignment part
> on powerpc. Will work for now, but will require great care to avoid
> subtle and nasty breakage (basically same as before)

Yeah, I'd be afraid that changing the generic __page_aligned_data might 
cause unexpected problems on some other architecture.

> Or maybe I can do the above but only when using gcc < 4.3 so at least if
> the breakage happen, that will only be with older gccs ...

It sounds like from your grepping, you don't believe that dropping the 
alignment part will actually cause any problems on powerpc currently?

If so, dropping the alignment part on powerpc with gcc < 4.3 seems best to 
me.  It limits the workaround in time (eventually gcc < 4.3 will be 
history).  It also limits it in scope (to powerpc), where at least you're 
well aware of the issue and can pay attention to new code being added that 
uses __page_aligned_data.  Since most code that has page-aligned data 
structures is architecture-specific, there's a good chance that any new 
code that would break will be at least looked at by you (and given how few 
places it is used currently, this seems pretty unlikely to actually come 
up).

	-Tim Abbott



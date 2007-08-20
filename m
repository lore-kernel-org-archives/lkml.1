Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbXHTA63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbXHTA63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 20:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbXHTA6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 20:58:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57042 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbXHTA57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 20:57:59 -0400
Date: Mon, 20 Aug 2007 01:57:43 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: David Brownell <david-b@pacbell.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrdiff_t is not uintptr_t, damnit
Message-ID: <20070820005743.GY21089@ftp.linux.org.uk>
References: <20070819225546.GV21089@ftp.linux.org.uk> <200708191719.48340.david-b@pacbell.net> <E83C36D0-B72E-4E70-BEF6-4AF54BAD2863@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E83C36D0-B72E-4E70-BEF6-4AF54BAD2863@cam.ac.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 01:29:21AM +0100, Anton Altaparmakov wrote:
> Hi,
> 
> On 20 Aug 2007, at 01:19, David Brownell wrote:
> >On Sunday 19 August 2007, Al Viro wrote:
> >>is wrong; for one thing, it's a bad C (it's what uintptr_t is for;  
> >>in general
> >>we are not even promised that ptrdiff_t is large enough to hold a  
> >>pointer,
> >
> >ISTR we don't *have* a uintptr_t on all architectures, or that would
> >be the appropriate thing to use in these 32/64 bit ABI scenarios.
> >
> >
> >>Use unsigned long or uintptr_t instead.
> >
> >I suspect you mean "unsigned long long"...
> 
> No he doesn't.  "unsigned long" is guaranteed to be large enough to  
> hold a pointer (at least on Linux anyway).
> 
> On a 32-bit arch "unsigned long" is 32-bit and pointers are 32-bit.

... while unsigned long long is 64bit, which is definitely not what
one wants.  For sparse it's "unsigned long is special".

FWIW, this patch puts it in linux/types.h as unsigned long.  Eventually
we might want to switch explicit casts to/from unsigned long in such contexts
to uintptr_t, but for now we can't start complaining about unsigned long -
too many places are using it.  I'll see what can be done to get sane
assistance from sparse in that kind of work...


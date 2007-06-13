Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbXFMIKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbXFMIKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 04:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbXFMIJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 04:09:47 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59085 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbXFMIJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 04:09:46 -0400
Date: Wed, 13 Jun 2007 10:10:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Jan Beulich <jbeulich@novell.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: Re: [PATCH] x86: fix improper .init-type section references
Message-ID: <20070613081049.GA21364@uranus.ravnborg.org>
References: <a781481a0706120509k89c331ela81f57ad0f0e29eb@mail.gmail.com> <466EB12B.76E4.0078.0@novell.com> <a781481a0706120632p54ad83d0ka0a07a9fd9b276b4@mail.gmail.com> <466EC08A.76E4.0078.0@novell.com> <a781481a0706120709v5a2d1147m9d372a8056aeba6d@mail.gmail.com> <20070612180002.GC15329@uranus.ravnborg.org> <a781481a0706122018i6273cd17y61cd95e269b5c7c9@mail.gmail.com> <20070613043526.GA20088@uranus.ravnborg.org> <466FB20D.76E4.0078.0@novell.com> <a781481a0706130039r26e9522q98d9645809136ea7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0706130039r26e9522q98d9645809136ea7@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 01:09:07PM +0530, Satyam Sharma wrote:
> 
> i.e. don't discard anything at build time, and link the .exit.{text,
> data} sections
> into the kernel image for _all_ archs? (otherwise how do we avoid
> special-casing/
> checking for the arch in modpost and warn/not-warn about invalid/valid 
> cases)
> 
> But then why not simply lose the __exit (and .exit.*) altogether? Because
> __exit becomes redundant in the suggested changed semantics -- just mark
> all the cleanup code as __init too (when it's built-in, the only
> callsite for the
> cleanup code would be from the startup code in .init.*, and when modular,
> __init and __exit lose all relevance anyway).

The reason we do it today is to save memory in a memory constrained environment.
So with such a suggestion you should back it up with numbers.

How much RAM is wasted by keeping the __init and _exit sections
in memory for a normal embedded build?

You could try a random defconfig for arm or mips since they are
embedded in general. Using defconfig for i386 could tell us
a little but not that important.

And when evaluating the numbers think of maybe 8 MB RAM in total, no swap
storage, and sloow filesystem for permanent storage.

	Sam

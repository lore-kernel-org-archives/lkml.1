Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbXK1Wja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbXK1Wja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050AbXK1WjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:39:22 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53991 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755427AbXK1WjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:39:21 -0500
Date: Wed, 28 Nov 2007 23:39:09 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tobias Powalowski <t.powa@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Christoph Hellwig <hch@infradead.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] x86/paravirt: revert exports to restore old behaviour
Message-ID: <20071128223909.GE29463@stusta.de>
References: <474CA0DA.3010005@goop.org> <20071128204050.GA29463@stusta.de> <474DDA7B.9090802@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <474DDA7B.9090802@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 01:15:39PM -0800, Jeremy Fitzhardinge wrote:
> Adrian Bunk wrote:
> > On Tue, Nov 27, 2007 at 02:57:30PM -0800, Jeremy Fitzhardinge wrote:
>...
> >> 2. It's a regression from previous kernels, which would work these
> >>    modules even with CONFIG_PARAVIRT enabled.
> >> ...
> >>     
> >
> > It cannot be a regression since the kernel does not have a stable API 
> > for modules.
> >   
> 
> Anything that once worked but now does not is a regression.  Generally
> when we intend a regression like this, we call it a deprecation of an
> interface and have a procedure for that.  It was not my intention to
> cause a regression with this change, and an unintended regression is a bug.

The standard procdure for changing the in-kernel API is to simply break 
the API without any deprecation or advance notice.

Andrew has some strange views that big changes can be done immediately 
while smaller changes should require deprecation periods, but everyone 
else seems to have less strange views.

> >> Therefore, I think this patch should go in for 2.6.24.  If people
> >> really think that these operations should not be available to modules,
> >> then we can address that separately.
> >> ...
> >>     
> >
> > Why should we start with one step back for getting two steps ahead?
> 
> Why is it a step back?  What are the steps ahead?  There's been no
> discussion on this point, so I don't think you can assume there's a
> clear way forward.
> 
> I think Linus and Andrew have been pretty clear on the policy for these
> kinds of things: regressions are always bad, even if fixing the
> regression means some other bugfix needs to be put off.

This does not apply since we do not have a stable in-kernel API, and 
therefore changes to the in-kernel API can by definition not be 
regressions.

2.6.24 most likely contains hundreds of changes and removals of 
in-kernel APIs that existed in 2.6.23.

Are you seriously suggesting that e.g. every single change to any struct 
under include/ [1] would require an announcement x kernel releases 
before it can be implemented?

And yes, things like that would be required if we offered any kind of 
API stability.

>     J

cu
Adrian

[1] even additions would be problematic since buggy external modules 
    might have hardcoded the struct size somewhere...

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


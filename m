Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbYK2LAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbYK2LAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 06:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYK2LAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 06:00:10 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:59899 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbYK2LAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 06:00:09 -0500
Date: Sat, 29 Nov 2008 12:01:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: fix CONFIG_EMBEDDED submenu
Message-ID: <20081129110135.GA9823@uranus.ravnborg.org>
References: <20081128173849.GA19101@localhost.localdomain> <19f34abd0811281441m6245d1bag2053619939270a5a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0811281441m6245d1bag2053619939270a5a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 11:41:59PM +0100, Vegard Nossum wrote:
> On Fri, Nov 28, 2008 at 6:38 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > From 06f65799401f08eff0020ba0300133c89bd02349 Mon Sep 17 00:00:00 2001
> > From: Vegard Nossum <vegard.nossum@gmail.com>
> > Date: Fri, 28 Nov 2008 18:29:47 +0100
> > Subject: [PATCH] kbuild: fix CONFIG_EMBEDDED submenu
> >
> > Many of the elements of the EMBEDDED submenu were being expanded
> > in the current menu instead of inside the submenu. This was caused
> > by the lack of (explicit) dependencies on EMBEDDED. The simplest
> > fix is to wrap everything (except COMPAT_BRK, which just toggles a
> > setting) in "if/endif EMBEDDED".
> 
> Urgh -- the menu displays correctly, but defconfig now becomes totally
> wrong, because the items inside are taken to depend on EMBEDDED
> instead of toggling visibility. Better to add "if EMBEDDED" to the end
> of all the prompts, then.
> 
> That was counter-intuitive :-(

Thanks for the feedback Vegard!

I had it queued as I wanted to check if the conversion
from
	prompt "foo" if EMBEDDED

to
	depends on EMBEDDED

caused any signigicant difference. And so it did.

The fist uses EMBEDDED to say if the prompt is visible or not.
The latter say if this symbol can be set or not (overriding default)
as you experienced.

One day we should take a deeper look at the usage of EMBEDDED.
Replacing EMBEDDED with:

OPTIMIZE_FOR_TEXT_SIZE
OPTIMIZE_FOR_DATA_SIZE
KERNEL_EXPERT

would make it much more obvious what you could
achive by the individual options.

	Sam

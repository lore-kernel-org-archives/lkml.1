Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbXKLQkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbXKLQkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 11:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbXKLQkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 11:40:47 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:54577 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752426AbXKLQkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 11:40:46 -0500
Date: Mon, 12 Nov 2007 17:40:23 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] add -fno-tree-scev-cprop to KBUILD_CFLAGS
Message-ID: <20071112164023.GL9771@stusta.de>
References: <20071111064829.GG21669@stusta.de> <47387E32.4050206@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47387E32.4050206@t-online.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 05:24:18PM +0100, Bernd Schmidt wrote:
> Adrian Bunk wrote:
> > The gcc from svn that will become gcc 4.3 generates libgcc calls in 
> > cases like the following (on 32bit architectures):
> > 
> > <--  snip  -->
> > 
> > static inline void timespec_add_ns(struct timespec *a, u64 ns)
> > {
> > ...
> >         while(ns >= NSEC_PER_SEC) {
> >                 ns -= NSEC_PER_SEC;
> >                 a->tv_sec++;
> >         }
> > ...
> > 
> > <--  snip  -->
> > 
> > It can make sense to emit assembler code doing division for such C code -
> > that doesn't seem to be something that would generally be wrong.
> 
> It can be a pretty huge performance regression, so gcc ought to be fixed.

What is better depends on the values of ns and NSEC_PER_SEC.

It can be a performance regression, but there are also cases where it 
can improve performance. If gcc produces lower performance code that
would be a bug in gcc that should be reported, but using a division is 
not generally wrong.

A more clearer example might be:

<--  snip  -->

void foo(u64 ns)
{
	if (ns < 10000)
		return;

	while(ns >= 3) {
		ns -= 3;
#ifdef DEBUG
		bar(ns);
#endif
	}
}

<--  snip  -->

With DEBUG not defined you can hardly argue gcc should be fixed to not 
use a division for performance reasons.

> Bernd

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


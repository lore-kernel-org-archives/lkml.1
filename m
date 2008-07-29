Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbYG2Izd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbYG2Izd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbYG2IzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:55:24 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:53451 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754064AbYG2IzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:55:23 -0400
Date: Tue, 29 Jul 2008 17:54:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: kill include symlinks for sh?
Message-ID: <20080729085440.GD29389@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Sam Ravnborg <sam@ravnborg.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kbuild <linux-kbuild@vger.kernel.org>
References: <20080728115735.GA32089@uranus.ravnborg.org> <20080728231922.GB28055@linux-sh.org> <20080729064049.GA28656@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729064049.GA28656@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 08:40:49AM +0200, Sam Ravnborg wrote:
> Hi Paul
> 
> > This didn't end up being _too_ painful, though it did take a bit of time
> > to hunt down all of the guilty parties. I've pushed out what I have now,
> > which you can see at:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/lethal/sh-2.6.git;a=commitdiff;h=f15cbe6f1a4b4d9df59142fc8e4abb973302cf44
> > 
> > It's been holding up to all of the random builds I've thrown at it so
> > far, so there shouldn't be any really nasty surprises left over.
> 
> I took a quick look at it and the header re-org looks good.
> I like that you added the 'mach-' prefix to the directory names.
> 
> But I also noticed several changes like this:
> -#include <asm/landisk/iodata_landisk.h>
> +#include <mach/iodata_landisk.h>
> 
> In this case you _know_ that this is a landisk so
> the less magic option would have been the longer
> include form like this:
> +#include <mach-landisk/mach/iodata_landisk.h>
> 
> It would be preferable that we use the gcc -I
> directive:
> 
>     -Iarch/sh/include/mach-$MACH
> 
> only to automagically select between identical named
> files for the different platforms and not like
> the above where we use it simply to cut off the include
> path a little.
> 
Yes, I had thought about that as well. We certainly need to go this route
if we are building multiple mach types at the same time. Fortunately the
vast majority of mach types do not have their own include structure, so
it's not been something that's popped up yet as a real problem.

> Another note is that you decided to move the generated
> file over to arch/sh/include too.
> I really do not know if I think this is the right approach.

This was before I realized that asm-offsets.h was being placed in
include/asm-sh anyways, despite the directory not existing until Kbuild
created it. I don't have any problems with moving it back, I just thought
the idea of multiple include directories for the same asm/ prefix seemed
non-intuitive.

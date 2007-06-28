Return-Path: <linux-kernel-owner+w=401wt.eu-S932662AbXF1Xti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662AbXF1Xti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761387AbXF1Xt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:49:27 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:43809 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932555AbXF1XtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:49:25 -0400
Date: Fri, 29 Jun 2007 01:49:49 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, perex@suse.cz
Subject: Re: [PATCH] ALSA: more section mismatches
Message-ID: <20070628234949.GF6087@stusta.de>
References: <20070628150515.0d819891.randy.dunlap@oracle.com> <20070628153949.8582d3a4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070628153949.8582d3a4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 03:39:49PM -0700, Andrew Morton wrote:
> On Thu, 28 Jun 2007 15:05:15 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix section mismatch warnings:
> > 
> > WARNING: sound/built-in.o(.exit.text+0x3ad): Section mismatch: reference to .init.text: (between 'sb_exit' and 'unload_uart6850')
> > WARNING: sound/built-in.o(.exit.text+0x753): Section mismatch: reference to .init.text: (between 'snd_mts64_module_exit' and 'snd_portman_module_exit')
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > ---
> >  sound/drivers/mts64.c |    2 +-
> >  sound/oss/sb_card.c   |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > --- linux-2622-rc6.orig/sound/drivers/mts64.c
> > +++ linux-2622-rc6/sound/drivers/mts64.c
> > @@ -1048,7 +1048,7 @@ static struct platform_driver snd_mts64_
> >  /*********************************************************************
> >   * module init stuff
> >   *********************************************************************/
> > -static void __init_or_module snd_mts64_unregister_all(void)
> > +static void snd_mts64_unregister_all(void)
> 
> Well this is called from __exit, so __init_or_module isn't right.  But we
> don't have an __exit_or_module.
>...

No, it's correct. It simply says that this code can only be discarted 
after initialization if it's not a module, since it's also used from 
__exit code.

The idea behind __init_or_module is that __exit code is never executed 
for non-modular code, and such cases where some function is executed 
both by both __init and __exit and never from other code aren't that 
unusual.

I'm not sure how realistic it is, but it would be best if we could at 
some point in the future simply give gcc a few basic hints that stuff 
like module_init() can use code that is __init and let gcc figure out 
which code to move to this section...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


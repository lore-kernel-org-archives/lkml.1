Return-Path: <linux-kernel-owner+w=401wt.eu-S1762984AbYENR5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762984AbYENR5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbYENR5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:57:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57878 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbYENR5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:57:30 -0400
Date: Wed, 14 May 2008 14:55:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PATCHES] V4L/DVB fixes for 2.6.26
Message-ID: <20080514145554.10e3385c@gaivota>
In-Reply-To: <20080514165434.GC22115@cs181133002.pp.htv.fi>
References: <20080514114910.4bcfd220@gaivota>
	<20080514165434.GC22115@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 19:54:34 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> On Wed, May 14, 2008 at 11:49:10AM -0300, Mauro Carvalho Chehab wrote:
> >...
> > PS.: There are yet a number of other Kconfig potential breakages at V4L/DVB. I'm 
> > currently working on fixing those issues. Basically, what users do is to select 
> > I2C, DVB and V4L as module. This works fine, but more complex scenarios where
> > you mix 'M' and 'Y' inside the subsystem generally cause compilation breakage.
> > Those scenarios are more theorical, since there's not much practical sense on
> > having a DVB driver foo as module, and V4L driver bar as in-kernel. However,
> > the better is to not allow compilation of the scenarios that don't work.
> > 
> > The main trouble at drivers/media Kbuild is that several rules there assumed that
> > "select" would check the "depends on" dependencies of the selected drivers.
> > However, this feature doesn't exist at the current Kbuild implementation. Even
> > if implemented, I suspect that this will generate circular dependency errors on
> > some cases.
> >...
> 
> The basic problem is that drivers/media/ does the most fancy kconfig 
> stuff in the kernel since it tries to both have very fine grained 
> dependencies and offer a usable kconfig UI to the user, which results
> in very complicated dependencies.

True.

> We are not getting this solved by any changes in the kconfig 
> implementation.
> 
> Thinking about reasonable ways to reduce the problem space:
> 
> Where could we reduce the complexity without big disadvantages?
> 
> Could we e.g. let VIDEO_DEV select I2C which would remove all the 
> fiddling with I2C dependencies (which is a bigger part of recent
> problems)?

This seems to be reasonable. However, there are quite a few devices that don't
need I2C (for example, some legacy ISA radio modules - also, some webcam
drivers don't use i2c layer to communicate with their i2c sensor - so - they
don't need I2C. The same also applies to some DVB drivers).

So, I'm not sure if this would be a good idea, since it will force I2C even for
devices that don't need. This is bad, for example, on embedded devices like
set-top-boxes and maybe on cellular phones with non-i2c webcams.

> I can make a patch for it after this pull went into Linus' tree if it is 
> considered an acceptable option.

It would be nice if you could help on fixing those issues.

One dependency that will probably solve is to add "depends on VIDEO_MEDIA &&
I2C" to all devices that are hybrid (bttv, saa7134, cx88, pvrusb, em28xx).

Cheers,
Mauro

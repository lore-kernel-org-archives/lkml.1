Return-Path: <linux-kernel-owner+w=401wt.eu-S1763947AbYDOChW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763947AbYDOChW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 22:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760343AbYDOChJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 22:37:09 -0400
Received: from mail.queued.net ([207.210.101.209]:3334 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758998AbYDOChJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 22:37:09 -0400
Date: Mon, 14 Apr 2008 22:39:15 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 3/3] OLPC: gxfb/lxfb: add DCON panel modes to
 framebuffer drivers
Message-ID: <20080414223915.411e424f@ephemeral>
In-Reply-To: <20080414182112.848bcb64.akpm@linux-foundation.org>
References: <20080414035302.794dcd7a@ephemeral>
	<20080414182112.848bcb64.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 18:21:12 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 14 Apr 2008 03:53:02 -0400 Andres Salomon <dilinger@queued.net> wrote:
> 
> > 
> > Since there's no way to autodetect panel modes, we're forced to hardcode
> > them in the driver and add a big fat #ifdef.  The OLPC DCON needs a
> > specific mode line (at 1200x900).  This adds it to both gxfb and lxfb.
> > 
> > ...
> >
> > +static const struct fb_videomode gx_dcon_modedb[] __initdata = {
> > +const struct fb_videomode olpc_dcon_modedb[] __initdata = {

Hm, that one should be static as well.  Will fix in the following patch.

> 
> include/linux/init.h:38 points out that `const' and `__initdata' should
> not be mixed.
> 
> I forget which architecture/compiler versions explode when we do this.  But
> it's not x86, iirc.
> 
> Still, it's poor form and, err, I don't immediately recall which tag we
> _should_ use, and the comments in there are unhelpful.  It might be
> __initconst, but that has exactly zero users.  Help.
> 


My guess would be __initconst or __devinitconst?  That would put it in
.{init,devinit}.rodata rather than .{init,devinit}.data.

Alternatively, I could just remove the 'const'.

Documentation for this stuff would be awesome.  :/



-- 
Need a kernel or Debian developer?  Contact me, I'm looking for contracts.

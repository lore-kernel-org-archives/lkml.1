Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYCJXEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYCJXEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbYCJXEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:04:36 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55238 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbYCJXEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:04:35 -0400
Date: Tue, 11 Mar 2008 00:05:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andres Salomon <dilinger@queued.net>, adaplas@gmail.com,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       info-linux@geode.amd.com, jordan.crouse@amd.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Re: [PATCH 6/6] PM/FB/gxfb: add config option that allows
	disabling of VT switch during suspend
Message-ID: <20080310230511.GA31750@elf.ucw.cz>
References: <20080308204927.73afa56c@ephemeral> <20080310141939.ce1169c0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310141939.ce1169c0.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-03-10 14:19:39, Andrew Morton wrote:
> On Sat, 8 Mar 2008 20:49:27 -0500
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > This is purely for suspend/resume time optimization.
> > 
> > 
> > >From 874aa20022a2501a30704163ed31a7baba7de9e5 Mon Sep 17 00:00:00 2001
> > From: Andres Salomon <dilinger@debian.org>
> > Date: Wed, 5 Mar 2008 16:40:25 -0500
> > Subject: [PATCH] PM: add config option that allows disabling of VT switch during suspend
> > 
> > Prior to suspend, we allocate and switch to a new VT; after suspend, we
> > switch back to the original VT.  This can be slow, and is completely
> > unnecessary if the framebuffer we're using can restore video properly.
> > 
> > This adds CONFIG_DISABLE_SUSPEND_VT_SWITCH which allows the user to
> > select whether or not to do that switch.  This has been tested with the
> > gxfb driver (on a Geode GX dev board and OLPC prototype machines).  In
> > order for the user to even see this option, a framebuffer has to declare
> > support for it (via CONFIG_FBDEV_SUPPORTS_NOSWITCH).
...
> It would be far preferable to do this via a kernel boot parameter rather
> than via a kernel rebuild.

Actually, it would be better to get this right automatically, without
any config options.

And no, this is not only gxfb/lxfb.  At least Sharp Zaurus and FIC
neo1973 can suspend without switching consoles... 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

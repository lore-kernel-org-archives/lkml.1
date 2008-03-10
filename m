Return-Path: <linux-kernel-owner+w=401wt.eu-S1756480AbYCJXFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbYCJXFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYCJXFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:05:37 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55250 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbYCJXFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:05:36 -0400
Date: Tue, 11 Mar 2008 00:06:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: Andres Salomon <dilinger@queued.net>,
       Andrew Morton <akpm@linux-foundation.org>, adaplas@gmail.com,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       info-linux@geode.amd.com, rjw@sisk.pl, samuel.thibault@ens-lyon.org
Subject: Re: PM/FB/gxfb: add config option that allows disabling of VT
	switch during suspend
Message-ID: <20080310230612.GB31750@elf.ucw.cz>
References: <20080308204927.73afa56c@ephemeral> <20080310141939.ce1169c0.akpm@linux-foundation.org> <20080310174424.29621e62@ephemeral> <20080310145118.adb0cf1e.akpm@linux-foundation.org> <20080310181446.2fb85eea@ephemeral> <20080310222407.GD589@cosmic.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310222407.GD589@cosmic.amd.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > If so, that means extra #ifdef's sprinkled throughout the code.  Note
> > > > that most framebuffer drivers won't be supporting this, and those that
> > > > do will almost certainly always want vt switching turned off..
> > > > 
> > > 
> > > I don't think you need any ifdefs or config options at all, do you?  Just
> > > add a new module parameter to this driver and some little interface into
> > > the PM core which allows the driver to set no_vt_switch?
> > > 
> > 
> > That's a possibility, but doesn't adding hooks into PM core for two
> > drivers (lxfb and gxfb) seems like overkill?  I also don't really see
> > anyone needing to switch back and forth between VT_SWITCH and
> > NO_VT_SWITCH other than to work around possible bugs in the register
> > save/restore code..
> 
> I like Andrew's idea.  I wager This won't be Geode specific for long.
> Either other drivers will get the hint and add real save/restore code
> or the GPU subystem code being worked on by the X folks will come along
> and make the VT switch obsolete for everybody.  Either way, I see hooks
> in the PM core as generic love that everybody can benefit from.

Exactly. We'd like _all_ drivers to behave like this.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

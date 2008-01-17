Return-Path: <linux-kernel-owner+w=401wt.eu-S1758349AbYAQVLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349AbYAQVLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbYAQVLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:11:42 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:39024 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355AbYAQVLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:11:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=twCubWSduXe+aaXM75Cg47V8x9IMIfNIv+Usti9sllN2adOwLmmF1fBDJ+UILeWrG4lDA+AHVVhIKrnTgtwcVbaOLxbVjQBgVrcD9fdaAN+A02hEqORuQ4hLDakWHSgEUMnF94Ycks8r+kwUoIGI1Ds8OJBZfOIwP/gZ+RGMSC4=
Date: Thu, 17 Jan 2008 16:11:36 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Pettersson <william.pettersson@gmail.com>
Subject: Re: [BISECTED] Re: psmouse.c: GlidePoint at isa0060/serio1/input0
	lost sync at byte 1
Message-ID: <20080117153642.ZZRA012@mailhub.coreip.homeip.net>
References: <19f34abd0801071224kb9cb121u244b00b274231db0@mail.gmail.com> <d120d5000801110647k4b1fa49ene974898baf745aec@mail.gmail.com> <478CFB56.1030700@gmail.com> <20080115154142.ZZRA012@mailhub.coreip.homeip.net> <20080116104024.ZZRA012@mailhub.coreip.homeip.net> <19f34abd0801160946j2fe1c75ap3617dd125c81008f@mail.gmail.com> <20080116142815.ZZRA012@mailhub.coreip.homeip.net> <19f34abd0801161219oe478b50se13c0710759d581f@mail.gmail.com> <20080116154524.ZZRA012@mailhub.coreip.homeip.net> <19f34abd0801171226m2ede3572kbaf91e4603313a9c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0801171226m2ede3572kbaf91e4603313a9c@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 09:26:37PM +0100, Vegard Nossum wrote:
> On Jan 16, 2008 9:49 PM, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > Hmm, it seems to work properly, I think it is now a setup issue to a
> > certain degree. The touchpad now works in native mode (as opposed to
> > Intellimouse emulation) and so I'd recommend installing Synaptics X
> > driver from http://web.telia.com/~u89404340/touchpad/
> 
> I have now installed this driver and copied the relevant parts of the
> example X configuration file. However, I do not think that this is the
> correct driver. I can move the mouse around, but only VERY slowly
> (takes 6-7 swipes over the pad just to go from one edge of the screen
> to the other), and only the left/right buttons work. Tapping does NOT
> work. I also installed and ran gsynaptics. I am not sure how or if
> this program will change my X config or not, but changing any settings
> there did not have any effect on the mouse at all. (It also showed
> that tapping was enabled.)

Can I please see you xorg.conf?

> 
> > Just to verify, could you please locate evtest utility and check
> > whether your up and down buttons generate BTN_FORWARD and BTN_BACK
> > events?
> 
> Where can I find evtest?

Try grabbing the source from here:

http://linuxconsole.cvs.sourceforge.net/*checkout*/linuxconsole/ruby/utils/evtest.c?revision=1.23

> 
> Still, I wonder if it may be better for me to use the old driver
> (ImPS/2 -- is this the Intellimouse?) since this used to work
> perfectly for me earlier. Maybe I can just remove the GlidePoint
> driver from my kernel to force the older driver?
>

psmouse.proto=exps if psmouse is built in or add "options psmouse proto=exps"
to your /etc/modprobe.conf if psmouse is a module.

-- 
Dmitry

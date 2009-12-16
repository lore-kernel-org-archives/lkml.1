Return-Path: <linux-kernel-owner+w=401wt.eu-S1761824AbZLPIX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761824AbZLPIX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761748AbZLPIXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:23:23 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:64423 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbZLPIXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:23:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fIOILSzno3teB1Pkhib6wZM2PXWq94XbSkuQGjQIMH29lwlCiDQCB1IrlFMxCrh5Tm
         FgEjqLGuaky3iBPjSbxhSWUZ6Y8MmeVV9dIcuSVgYGn4+0xMFvVtB27RGIXZMYKuxpNK
         yt9m1tRsf9kdW9La9CB/o6q3Qm2C3J4igXuZc=
Date: Wed, 16 Dec 2009 00:23:16 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Alex Chiang <achiang@hp.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: synaptics touchpad doesn't click
Message-ID: <20091216082316.GH2699@core.coreip.homeip.net>
References: <20091215062628.GA12669@core.coreip.homeip.net> <s5h1viwn3ig.wl%tiwai@suse.de> <20091215073358.GC12669@core.coreip.homeip.net> <s5hvdg8lm5q.wl%tiwai@suse.de> <20091215082518.GD12669@core.coreip.homeip.net> <20091216010506.GA26367@ldl.fc.hp.com> <20091216025934.GA2699@core.coreip.homeip.net> <s5hk4wn5s4x.wl%tiwai@suse.de> <20091216065652.GE2699@core.coreip.homeip.net> <s5heimv5r20.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5heimv5r20.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 08:14:15AM +0100, Takashi Iwai wrote:
> At Tue, 15 Dec 2009 22:56:53 -0800,
> Dmitry Torokhov wrote:
> > 
> > On Wed, Dec 16, 2009 at 07:50:54AM +0100, Takashi Iwai wrote:
> > > At Tue, 15 Dec 2009 18:59:34 -0800,
> > > Dmitry Torokhov wrote:
> > > > 
> > > > On Tue, Dec 15, 2009 at 06:05:06PM -0700, Alex Chiang wrote:
> > > > > * Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> > > > > >
> > > > > > The updated patch is below.
> > > > > > 
> > > > > > -- 
> > > > > > Dmitry
> > > > > 
> > > > > Should I test this one or wait one more iteration to address
> > > > > Takashi's last comments?
> > > > > 
> > > > 
> > > > Actually I think we took the wrong direction with the original patch and
> > > > we should do what other buttonless devices (bcm5974) do: report touchpad
> > > > click as left button and have Synaptics X driver provide enhanced
> > > > support. This way we can have both modes (ClickZones and ClickButtons)
> > > > and users will get to chose (provided that someone takes time to add
> > > > that support to Synaptics driver of course ;) ).
> > > 
> > > My concern is, still, how would you identify this device.  Will you
> > > extend also some ioctls to expose caps and extcaps?  Otherwise it's
> > > difficult to identify this device automatically from the user-space.
> > > 
> > 
> > No.. Synaptics without right button == ClickPad.
> 
> So, is there only Clickpad device that has a single button?
> No other option?
> 

I have not seen any other Synaptics devices using less than 2 buttons.

> > > The user-space can know that it's button-less, yes.  But, how can it
> > > know whether the device should be emulated via ClickZone?
> > > We can use a driver option to x11 synaptics driver for that, as I
> > > already sent you another patch.  However, the driver option is
> > > nowadays not preferred because xorg.conf is being dead on new
> > > systems...
> > 
> > Driver still takes options, from UDEV/HAL. We could pick one behavior
> > by default and ovverride, by box vendor/model (DMI).
> > 
> > > 
> > > Or maybe HAL (or whatever upcoming one) can check the vendor/product
> > > id of the machine (not the device) to provide the information.  OTOH
> > > this will also need frequent updates.
> > 
> > Hopefully vendors won;t be flip/flopping between ClickZone and
> > ClickButtons too much. Still option is better than hardcoding ClickZone
> > for everyone.
> 
> Yeah, I agree that hard-coding isn't good, and that's why I first
> posted separated patches.  OTOH, the kernel-side hack makes the device
> working *as is* even without changing anything else.
>

For "ClickZone" - yes, but not all users would want this I guess and not
all laptops will have that zone marked. Pushing it off to userspace
gives more flexibility, including the ability to change zone size, etc.

-- 
Dmitry

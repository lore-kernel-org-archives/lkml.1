Return-Path: <linux-kernel-owner+w=401wt.eu-S933562AbZLPG5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562AbZLPG5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 01:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbZLPG46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 01:56:58 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:33757 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187AbZLPG45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 01:56:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w1XkO4yIlT7K829ee/BileG/N7zuxcHnv4c1eWi0Wy1rgokCACf/PX/FV8qaZOxtAu
         mO6JiewElsH66gNCP+VkzqEI+3c60UxqAUKPZiF5WsAQcLYCJjlkvavrSQipBJ0ahBTp
         ItVIUPHGv83JYUpwkaHNwZgDV/6+aj32sK0hc=
Date: Tue, 15 Dec 2009 22:56:53 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Alex Chiang <achiang@hp.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: synaptics touchpad doesn't click
Message-ID: <20091216065652.GE2699@core.coreip.homeip.net>
References: <20091214173450.GB2373@core.coreip.homeip.net> <20091215034127.GC587@ldl.fc.hp.com> <20091215062628.GA12669@core.coreip.homeip.net> <s5h1viwn3ig.wl%tiwai@suse.de> <20091215073358.GC12669@core.coreip.homeip.net> <s5hvdg8lm5q.wl%tiwai@suse.de> <20091215082518.GD12669@core.coreip.homeip.net> <20091216010506.GA26367@ldl.fc.hp.com> <20091216025934.GA2699@core.coreip.homeip.net> <s5hk4wn5s4x.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hk4wn5s4x.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 07:50:54AM +0100, Takashi Iwai wrote:
> At Tue, 15 Dec 2009 18:59:34 -0800,
> Dmitry Torokhov wrote:
> > 
> > On Tue, Dec 15, 2009 at 06:05:06PM -0700, Alex Chiang wrote:
> > > * Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> > > >
> > > > The updated patch is below.
> > > > 
> > > > -- 
> > > > Dmitry
> > > 
> > > Should I test this one or wait one more iteration to address
> > > Takashi's last comments?
> > > 
> > 
> > Actually I think we took the wrong direction with the original patch and
> > we should do what other buttonless devices (bcm5974) do: report touchpad
> > click as left button and have Synaptics X driver provide enhanced
> > support. This way we can have both modes (ClickZones and ClickButtons)
> > and users will get to chose (provided that someone takes time to add
> > that support to Synaptics driver of course ;) ).
> 
> My concern is, still, how would you identify this device.  Will you
> extend also some ioctls to expose caps and extcaps?  Otherwise it's
> difficult to identify this device automatically from the user-space.
> 

No.. Synaptics without right button == ClickPad.

> The user-space can know that it's button-less, yes.  But, how can it
> know whether the device should be emulated via ClickZone?
> We can use a driver option to x11 synaptics driver for that, as I
> already sent you another patch.  However, the driver option is
> nowadays not preferred because xorg.conf is being dead on new
> systems...

Driver still takes options, from UDEV/HAL. We could pick one behavior
by default and ovverride, by box vendor/model (DMI).

> 
> Or maybe HAL (or whatever upcoming one) can check the vendor/product
> id of the machine (not the device) to provide the information.  OTOH
> this will also need frequent updates.

Hopefully vendors won;t be flip/flopping between ClickZone and
ClickButtons too much. Still option is better than hardcoding ClickZone
for everyone.

-- 
Dmitry

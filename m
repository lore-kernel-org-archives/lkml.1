Return-Path: <linux-kernel-owner+w=401wt.eu-S1762663AbZLPRmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762663AbZLPRmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762652AbZLPRmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:42:39 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:45877 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762641AbZLPRmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:42:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rM1g+mZqPdj0zz0m2hQsNHglgJLuCcJkeiAPgks2DATS/xSffkXJomPx5EFBf3q5Xa
         //6w4RxZsonjvzV9736AUPLUtdw2gIrwkf7xomDR4QUrmzjoS7rCI9HCsSP3Ob3eaSsh
         +oKjTl4c0K4a7dCCO0DDAWCWA43LnXqXTTmak=
Date: Wed, 16 Dec 2009 09:42:19 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: synaptics touchpad doesn't click
Message-ID: <20091216174218.GC6800@core.coreip.homeip.net>
References: <20091215062628.GA12669@core.coreip.homeip.net> <s5h1viwn3ig.wl%tiwai@suse.de> <20091215073358.GC12669@core.coreip.homeip.net> <s5hvdg8lm5q.wl%tiwai@suse.de> <20091215082518.GD12669@core.coreip.homeip.net> <20091216010506.GA26367@ldl.fc.hp.com> <20091216025934.GA2699@core.coreip.homeip.net> <20091216065200.GC20352@ldl.fc.hp.com> <20091216070343.GF2699@core.coreip.homeip.net> <20091216173159.GA26757@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216173159.GA26757@ldl.fc.hp.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 10:31:59AM -0700, Alex Chiang wrote:
> * Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> > On Tue, Dec 15, 2009 at 11:52:00PM -0700, Alex Chiang wrote:
> > > * Dmitry Torokhov <dmitry.torokhov@gmail.com>:
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
> > > > 
> > > > Could you tell me if the below works for you?
> > > 
> > > Left clicks work. Right/middle do not (as expected, I guess).
> > > 
> > > I liked the behaviour of Takashi's patch a little better wrt what
> > > happens when you try to click/drag, because he disabled movement
> > > in the click area.
> > 
> > Are the clicks register only in that special area? Reading Synaptics
> > product description it sounds like entire surface should be clickable.
> 
> Well, maybe in theory the entire surface is clickable.
> 
> My observation is that the physical design resembles a lever on a
> fulcrum though, with the fulcrum at the edge near the keyboard.
> 
> Pressing the click zone is mechanically nice, since you are away
> from the fulcrum. Moving "up" towards the keyboard, there seems
> to be much less mechanical advantage, and the surface doesn't
> seem so clicky.
> 

I am going off the following:

	http://www.synaptics.com/solutions/products/clickpad

I am no sure whether there are 2 different flavors or if they are all
the same and the only difference is whether the buttons are marked or
not.

> But really, I was talking about what Takashi mentioned in a later
> mail, namely that trying to actually click with the click zone in
> a precise manner is difficult because as you press the surface
> down, the touch pad registers some movement, and moves the
> pointer away from the area you're trying to click.
> 
> Fitts would have a fit. ;)

That will have to be handled in synaptics X driver.

-- 
Dmitry

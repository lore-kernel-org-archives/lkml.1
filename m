Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935157Ab0BZDyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 22:54:55 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41985 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935056Ab0BZDyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 22:54:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=EA2DeF1/Jw5f3u/9gssSNnxYXqfxIFd/fTdYmn/gsoGiiOil1r/tufc0Ab9t79XZOQ
         EavzNdTnpdcvZ0wudHTek2FyTeSqpeahjcbd81TOSZ/Q06JuwHLegHdtHZZlhKDyB463
         VoDETbx2Q2Y4lcuEk0vDYrCizJXfgvpUSEYVk=
Date: Thu, 25 Feb 2010 19:54:48 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, mgarski@post.pl,
       linux-input@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] Route kbd leds through the generic leds layer (3rd
 version)
Message-ID: <20100226035448.GA16797@core.coreip.homeip.net>
References: <20100224012010.GA4062@const>
 <20100225013840.GA5519@const.homenet.telecomitalia.it>
 <20100225102056.GG10823@core.coreip.homeip.net>
 <20100225214403.GB9378@const.homenet.telecomitalia.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100225214403.GB9378@const.homenet.telecomitalia.it>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 10:44:03PM +0100, Samuel Thibault wrote:
> Dmitry Torokhov, le Thu 25 Feb 2010 02:20:56 -0800, a écrit :
> > I am aunsure about this patch. It ties all LEDs together
> 
> For now, yes.  There could be an additional per-device layer that the
> user could select instead, but my patch doesn't prevent that.
> 
> > whereas currently it is possible to operate keyboards and their leds
> > independently
> 
> You mean through the input layer?  Technically, yes, but at least my
> patch is an improvement over what exists right now: at first read of
> your sentence I thought "of course not! keyboard.c does it for all
> devices!", so it's not a regression in that concern.

Right now on .33, if you write LED event to one event device while
legacy keyboard driver is inactive (in raw mode) then that write will
only affect that particular event device, not the rest of them. Your
patch changes that.

Whether LED state should be shared between all input devices or should
be kept separate is a matter of policy and we try to keep policy in
userspace.

>  On the contrary,
> it fixes the problem of proper caps lock with led feedback.
> 

I am unaware of such issue, any pointers?

> Being able to assign only some of the devices to the linux console
> would indeed probably be good, but to me it's just a refinement. Users
> a priori assume all keyboards get their leds updated, so my patch
> makes sense.  And it won't prevent a further patch that, in addition
> to input::<led> leds, adds per-device leds, which the user could use
> instead of input::<led>.

I think that if we want to go LED route we shoudl start with adding led
devices to individual keyboard drivers first and then convert legacy
keyboard to use trigger instead of talking to input devices directly.

Thanks.

-- 
Dmitry

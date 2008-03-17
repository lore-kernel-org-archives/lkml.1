Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbYCQJwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbYCQJwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 05:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYCQJwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 05:52:07 -0400
Received: from tim.rpsys.net ([194.106.48.114]:35840 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbYCQJwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 05:52:06 -0400
Subject: Re: LED naming standard for LED class
From: Richard Purdie <rpurdie@rpsys.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080317033458.GA20486@khazad-dum.debian.net>
References: <1202380503.9519.21.camel@dax.rpnet.com>
	 <20080207213845.GA27862@khazad-dum.debian.net>
	 <1202422388.9519.123.camel@dax.rpnet.com>
	 <20080316181840.GG19825@khazad-dum.debian.net>
	 <1205695756.4524.20.camel@dax.rpnet.com>
	 <20080316194823.GA31782@khazad-dum.debian.net>
	 <20080317033458.GA20486@khazad-dum.debian.net>
Content-Type: text/plain
Date: Mon, 17 Mar 2008 09:51:55 +0000
Message-Id: <1205747515.4552.15.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-17 at 00:34 -0300, Henrique de Moraes Holschuh wrote:
> Richard, isn't there *any* way to change this new ABI?  It has not been in
> any stable mainline release yet, so it is not too late if we do it now.

It is not an new ABI, its an extension as per the way it was documented
to work.

> Even if the lenght limit for sysfs entries (19 chars + NULL) is lifted in
> 2.6.26, the current proposal that would become stable in 2.6.25 is still
> ugly, and not nearly close to the best we could do, IMHO.
> 
> The only technical reason I can see for the "devicename" part of the LED
> name is to avoid clashes (or as a placeholder when you have no function).
> However, it is the least important information for any sort of generic LED
> tool (which is the only reason to even bother with a LED naming standard to
> begin with), so it certainly should not come first in the name.  And there
> are other ways to avoid clashes that waste far less real state than the
> device name.
>
> Can't we have "function[:color].<number>" instead?   And allow for a choice
> of "devicename" or simply "led" instead of "function" for leds with no
> defined or implied function?
> 
> It places fields in order of importance (thus it is far more user-friendly),
> it wastes less real state (typically just two chars) to avoid clashes, and
> it also follows what we already have on other sysfs subsystems (except for
> the :color part, and I agree with you that it is a desireable thing to have
> in there).
> 
> The clash-avoiding ".%d" postfix would be taken care of by the class.  If
> two devices are registered with a "battery:green" name, you'd end up with
> "battery:green.0" and "battery:green.1".  If just one device tries to
> register "battery:yellow", you'd get "battery:yellow.0".
> 
> Later (for 2.6.26) I'd also suggest adding the color notion to the *class*
> itself, including the notion of "undefined" color.  The class would take
> care to add the ":color" part of the node name (when it is not "undefined")
> and *also* export the color as an attribute. I can write this patch too, if
> you want.
> 
> Would you take patches to implement the "function[:color].<ordinal>" naming
> scheme, and try to merge them into 2.6.25?  Avoiding a bad ABI becoming
> stable *is* an acceptable reason for a late merge.

The problem is the "bad" ABI has existed in that form since somewhere
around 2.6.15 and it is therefore too late to drop things from it or
rearrange it. The ABI described additions being allowed so we're taking
advantage of that to gain something which should have really been there
originally. Short term there is some complexity with some limits but
they're going away so there is no problem.

The whole point of the naming was so at a glance you can tell which LEDs
are which and whilst the device name isn't important in the things
you're considering, in general it does make sense, particularly if we
see LEDs attached to removable hardware for example.

The alternative is we throw the whole thing away and go to random
numbers for the different LEDs and attributes. To work out which LED is
which you then have to read up to 3 files per LED before you can even
decide whether its the one you want. I don't like that idea...

Cheers,

Richard



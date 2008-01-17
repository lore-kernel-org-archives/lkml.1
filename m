Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbYAQU0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbYAQU0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYAQU0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:26:39 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:28373 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYAQU0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:26:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WlwFSL/FlSN99atWwnPzMECukFqMy3nM1CXWt6BJkyzkaf1jFsce7/73Z8YvNutls11ZJ2/iU/5bmjem+2aKFKpBx/igllW6ierLhDWpklpxJtzCP8LETA9e23iMLiP7NCnVn1keXLdtA+wASUnXIDYZDvYYWetbXN1Ve8meDS0=
Message-ID: <19f34abd0801171226m2ede3572kbaf91e4603313a9c@mail.gmail.com>
Date: Thu, 17 Jan 2008 21:26:37 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [BISECTED] Re: psmouse.c: GlidePoint at isa0060/serio1/input0 lost sync at byte 1
Cc: linux-input@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Pettersson" <william.pettersson@gmail.com>
In-Reply-To: <20080116154524.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0711141226n60323630rdc4833db0bfb2eeb@mail.gmail.com>
	 <19f34abd0801071224kb9cb121u244b00b274231db0@mail.gmail.com>
	 <d120d5000801110647k4b1fa49ene974898baf745aec@mail.gmail.com>
	 <478CFB56.1030700@gmail.com>
	 <20080115154142.ZZRA012@mailhub.coreip.homeip.net>
	 <20080116104024.ZZRA012@mailhub.coreip.homeip.net>
	 <19f34abd0801160946j2fe1c75ap3617dd125c81008f@mail.gmail.com>
	 <20080116142815.ZZRA012@mailhub.coreip.homeip.net>
	 <19f34abd0801161219oe478b50se13c0710759d581f@mail.gmail.com>
	 <20080116154524.ZZRA012@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 16, 2008 9:49 PM, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> Hmm, it seems to work properly, I think it is now a setup issue to a
> certain degree. The touchpad now works in native mode (as opposed to
> Intellimouse emulation) and so I'd recommend installing Synaptics X
> driver from http://web.telia.com/~u89404340/touchpad/

I have now installed this driver and copied the relevant parts of the
example X configuration file. However, I do not think that this is the
correct driver. I can move the mouse around, but only VERY slowly
(takes 6-7 swipes over the pad just to go from one edge of the screen
to the other), and only the left/right buttons work. Tapping does NOT
work. I also installed and ran gsynaptics. I am not sure how or if
this program will change my X config or not, but changing any settings
there did not have any effect on the mouse at all. (It also showed
that tapping was enabled.)

> Just to verify, could you please locate evtest utility and check
> whether your up and down buttons generate BTN_FORWARD and BTN_BACK
> events?

Where can I find evtest? It is not in my distribution's software
repository (Fedora 8). I have tried to use xev instead (I do not know
if this is sufficient), and it reports the following when I press
up/down buttons:

ButtonPress event, serial 31, synthetic NO, window 0x3200001,
    root 0x13b, subw 0x0, time 2305203062, (49,88), root:(600,409),
    state 0x0, button 4, same_screen YES

ButtonRelease event, serial 31, synthetic NO, window 0x3200001,
    root 0x13b, subw 0x0, time 2305203062, (49,88), root:(600,409),
    state 0x800, button 4, same_screen YES

ButtonPress event, serial 31, synthetic NO, window 0x3200001,
    root 0x13b, subw 0x0, time 2305205151, (49,88), root:(600,409),
    state 0x0, button 5, same_screen YES

ButtonRelease event, serial 31, synthetic NO, window 0x3200001,
    root 0x13b, subw 0x0, time 2305205151, (49,88), root:(600,409),
    state 0x1000, button 5, same_screen YES


Still, I wonder if it may be better for me to use the old driver
(ImPS/2 -- is this the Intellimouse?) since this used to work
perfectly for me earlier. Maybe I can just remove the GlidePoint
driver from my kernel to force the older driver?


Kind regards,
Vegard Nossum

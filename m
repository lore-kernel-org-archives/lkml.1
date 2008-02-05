Return-Path: <linux-kernel-owner+w=401wt.eu-S1762056AbYBEXU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056AbYBEXU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758635AbYBEXUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:20:20 -0500
Received: from xerxes.tchmachines.com ([208.76.80.175]:45331 "EHLO
	xerxes.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059AbYBEXUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:20:18 -0500
Message-ID: <54602.69.30.123.189.1202253615.squirrel@architechnical.net>
In-Reply-To: <20080204213100.GA30382@sirena.org.uk>
References: <3713.69.30.58.166.1202151624.squirrel@architechnical.net>
    <20080204213100.GA30382@sirena.org.uk>
Date: Tue, 5 Feb 2008 18:20:15 -0500 (EST)
Subject: Re: [UPDATED v4] WM97xx touchscreen drivers
From: linux01@architechnical.net
To: linux01@architechnical.net, linux-kernel@vger.kernel.org,
       laim.girdwood@wolfsonmicro.com
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - xerxes.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - architechnical.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The expectation of this driver is that the battery monitor driver will
> register as the "wm97xx-battery" device and use the wm97xx_read_aux_adc()
> function exported by the wm97xx-core driver to access the ADC.  Is your
> driver using this interface?

Yes, but this makes the wm97xx-battery device depend on configuring in the
touchscreen.

The problem we're having is that when we updated wm97xx-core.c from
version 0.62 to 0.65 the ADC values returned by wm97xx_read_aux_adc() to
the battery driver changed.  We did modify both versions to make the
struct wm97xx * global so the battery monitor could pass it to
wm97xx_read_aux_adc() (is there a better way?).

> The intention is that these drivers should be able to coexist with the
> existing ASoC drivers as-is.  We do have existing users doing this - the
> first publicly available example that springs to mind is tosa which
> also uses the wm9712 with touchscreen and battery, together with the
> ASoC driver for audio (the ASoC bits of this have been merged since ASoC
> was merged in 2006, the other bits are out of tree partly due to the
> fact that they depend on this driver).

They don't just coexist with soc, they depend on it.  If you configure out
the AC97 driver under soc the touchscreen and battery drivers won't work
(but they'll build).  We used the same architecture as tosa and retained
the OH guys for the app framework (and platform assistance - thanks RP :).

> The most obvious way forward if we can't resolve these problems with the
> existing scheme is to pull out the core driver as you say above - this
> is the approach already taken by the touch drivers to allow battery
> monitoring while the touchscreen is in use.
>

In my mind the wm97xx-core module is independent and exposes an API backed
by wm9712/13/etc.  Layered above that, built into their respective code
areas, are the sound, touchscreen, battery monitor, various platform usage
of the aux ADC channels, etc.  I'm not saying this is possible, without
caveat, or practical, but I would say academically ideal.  Thanks for
keeping the conversations going, as I appreciate these drivers moving into
mainline which reduces our maintenance impact.

> Is your kernel (or the wm9712-related code at least) publicly available?
> If not would it be possible for you to share it with me off-list?  It
> might help me understand what's going on here.
>

The first release is publicly available; the release I'm working on was
aimed for the 2.6.24 merge window but some key stuff (ARM clock/power
management, USB gadget) changed causing me to re-engineer.  I'm still
troubleshooting some 2.6.18-->24 port issues here (pxa27x_ac97 errors on
resume - we use deep sleep, not sleep on the pxa270), but can publicize a
source tarball and send you the link.


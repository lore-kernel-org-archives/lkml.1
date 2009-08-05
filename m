Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbZHEWxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbZHEWxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 18:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZHEWxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 18:53:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:36743 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752099AbZHEWxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 18:53:06 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18mNWIeb1Emcepe0tNJBuCt3FWmpoFAeDjf6SM786
	cY63BEx9eX7/Ug
Date: Thu, 6 Aug 2009 00:53:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ian Molton <ian@mnementh.co.uk>
cc: Magnus Damm <magnus.damm@gmail.com>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: MMC: Make the configuration memory resource optional
In-Reply-To: <4A7A08FE.5000909@mnementh.co.uk>
Message-ID: <Pine.LNX.4.64.0908060045320.9219@axis700.grange>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange> 
 <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com> 
 <4A7053E8.8050303@mnementh.co.uk>  <20090729201702.GA28202@linux-sh.org> 
 <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com> 
 <4A716F1C.2050805@mnementh.co.uk>  <Pine.LNX.4.64.0907301246330.4462@axis700.grange>
  <4A71F2A5.4060206@mnementh.co.uk>  <aec7e5c30908021952j7947b513w7d62f2c4d87bd3c5@mail.gmail.com>
  <4A787C2C.5070000@mnementh.co.uk> <aec7e5c30908041908p568f413albef7dede3fd2cb83@mail.gmail.com>
 <4A798A4B.4000901@mnementh.co.uk> <Pine.LNX.4.64.0908051702180.5802@axis700.grange>
 <4A7A08FE.5000909@mnementh.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Aug 2009, Ian Molton wrote:

> Guennadi Liakhovetski wrote:
> 
> > How do we verify this? Do I need some "very fast" card, so that sd would try
> > to drive the clock beyond pdata->hclk / 2, which should then fail? 
> 
> One way would be a 'scope on the card pins, but since you havent said I am
> assuming you have not altered the clock-speed setting routine.
> 
> Here you can see why I didnt like the silently-drop-conf-accesses version of
> the patch.  If you had not made conf area accesses silently succeed, you'd
> have found one lurking in the set_clock function.
> 
> Since your controller has no CNF area, it was discarding the write to the 1:1
> clock bit (that isnt  in its none-existant conf area) and thus you got the
> next lowest clock as a result (/2)
> 
> > Currently I'm using 24MHz (copied from the original driver), and the only
> > thing I know about the controller is its "Maximum operating frequency: 25
> > MHz."
> 
> Thats the HCLK frequency, not the card clock.

Sure, and the card clock is derived from the HCLK, as you describe below.

> the TMIO MFD devices can divide this HCLK by anything from 512 to 2, and  MFD
> devices have a facility to disable the divider, yielding full HCLK speed as
> the card clock.
> 
> If you havent already found a 1:1 clock enable bit on your device, you might
> try looking for it - it'd yield a near linear factor-of-two speed increase.

I think, even getting the driver work with half the maximum speed (without 
the 1:1 speed) would be a good progress for SH. And I personally have no 
idea how I could "find" that divider-disable bit. Please notice, that I'm 
away for a week starting tomorrow, hopefully, Magnus will be able to 
further work with you on this during this time.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

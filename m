Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbZHEXGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbZHEXGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 19:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZHEXGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 19:06:30 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:53509 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbZHEXG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 19:06:29 -0400
Message-ID: <4A7A106B.2070809@mnementh.co.uk>
Date: Thu, 06 Aug 2009 00:06:19 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Magnus Damm <magnus.damm@gmail.com>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: MMC: Make the configuration memory resource optional
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>  <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>  <4A7053E8.8050303@mnementh.co.uk>  <20090729201702.GA28202@linux-sh.org>  <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com>  <4A716F1C.2050805@mnementh.co.uk>  <Pine.LNX.4.64.0907301246330.4462@axis700.grange>  <4A71F2A5.4060206@mnementh.co.uk>  <aec7e5c30908021952j7947b513w7d62f2c4d87bd3c5@mail.gmail.com>  <4A787C2C.5070000@mnementh.co.uk> <aec7e5c30908041908p568f413albef7dede3fd2cb83@mail.gmail.com> <4A798A4B.4000901@mnementh.co.uk> <Pine.LNX.4.64.0908051702180.5802@axis700.grange> <4A7A08FE.5000909@mnementh.co.uk> <Pine.LNX.4.64.0908060045320.9219@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0908060045320.9219@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:

>> Thats the HCLK frequency, not the card clock.
> 
> Sure, and the card clock is derived from the HCLK, as you describe below.

Ok, so then your controller (unless it uses a different scheme 
altogether for the card clock divider) probably has a max card clock of 
12MHz and a min of 24/512MHz.

I will change the driver so that it automatically alters the max 
frequency based on the presence of a function to (en,dis)able the 1:1 bit.

> I think, even getting the driver work with half the maximum speed (without 
> the 1:1 speed) would be a good progress for SH.

I'm fine with that. If someone who _has_ this hardware could get a 
'scope on the card clock and see what frequencies actually appear out 
there, I'd _really_ appreciate it.

In the meantime, I'm going to assume it follows the scheme above.

> And I personally have no 
> idea how I could "find" that divider-disable bit.

Just how sure are you that your chip _doesnt_ have the cnf area, before 
we go to far on this... how did you arrive at that conclusion?

Have you checked to see if it appears at other offsets than it does in 
the MFD chips ?

> Please notice, that I'm 
> away for a week starting tomorrow, hopefully, Magnus will be able to 
> further work with you on this during this time.

Hope so - It was aloways my goal to make tmio-mmc reuseable - thats why 
I pushed for the MFD framework in the first place...

-Ian

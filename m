Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZG2Mhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZG2Mhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbZG2Mhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:37:39 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:36216 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbZG2Mhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:37:38 -0400
Message-ID: <4A704288.5080406@mnementh.co.uk>
Date: Wed, 29 Jul 2009 13:37:28 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Magnus Damm <magnus.damm@gmail.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange> <4A6F033B.7030302@mnementh.co.uk> <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com> <20090729115817.GA12223@rakim.wolfsonmicro.main>
In-Reply-To: <20090729115817.GA12223@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:

Hi Mark,

> Looking at the original patch I'm not sure exactly why it runs into
> clock API issues so I'm not sure if this is a relevant concern or not
> here

The problem for tmio-mmc is that its an MFD driver. The idea behind the 
MFD framework was to allow drivers that work on similar hardware to work 
both independantly and as part of a MFD, which often have extra core logic.

Using the clock API is problematic, then, because for MFD based users of 
tmio-mmc, the clock API isnt useable, but for non-MFD users, it is.

tmio-mmc has (currently) some code in it that uses a second IO range to 
control both clocks and power on the toshiba family of MFDs. This 
ideally would be replaced by the clock API and a bunch of power control 
callbacks that would abstract it out completely from the tmio-mmc driver 
and into either platform or MFD core code depending on what the user of 
the driver is.

IOW, using the clock API will fix it for everyone.

 > bI'd kind of expect an impact on the
> SoCs from addressing it due to the way the clock API functions are
> currently provided.

Quite.

-Ian

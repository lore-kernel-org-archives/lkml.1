Return-Path: <linux-kernel-owner+w=401wt.eu-S934477AbZHEOKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477AbZHEOKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 10:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934458AbZHEOKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 10:10:23 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:60750 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934410AbZHEOKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 10:10:22 -0400
Message-ID: <4A7992C1.2070900@mnementh.co.uk>
Date: Wed, 05 Aug 2009 15:10:09 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: pHilipp Zabel <philipp.zabel@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Magnus Damm <magnus.damm@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: MMC: Make the configuration memory resource optional
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>  <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com>  <20090729115817.GA12223@rakim.wolfsonmicro.main>  <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com>  <20090729124233.GA12802@rakim.wolfsonmicro.main>  <aec7e5c30907290551y77edc6d7qb7b3d787215c2b4@mail.gmail.com>  <4A704777.70001@mnementh.co.uk>  <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>  <4A7053E8.8050303@mnementh.co.uk>  <20090729201702.GA28202@linux-sh.org> <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com> <4A716F1C.2050805@mnementh.co.uk> <Pine.LNX.4.64.0907301246330.4462@axis700.grange> <4A71F2A5.4060206@mnementh.co.uk> <Pine.LNX.4.64.0907310853470.4541@axis700.grange> <4A7731C8.9040407@mnementh.co.uk> <Pine.LNX.4.64.0908051445120.5802@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0908051445120.5802@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> Hi Ian

Hi,

> With my patches the tmio_mmc_clk_stop() function looked like this 
> (pseudocode):
> 
> tmio_mmc_clk_stop()
> {
> 	CTL_CLK_AND_WAIT_CTL = 0x0000;
> 	msleep(10);
> 	CTL_SD_CARD_CLK_CTL &= ~0x0100;
> 	msleep(10);
> 	clk_disable(clk);
> }
> 
> I splitted the clk_disable() call out in a separate function and moved 
> _only_ it after the reset() call - it worked too. Does this answer your 
> question?

What is clk? HCLK?

If so, then I'm not surprised it didn't work. tmio_mmc_clk_stop/start() 
are for controlling the card clock.

What you have done is too disable the host clock when you disable the 
card clock. Frankly, I'm amazed it worked at all.

The correct fix would be to remove the clk_disable(clk) from your 
function. The host clock should be running constantly (unless 
suspended). The card clock is gated.

You should probably also check the placement of wherever your 
clk_enable() is too.

-Ian

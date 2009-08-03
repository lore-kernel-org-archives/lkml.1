Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbZHCSwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbZHCSwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbZHCSwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:52:04 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:43076 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbZHCSwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:52:03 -0400
Message-ID: <4A7731C8.9040407@mnementh.co.uk>
Date: Mon, 03 Aug 2009 19:51:52 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: pHilipp Zabel <philipp.zabel@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Magnus Damm <magnus.damm@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>  <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com>  <20090729115817.GA12223@rakim.wolfsonmicro.main>  <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com>  <20090729124233.GA12802@rakim.wolfsonmicro.main>  <aec7e5c30907290551y77edc6d7qb7b3d787215c2b4@mail.gmail.com>  <4A704777.70001@mnementh.co.uk>  <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>  <4A7053E8.8050303@mnementh.co.uk>  <20090729201702.GA28202@linux-sh.org> <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com> <4A716F1C.2050805@mnementh.co.uk> <Pine.LNX.4.64.0907301246330.4462@axis700.grange> <4A71F2A5.4060206@mnementh.co.uk> <Pine.LNX.4.64.0907310853470.4541@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0907310853470.4541@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:

>> I cant see _why_ this should be a problem, as this disables the card clock,
>> not HCLK. Could you debug further in tmio_mmc_clk_stop() please and see if
>> reordering only one of the two IO accesses cures this?
> 
> Not sure I understood the "reordering only one of the two IO accesses" 
> correctly, but I swapped the two sd_ctrl_write16() calls in 
> tmio_mmc_clk_stop() and no, it didn't cure the problem.

I meant can you reorder them so that only one or the other is after the 
reset. Thus eliminating one  (perhaps) as the cause of the problem.

Does your chip actually use the tmio-type reset, or has it a hard reset 
line or something?

Also is your issue that the driver doesnt work, or that you cant access 
registers from something like userspace ?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbZGaGza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbZGaGza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 02:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZGaGz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 02:55:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:34854 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751928AbZGaGz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 02:55:28 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18cU2ssCogc31XyUMu2ducZfHQpMBHpT6Z4bP+YAS
	iJAjM0Clryu3GI
Date: Fri, 31 Jul 2009 08:55:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ian Molton <ian@mnementh.co.uk>
cc: pHilipp Zabel <philipp.zabel@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Magnus Damm <magnus.damm@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
In-Reply-To: <4A71F2A5.4060206@mnementh.co.uk>
Message-ID: <Pine.LNX.4.64.0907310853470.4541@axis700.grange>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange> 
 <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com> 
 <20090729115817.GA12223@rakim.wolfsonmicro.main> 
 <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com> 
 <20090729124233.GA12802@rakim.wolfsonmicro.main> 
 <aec7e5c30907290551y77edc6d7qb7b3d787215c2b4@mail.gmail.com> 
 <4A704777.70001@mnementh.co.uk>  <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>
  <4A7053E8.8050303@mnementh.co.uk>  <20090729201702.GA28202@linux-sh.org>
 <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com>
 <4A716F1C.2050805@mnementh.co.uk> <Pine.LNX.4.64.0907301246330.4462@axis700.grange>
 <4A71F2A5.4060206@mnementh.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009, Ian Molton wrote:

> Guennadi Liakhovetski wrote:
> 
> > While you're at it, please, consider swapping the two lines in
> > tmio_mmc_probe():
> > 
> > -	tmio_mmc_clk_stop(host);
> > 	reset(host);
> > +	tmio_mmc_clk_stop(host);
> > 
> > Otherwise, I think, reset causes problems trying to access the controller
> > with disabled clock. At least this is needed on SuperH.
> 
> Interesting. I'll see what the result of this is on TMIO - This sequence was
> garnered from the WinCE driver for the chip.
> 
> I cant see _why_ this should be a problem, as this disables the card clock,
> not HCLK. Could you debug further in tmio_mmc_clk_stop() please and see if
> reordering only one of the two IO accesses cures this?

Not sure I understood the "reordering only one of the two IO accesses" 
correctly, but I swapped the two sd_ctrl_write16() calls in 
tmio_mmc_clk_stop() and no, it didn't cure the problem.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

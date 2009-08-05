Return-Path: <linux-kernel-owner+w=401wt.eu-S1752153AbZHETov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbZHETov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 15:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZHETou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 15:44:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:58467 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751398AbZHETou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 15:44:50 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX199SYFWhFt9RX0Sd2SkFwE698sFc7Im70TWlI7eLb
	KFYWLPuw8YHgbm
Date: Wed, 5 Aug 2009 21:44:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ian Molton <ian@mnementh.co.uk>
cc: Magnus Damm <magnus.damm@gmail.com>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
In-Reply-To: <4A798A4B.4000901@mnementh.co.uk>
Message-ID: <Pine.LNX.4.64.0908051702180.5802@axis700.grange>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange> 
 <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com> 
 <4A7053E8.8050303@mnementh.co.uk>  <20090729201702.GA28202@linux-sh.org> 
 <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com> 
 <4A716F1C.2050805@mnementh.co.uk>  <Pine.LNX.4.64.0907301246330.4462@axis700.grange>
  <4A71F2A5.4060206@mnementh.co.uk>  <aec7e5c30908021952j7947b513w7d62f2c4d87bd3c5@mail.gmail.com>
  <4A787C2C.5070000@mnementh.co.uk> <aec7e5c30908041908p568f413albef7dede3fd2cb83@mail.gmail.com>
 <4A798A4B.4000901@mnementh.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Aug 2009, Ian Molton wrote:

> Hi all,
> 
> Could all non-MFD users of tmio-mmc please ensure that the following is
> actually true on your hardware?
> 
>   mmc->f_max = pdata->hclk;
>   mmc->f_min = mmc->f_max / 512;

That's what I currently have in the driver, yes.

> According to all the data I have, the smallest divider setting of 0x100 is /2
> and only MFD controllers with the CNF area can select no-divider mode.
> 
> this would mean that non-MFD chips should be doing:
> 
>   mmc->f_max = pdata->hclk / 2;
>   mmc->f_min = pdata->hclk / 512;

How do we verify this? Do I need some "very fast" card, so that sd would 
try to drive the clock beyond pdata->hclk / 2, which should then fail? 
Currently I'm using 24MHz (copied from the original driver), and the only 
thing I know about the controller is its "Maximum operating frequency: 25 
MHz."

Thanks
Guennadi
---
Guennadi Liakhovetski

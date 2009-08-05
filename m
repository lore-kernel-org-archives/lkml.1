Return-Path: <linux-kernel-owner+w=401wt.eu-S934414AbZHENeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934414AbZHENeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934376AbZHENeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:34:17 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:49149 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934308AbZHENeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:34:14 -0400
Message-ID: <4A798A4B.4000901@mnementh.co.uk>
Date: Wed, 05 Aug 2009 14:34:03 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>	 <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>	 <4A7053E8.8050303@mnementh.co.uk>	 <20090729201702.GA28202@linux-sh.org>	 <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com>	 <4A716F1C.2050805@mnementh.co.uk>	 <Pine.LNX.4.64.0907301246330.4462@axis700.grange>	 <4A71F2A5.4060206@mnementh.co.uk>	 <aec7e5c30908021952j7947b513w7d62f2c4d87bd3c5@mail.gmail.com>	 <4A787C2C.5070000@mnementh.co.uk> <aec7e5c30908041908p568f413albef7dede3fd2cb83@mail.gmail.com>
In-Reply-To: <aec7e5c30908041908p568f413albef7dede3fd2cb83@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Could all non-MFD users of tmio-mmc please ensure that the following is 
actually true on your hardware?

   mmc->f_max = pdata->hclk;
   mmc->f_min = mmc->f_max / 512;

According to all the data I have, the smallest divider setting of 0x100 
is /2 and only MFD controllers with the CNF area can select no-divider mode.

this would mean that non-MFD chips should be doing:

   mmc->f_max = pdata->hclk / 2;
   mmc->f_min = pdata->hclk / 512;

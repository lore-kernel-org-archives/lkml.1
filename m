Return-Path: <linux-kernel-owner+w=401wt.eu-S934198AbZHEOCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198AbZHEOCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 10:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933568AbZHEOCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 10:02:42 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:38470 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933520AbZHEOCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 10:02:41 -0400
Message-ID: <4A7990F6.7030701@mnementh.co.uk>
Date: Wed, 05 Aug 2009 15:02:30 +0100
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
Subject: Example idea for how to solve the clock/cnf problem.
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>	 <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>	 <4A7053E8.8050303@mnementh.co.uk>	 <20090729201702.GA28202@linux-sh.org>	 <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com>	 <4A716F1C.2050805@mnementh.co.uk>	 <Pine.LNX.4.64.0907301246330.4462@axis700.grange>	 <4A71F2A5.4060206@mnementh.co.uk>	 <aec7e5c30908021952j7947b513w7d62f2c4d87bd3c5@mail.gmail.com>	 <4A787C2C.5070000@mnementh.co.uk> <aec7e5c30908041908p568f413albef7dede3fd2cb83@mail.gmail.com>
In-Reply-To: <aec7e5c30908041908p568f413albef7dede3fd2cb83@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I've spent a little time hacking on the code this afternoon, here is a 
WIP that completely removes cnf area accesses from the mmc driver. These 
are now pushed out into the platform / MFD level code. I've taken 
TC6393XB as an example and pushed the CNF code into that. I imagine that 
several chips can share that code so I will break it out into another 
file, mfd/tmio_common.c, probably.

This code probably doesnt compile yet, but should give some idea about 
how I think this should be done.

How are other devices setting the card clock? are they using my clock 
setup function? If so, then we are probably best off avoiding the clock 
API for the card clock, as getting the full range of frequencies require 
access to both CNF and CTL areas on TMIO MFDs.

If not, then we will need to do more thinking.

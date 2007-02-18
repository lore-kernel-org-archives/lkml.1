Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbXBRUIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbXBRUIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 15:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbXBRUIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 15:08:24 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:23164 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbXBRUIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 15:08:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=I9JKuUvXJc3EsdAXnUR8Dr2UKZ52t6/wQZpgnZ9M5OMbJ6JV/GKfKkLs916J8fHZyTamWJg7Ex9c8ELr4Vl9rf0TXE5Blz96TWlmnTDgvjBiFmafb1wbT2885HMgM41EqWe/BuzsKojjNpwV/JCyHOqv+WN/QoTkTMmK3NHdhqk=
Date: Sun, 18 Feb 2007 23:05:38 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Dan Aloni <da-x@monatomic.org>
Cc: Andi Kleen <ak@suse.de>, linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: e2b2rom_init_one():  Unable to register resource
Message-ID: <20070218200538.GA14729@cvg>
References: <20070217212918.GA26554@localdomain> <20070218104222.GC10865@cvg> <200702181813.38814.ak@suse.de> <20070218174934.GA19558@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070218174934.GA19558@localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 07:49:34PM +0200, Dan Aloni wrote:
| On Sun, Feb 18, 2007 at 06:13:38PM +0100, Andi Kleen wrote:
| > [adding mtd maintainer]
| > 
| > On Sunday 18 February 2007 11:42, Cyrill Gorcunov wrote:
| > > On Sat, Feb 17, 2007 at 11:29:19PM +0200, Dan Aloni wrote:
| > > | Hello,
| > > | 
| > > | I'm running the x86_64 arch of Linux 2.6.20 on a Supermicro X6DH8-XG2 
| > > | board and I got this during boot:
| > > | 
| > > | [248660.950695] device id = 2440
| > > | [248660.950699] device id = 2480
| > > | [248660.950703] device id = 24c0
| > > | [248660.950706] device id = 24d0
| > > | [248660.950709] matched device = 24d0
| > > | [248660.950712] matched device id 24d0
| > > | [248660.950716] pci_read_config_byte : 4
| > > | [248660.950723] esb2rom: esb2rom_init_one(): Unable to register resource 
| > > | 0xffffffffffc00000-0xffffffff - kernel bug?
| > > | [248660.950729] esb2rom: ioremap(ffffffffffc00000, 100400000) failed
| > > | [248660.956859] retVal = -19
| > > | 
| > > | Looks like some kind of a 64-bit portability bug...
| [...]
| > 
| > Making window->phys u32 seems like a cleaner fix.
| > (untested) 
| 
| With this fix it still looks somewhat broken:
| 
| [889227.698252] device id = 2440
| [889227.698261] device id = 2480
| [889227.698264] device id = 24c0
| [889227.698268] device id = 24d0
| [889227.698271] matched device = 24d0
| [889227.698274] matched device id 24d0
| [889227.698280] pci_read_config_byte : 4
| [889227.698289] esb2rom: esb2rom_init_one(): Unable to register resource 0xffc00000-0xffffffff - kernel bug?
| [889227.700676] CFI: Found no esb2rom @ffc00000 device at location zero
| [889227.717995] JEDEC: Found no esb2rom @ffc00000 device at location zero
| [889227.720811] CFI: Found no esb2rom @ffc00000 device at location zero
| [889227.747009] JEDEC: Found no esb2rom @ffc00000 device at location zero
| [889227.748692] CFI: Found no esb2rom @ffc00000 device at location zero
| [889227.763736] JEDEC: Found no esb2rom @ffc00000 device at location zero
| [889227.765438] CFI: Found no esb2rom @ffc10000 device at location zero
| [889227.782755] JEDEC: Found no esb2rom @ffc10000 device at location zero
| [889227.785566] CFI: Found no esb2rom @ffc10000 device at location zero
| [889227.810647] JEDEC: Found no esb2rom @ffc10000 device at location zero
| [889227.812330] CFI: Found no esb2rom @ffc10000 device at location zero
| [889227.827378] JEDEC: Found no esb2rom @ffc10000 device at location zero
| [889227.829081] CFI: Found no esb2rom @ffc20000 device at location zero
| [889227.846390] JEDEC: Found no esb2rom @ffc20000 device at location zero
| [889227.849202] CFI: Found no esb2rom @ffc20000 device at location zero
| [889227.874279] JEDEC: Found no esb2rom @ffc20000 device at location zero
| [889227.875961] CFI: Found no esb2rom @ffc20000 device at location zero
| [889227.891005] JEDEC: Found no esb2rom @ffc20000 device at location zero
| [889227.892710] CFI: Found no esb2rom @ffc30000 device at location zero
| [889227.910022] JEDEC: Found no esb2rom @ffc30000 device at location zero
| [889227.912835] CFI: Found no esb2rom @ffc30000 device at location zero
| [889227.937915] JEDEC: Found no esb2rom @ffc30000 device at location zero
| [889227.939594] CFI: Found no esb2rom @ffc30000 device at location zero
| [889227.954636] JEDEC: Found no esb2rom @ffc30000 device at location zero
| [889227.956339] CFI: Found no esb2rom @ffc40000 device at location zero
| [889227.973647] JEDEC: Found no esb2rom @ffc40000 device at location zero
| [889227.976461] CFI: Found no esb2rom @ffc40000 device at location zero
| [889228.001560] JEDEC: Found no esb2rom @ffc40000 device at location zero
| [889228.003243] CFI: Found no esb2rom @ffc40000 device at location zero
| [889228.018296] JEDEC: Found no esb2rom @ffc40000 device at location zero
| [889228.020000] CFI: Found no esb2rom @ffc50000 device at location zero
| [889228.037315] JEDEC: Found no esb2rom @ffc50000 device at location zero
| [889228.040129] CFI: Found no esb2rom @ffc50000 device at location zero
| [889228.065218] JEDEC: Found no esb2rom @ffc50000 device at location zero
| [889228.066899] CFI: Found no esb2rom @ffc50000 device at location zero
| [889228.081943] JEDEC: Found no esb2rom @ffc50000 device at location zero
| [889228.083640] CFI: Found no esb2rom @ffc60000 device at location zero
| [889228.100949] JEDEC: Found no esb2rom @ffc60000 device at location zero
| [889228.103760] CFI: Found no esb2rom @ffc60000 device at location zero
| [889228.128850] JEDEC: Found no esb2rom @ffc60000 device at location zero
| [889228.130529] CFI: Found no esb2rom @ffc60000 device at location zero
| [889228.145575] JEDEC: Found no esb2rom @ffc60000 device at location zero
| [889228.147275] CFI: Found no esb2rom @ffc70000 device at location zero
| [889228.164593] JEDEC: Found no esb2rom @ffc70000 device at location zero
| [889228.167398] CFI: Found no esb2rom @ffc70000 device at location zero
| [889228.192491] JEDEC: Found no esb2rom @ffc70000 device at location zero
| [889228.194173] CFI: Found no esb2rom @ffc70000 device at location zero
| [889228.209767] JEDEC: Found no esb2rom @ffc70000 device at location zero
| [889228.211466] CFI: Found no esb2rom @ffc80000 device at location zero
| [889228.228785] JEDEC: Found no esb2rom @ffc80000 device at location zero
| [889228.231594] CFI: Found no esb2rom @ffc80000 device at location zero
| [889228.256685] JEDEC: Found no esb2rom @ffc80000 device at location zero
| [889228.258367] CFI: Found no esb2rom @ffc80000 device at location zero
| [889228.273415] JEDEC: Found no esb2rom @ffc80000 device at location zero
| [889228.275114] CFI: Found no esb2rom @ffc90000 device at location zero
| [889228.292426] JEDEC: Found no esb2rom @ffc90000 device at location zero
| [889228.295235] CFI: Found no esb2rom @ffc90000 device at location zero
| [889228.320331] JEDEC: Found no esb2rom @ffc90000 device at location zero
| [889228.322012] CFI: Found no esb2rom @ffc90000 device at location zero
| [889228.337055] JEDEC: Found no esb2rom @ffc90000 device at location zero
| [889228.338756] CFI: Found no esb2rom @ffca0000 device at location zero
| [889228.356072] JEDEC: Found no esb2rom @ffca0000 device at location zero
| [889228.358878] CFI: Found no esb2rom @ffca0000 device at location zero
| [889228.383986] JEDEC: Found no esb2rom @ffca0000 device at location zero
| [889228.385666] CFI: Found no esb2rom @ffca0000 device at location zero
| [889228.400715] JEDEC: Found no esb2rom @ffca0000 device at location zero
| [889228.402417] CFI: Found no esb2rom @ffcb0000 device at location zero
| [889228.419737] JEDEC: Found no esb2rom @ffcb0000 device at location zero
| [889228.422545] CFI: Found no esb2rom @ffcb0000 device at location zero
| [889228.447651] JEDEC: Found no esb2rom @ffcb0000 device at location zero
| [889228.449331] CFI: Found no esb2rom @ffcb0000 device at location zero
| [889228.464373] JEDEC: Found no esb2rom @ffcb0000 device at location zero
| [889228.466075] CFI: Found no esb2rom @ffcc0000 device at location zero
| [889228.483393] JEDEC: Found no esb2rom @ffcc0000 device at location zero
| [889228.486199] CFI: Found no esb2rom @ffcc0000 device at location zero
| [889228.511283] JEDEC: Found no esb2rom @ffcc0000 device at location zero
| [889228.512965] CFI: Found no esb2rom @ffcc0000 device at location zero
| [889228.528019] JEDEC: Found no esb2rom @ffcc0000 device at location zero
| [889228.529718] CFI: Found no esb2rom @ffcd0000 device at location zero
| [889228.547029] JEDEC: Found no esb2rom @ffcd0000 device at location zero
| [889228.549838] CFI: Found no esb2rom @ffcd0000 device at location zero
| [889228.574943] JEDEC: Found no esb2rom @ffcd0000 device at location zero
| [889228.576623] CFI: Found no esb2rom @ffcd0000 device at location zero
| [889228.591668] JEDEC: Found no esb2rom @ffcd0000 device at location zero
| [889228.593369] CFI: Found no esb2rom @ffce0000 device at location zero
| [889228.610689] JEDEC: Found no esb2rom @ffce0000 device at location zero
| [889228.613500] CFI: Found no esb2rom @ffce0000 device at location zero
| [889228.638601] JEDEC: Found no esb2rom @ffce0000 device at location zero
| [889228.640287] CFI: Found no esb2rom @ffce0000 device at location zero
| [889228.655327] JEDEC: Found no esb2rom @ffce0000 device at location zero
| [889228.657027] CFI: Found no esb2rom @ffcf0000 device at location zero
| [889228.674335] JEDEC: Found no esb2rom @ffcf0000 device at location zero
| [889228.677148] CFI: Found no esb2rom @ffcf0000 device at location zero
| [889228.702239] JEDEC: Found no esb2rom @ffcf0000 device at location zero
| [889228.703924] CFI: Found no esb2rom @ffcf0000 device at location zero
| [889228.718974] JEDEC: Found no esb2rom @ffcf0000 device at location zero
| [889228.720675] CFI: Found no esb2rom @ffd00000 device at location zero
| [889228.737986] JEDEC: Found no esb2rom @ffd00000 device at location zero
| [889228.740798] CFI: Found no esb2rom @ffd00000 device at location zero
| [889228.765906] JEDEC: Found no esb2rom @ffd00000 device at location zero
| [889228.767591] CFI: Found no esb2rom @ffd00000 device at location zero
| [889228.782636] JEDEC: Found no esb2rom @ffd00000 device at location zero
| [889228.784334] CFI: Found no esb2rom @ffd10000 device at location zero
| [889228.801640] JEDEC: Found no esb2rom @ffd10000 device at location zero
| [889228.804453] CFI: Found no esb2rom @ffd10000 device at location zero
| [889228.829556] JEDEC: Found no esb2rom @ffd10000 device at location zero
| [889228.831244] CFI: Found no esb2rom @ffd10000 device at location zero
| [889228.846286] JEDEC: Found no esb2rom @ffd10000 device at location zero
| [889228.847989] CFI: Found no esb2rom @ffd20000 device at location zero
| [889228.865297] JEDEC: Found no esb2rom @ffd20000 device at location zero
| [889228.868109] CFI: Found no esb2rom @ffd20000 device at location zero
| [889228.893202] JEDEC: Found no esb2rom @ffd20000 device at location zero
| [889228.894886] CFI: Found no esb2rom @ffd20000 device at location zero
| [889228.909912] JEDEC: Found no esb2rom @ffd20000 device at location zero
| [889228.911612] CFI: Found no esb2rom @ffd30000 device at location zero
| [889228.928922] JEDEC: Found no esb2rom @ffd30000 device at location zero
| [889228.931734] CFI: Found no esb2rom @ffd30000 device at location zero
| [889228.956823] JEDEC: Found no esb2rom @ffd30000 device at location zero
| [889228.958510] CFI: Found no esb2rom @ffd30000 device at location zero
| [889228.973549] JEDEC: Found no esb2rom @ffd30000 device at location zero
| [889228.975254] CFI: Found no esb2rom @ffd40000 device at location zero
| [889228.992573] JEDEC: Found no esb2rom @ffd40000 device at location zero
| [889228.995384] CFI: Found no esb2rom @ffd40000 device at location zero
| [889229.020477] JEDEC: Found no esb2rom @ffd40000 device at location zero
| [889229.022162] CFI: Found no esb2rom @ffd40000 device at location zero
| [889229.037198] JEDEC: Found no esb2rom @ffd40000 device at location zero
| [889229.038904] CFI: Found no esb2rom @ffd50000 device at location zero
| [889229.056217] JEDEC: Found no esb2rom @ffd50000 device at location zero
| [889229.059029] CFI: Found no esb2rom @ffd50000 device at location zero
| [889229.084119] JEDEC: Found no esb2rom @ffd50000 device at location zero
| [889229.085797] CFI: Found no esb2rom @ffd50000 device at location zero
| [889229.100840] JEDEC: Found no esb2rom @ffd50000 device at location zero
| [889229.102541] CFI: Found no esb2rom @ffd60000 device at location zero
| [889229.119855] JEDEC: Found no esb2rom @ffd60000 device at location zero
| [889229.122668] CFI: Found no esb2rom @ffd60000 device at location zero
| [889229.147756] JEDEC: Found no esb2rom @ffd60000 device at location zero
| [889229.149438] CFI: Found no esb2rom @ffd60000 device at location zero
| [889229.165586] JEDEC: Found no esb2rom @ffd60000 device at location zero
| [889229.167293] CFI: Found no esb2rom @ffd70000 device at location zero
| [889229.184607] JEDEC: Found no esb2rom @ffd70000 device at location zero
| [889229.187417] CFI: Found no esb2rom @ffd70000 device at location zero
| [889229.212504] JEDEC: Found no esb2rom @ffd70000 device at location zero
| [889229.214188] CFI: Found no esb2rom @ffd70000 device at location zero
| [889229.229226] JEDEC: Found no esb2rom @ffd70000 device at location zero
| [889229.230927] CFI: Found no esb2rom @ffd80000 device at location zero
| [889229.248242] JEDEC: Found no esb2rom @ffd80000 device at location zero
| [889229.251051] CFI: Found no esb2rom @ffd80000 device at location zero
| [889229.276154] JEDEC: Found no esb2rom @ffd80000 device at location zero
| [889229.277839] CFI: Found no esb2rom @ffd80000 device at location zero
| [889229.292882] JEDEC: Found no esb2rom @ffd80000 device at location zero
| [889229.294586] CFI: Found no esb2rom @ffd90000 device at location zero
| [889229.311893] JEDEC: Found no esb2rom @ffd90000 device at location zero
| [889229.314701] CFI: Found no esb2rom @ffd90000 device at location zero
| [889229.339791] JEDEC: Found no esb2rom @ffd90000 device at location zero
| [889229.341473] CFI: Found no esb2rom @ffd90000 device at location zero
| [889229.356523] JEDEC: Found no esb2rom @ffd90000 device at location zero
| [889229.358229] CFI: Found no esb2rom @ffda0000 device at location zero
| [889229.375546] JEDEC: Found no esb2rom @ffda0000 device at location zero
| [889229.378356] CFI: Found no esb2rom @ffda0000 device at location zero
| [889229.403448] JEDEC: Found no esb2rom @ffda0000 device at location zero
| [889229.405129] CFI: Found no esb2rom @ffda0000 device at location zero
| [889229.420172] JEDEC: Found no esb2rom @ffda0000 device at location zero
| [889229.421878] CFI: Found no esb2rom @ffdb0000 device at location zero
| [889229.439178] JEDEC: Found no esb2rom @ffdb0000 device at location zero
| [889229.441990] CFI: Found no esb2rom @ffdb0000 device at location zero
| [889229.467086] JEDEC: Found no esb2rom @ffdb0000 device at location zero
| [889229.468770] CFI: Found no esb2rom @ffdb0000 device at location zero
| [889229.483825] JEDEC: Found no esb2rom @ffdb0000 device at location zero
| [889229.485528] CFI: Found no esb2rom @ffdc0000 device at location zero
| [889229.502849] JEDEC: Found no esb2rom @ffdc0000 device at location zero
| [889229.505665] CFI: Found no esb2rom @ffdc0000 device at location zero
| [889229.530759] JEDEC: Found no esb2rom @ffdc0000 device at location zero
| [889229.532442] CFI: Found no esb2rom @ffdc0000 device at location zero
| [889229.547492] JEDEC: Found no esb2rom @ffdc0000 device at location zero
| [889229.549198] CFI: Found no esb2rom @ffdd0000 device at location zero
| [889229.566505] JEDEC: Found no esb2rom @ffdd0000 device at location zero
| [889229.569316] CFI: Found no esb2rom @ffdd0000 device at location zero
| [889229.594402] JEDEC: Found no esb2rom @ffdd0000 device at location zero
| [889229.596080] CFI: Found no esb2rom @ffdd0000 device at location zero
| [889229.611111] JEDEC: Found no esb2rom @ffdd0000 device at location zero
| [889229.612813] CFI: Found no esb2rom @ffde0000 device at location zero
| [889229.630116] JEDEC: Found no esb2rom @ffde0000 device at location zero
| [889229.632928] CFI: Found no esb2rom @ffde0000 device at location zero
| [889229.658014] JEDEC: Found no esb2rom @ffde0000 device at location zero
| [889229.659695] CFI: Found no esb2rom @ffde0000 device at location zero
| [889229.674735] JEDEC: Found no esb2rom @ffde0000 device at location zero
| [889229.676437] CFI: Found no esb2rom @ffdf0000 device at location zero
| [889229.693755] JEDEC: Found no esb2rom @ffdf0000 device at location zero
| [889229.696565] CFI: Found no esb2rom @ffdf0000 device at location zero
| [889229.721659] JEDEC: Found no esb2rom @ffdf0000 device at location zero
| [889229.723340] CFI: Found no esb2rom @ffdf0000 device at location zero
| [889229.738382] JEDEC: Found no esb2rom @ffdf0000 device at location zero
| [889229.740082] CFI: Found no esb2rom @ffe00000 device at location zero
| [889229.757392] JEDEC: Found no esb2rom @ffe00000 device at location zero
| [889229.760200] CFI: Found no esb2rom @ffe00000 device at location zero
| [889229.785301] JEDEC: Found no esb2rom @ffe00000 device at location zero
| [889229.786983] CFI: Found no esb2rom @ffe00000 device at location zero
| [889229.802033] JEDEC: Found no esb2rom @ffe00000 device at location zero
| [889229.803730] CFI: Found no esb2rom @ffe10000 device at location zero
| [889229.821039] JEDEC: Found no esb2rom @ffe10000 device at location zero
| [889229.823845] CFI: Found no esb2rom @ffe10000 device at location zero
| [889229.849493] JEDEC: Found no esb2rom @ffe10000 device at location zero
| [889229.851175] CFI: Found no esb2rom @ffe10000 device at location zero
| [889229.866220] JEDEC: Found no esb2rom @ffe10000 device at location zero
| [889229.867920] CFI: Found no esb2rom @ffe20000 device at location zero
| [889229.885238] JEDEC: Found no esb2rom @ffe20000 device at location zero
| [889229.888045] CFI: Found no esb2rom @ffe20000 device at location zero
| [889229.913141] JEDEC: Found no esb2rom @ffe20000 device at location zero
| [889229.914822] CFI: Found no esb2rom @ffe20000 device at location zero
| [889229.929867] JEDEC: Found no esb2rom @ffe20000 device at location zero
| [889229.931563] CFI: Found no esb2rom @ffe30000 device at location zero
| [889229.948871] JEDEC: Found no esb2rom @ffe30000 device at location zero
| [889229.951679] CFI: Found no esb2rom @ffe30000 device at location zero
| [889229.976767] JEDEC: Found no esb2rom @ffe30000 device at location zero
| [889229.978449] CFI: Found no esb2rom @ffe30000 device at location zero
| [889229.993495] JEDEC: Found no esb2rom @ffe30000 device at location zero
| [889229.995196] CFI: Found no esb2rom @ffe40000 device at location zero
| [889230.012511] JEDEC: Found no esb2rom @ffe40000 device at location zero
| [889230.015322] CFI: Found no esb2rom @ffe40000 device at location zero
| [889230.040401] JEDEC: Found no esb2rom @ffe40000 device at location zero
| [889230.042083] CFI: Found no esb2rom @ffe40000 device at location zero
| [889230.057129] JEDEC: Found no esb2rom @ffe40000 device at location zero
| [889230.058827] CFI: Found no esb2rom @ffe50000 device at location zero
| [889230.076143] JEDEC: Found no esb2rom @ffe50000 device at location zero
| [889230.078955] CFI: Found no esb2rom @ffe50000 device at location zero
| [889230.104049] JEDEC: Found no esb2rom @ffe50000 device at location zero
| [889230.105731] CFI: Found no esb2rom @ffe50000 device at location zero
| [889230.120768] JEDEC: Found no esb2rom @ffe50000 device at location zero
| [889230.122467] CFI: Found no esb2rom @ffe60000 device at location zero
| [889230.139790] JEDEC: Found no esb2rom @ffe60000 device at location zero
| [889230.142602] CFI: Found no esb2rom @ffe60000 device at location zero
| [889230.167711] JEDEC: Found no esb2rom @ffe60000 device at location zero
| [889230.169396] CFI: Found no esb2rom @ffe60000 device at location zero
| [889230.184434] JEDEC: Found no esb2rom @ffe60000 device at location zero
| [889230.186133] CFI: Found no esb2rom @ffe70000 device at location zero
| [889230.203455] JEDEC: Found no esb2rom @ffe70000 device at location zero
| [889230.206268] CFI: Found no esb2rom @ffe70000 device at location zero
| [889230.231361] JEDEC: Found no esb2rom @ffe70000 device at location zero
| [889230.233043] CFI: Found no esb2rom @ffe70000 device at location zero
| [889230.248076] JEDEC: Found no esb2rom @ffe70000 device at location zero
| [889230.249774] CFI: Found no esb2rom @ffe80000 device at location zero
| [889230.267086] JEDEC: Found no esb2rom @ffe80000 device at location zero
| [889230.269897] CFI: Found no esb2rom @ffe80000 device at location zero
| [889230.295544] JEDEC: Found no esb2rom @ffe80000 device at location zero
| [889230.297226] CFI: Found no esb2rom @ffe80000 device at location zero
| [889230.312265] JEDEC: Found no esb2rom @ffe80000 device at location zero
| [889230.313963] CFI: Found no esb2rom @ffe90000 device at location zero
| [889230.331846] JEDEC: Found no esb2rom @ffe90000 device at location zero
| [889230.334654] CFI: Found no esb2rom @ffe90000 device at location zero
| [889230.359755] JEDEC: Found no esb2rom @ffe90000 device at location zero
| [889230.361435] CFI: Found no esb2rom @ffe90000 device at location zero
| [889230.376477] JEDEC: Found no esb2rom @ffe90000 device at location zero
| [889230.378174] CFI: Found no esb2rom @ffea0000 device at location zero
| [889230.395478] JEDEC: Found no esb2rom @ffea0000 device at location zero
| [889230.398290] CFI: Found no esb2rom @ffea0000 device at location zero
| [889230.423384] JEDEC: Found no esb2rom @ffea0000 device at location zero
| [889230.425067] CFI: Found no esb2rom @ffea0000 device at location zero
| [889230.440118] JEDEC: Found no esb2rom @ffea0000 device at location zero
| [889230.441814] CFI: Found no esb2rom @ffeb0000 device at location zero
| [889230.460224] JEDEC: Found no esb2rom @ffeb0000 device at location zero
| [889230.463031] CFI: Found no esb2rom @ffeb0000 device at location zero
| [889230.488675] JEDEC: Found no esb2rom @ffeb0000 device at location zero
| [889230.490355] CFI: Found no esb2rom @ffeb0000 device at location zero
| [889230.505403] JEDEC: Found no esb2rom @ffeb0000 device at location zero
| [889230.507104] CFI: Found no esb2rom @ffec0000 device at location zero
| [889230.524980] JEDEC: Found no esb2rom @ffec0000 device at location zero
| [889230.527792] CFI: Found no esb2rom @ffec0000 device at location zero
| [889230.553440] JEDEC: Found no esb2rom @ffec0000 device at location zero
| [889230.555121] CFI: Found no esb2rom @ffec0000 device at location zero
| [889230.570155] JEDEC: Found no esb2rom @ffec0000 device at location zero
| [889230.571858] CFI: Found no esb2rom @ffed0000 device at location zero
| [889230.590277] JEDEC: Found no esb2rom @ffed0000 device at location zero
| [889230.593090] CFI: Found no esb2rom @ffed0000 device at location zero
| [889230.618178] JEDEC: Found no esb2rom @ffed0000 device at location zero
| [889230.619864] CFI: Found no esb2rom @ffed0000 device at location zero
| [889230.634914] JEDEC: Found no esb2rom @ffed0000 device at location zero
| [889230.636618] CFI: Found no esb2rom @ffee0000 device at location zero
| [889230.654477] JEDEC: Found no esb2rom @ffee0000 device at location zero
| [889230.657286] CFI: Found no esb2rom @ffee0000 device at location zero
| [889230.682374] JEDEC: Found no esb2rom @ffee0000 device at location zero
| [889230.684058] CFI: Found no esb2rom @ffee0000 device at location zero
| [889230.699111] JEDEC: Found no esb2rom @ffee0000 device at location zero
| [889230.700811] CFI: Found no esb2rom @ffef0000 device at location zero
| [889230.717568] JEDEC: Found no esb2rom @ffef0000 device at location zero
| [889230.720384] CFI: Found no esb2rom @ffef0000 device at location zero
| [889230.745470] JEDEC: Found no esb2rom @ffef0000 device at location zero
| [889230.747158] CFI: Found no esb2rom @ffef0000 device at location zero
| [889230.762197] JEDEC: Found no esb2rom @ffef0000 device at location zero
| [889230.763896] CFI: Found no esb2rom @fff00000 device at location zero
| [889230.781193] JEDEC: Found no esb2rom @fff00000 device at location zero
| [889230.784002] CFI: Found no esb2rom @fff00000 device at location zero
| [889230.809637] JEDEC: Found no esb2rom @fff00000 device at location zero
| [889230.811320] CFI: Found no esb2rom @fff00000 device at location zero
| [889230.826899] JEDEC: Found no esb2rom @fff00000 device at location zero
| [889230.828597] CFI: Found no esb2rom @fff10000 device at location zero
| [889230.845352] JEDEC: Found no esb2rom @fff10000 device at location zero
| [889230.848163] CFI: Found no esb2rom @fff10000 device at location zero
| [889230.873244] JEDEC: Found no esb2rom @fff10000 device at location zero
| [889230.874930] CFI: Found no esb2rom @fff10000 device at location zero
| [889230.889958] JEDEC: Found no esb2rom @fff10000 device at location zero
| [889230.891660] CFI: Found no esb2rom @fff20000 device at location zero
| [889230.908958] JEDEC: Found no esb2rom @fff20000 device at location zero
| [889230.911769] CFI: Found no esb2rom @fff20000 device at location zero
| [889230.936857] JEDEC: Found no esb2rom @fff20000 device at location zero
| [889230.938540] CFI: Found no esb2rom @fff20000 device at location zero
| [889230.953573] JEDEC: Found no esb2rom @fff20000 device at location zero
| [889230.955273] CFI: Found no esb2rom @fff30000 device at location zero
| [889230.973119] JEDEC: Found no esb2rom @fff30000 device at location zero
| [889230.975930] CFI: Found no esb2rom @fff30000 device at location zero
| [889231.001567] JEDEC: Found no esb2rom @fff30000 device at location zero
| [889231.003252] CFI: Found no esb2rom @fff30000 device at location zero
| [889231.018845] JEDEC: Found no esb2rom @fff30000 device at location zero
| [889231.020542] CFI: Found no esb2rom @fff40000 device at location zero
| [889231.038952] JEDEC: Found no esb2rom @fff40000 device at location zero
| [889231.041760] CFI: Found no esb2rom @fff40000 device at location zero
| [889231.066846] JEDEC: Found no esb2rom @fff40000 device at location zero
| [889231.068524] CFI: Found no esb2rom @fff40000 device at location zero
| [889231.083557] JEDEC: Found no esb2rom @fff40000 device at location zero
| [889231.085250] CFI: Found no esb2rom @fff50000 device at location zero
| [889231.103099] JEDEC: Found no esb2rom @fff50000 device at location zero
| [889231.105905] CFI: Found no esb2rom @fff50000 device at location zero
| [889231.131545] JEDEC: Found no esb2rom @fff50000 device at location zero
| [889231.133226] CFI: Found no esb2rom @fff50000 device at location zero
| [889231.148256] JEDEC: Found no esb2rom @fff50000 device at location zero
| [889231.149955] CFI: Found no esb2rom @fff60000 device at location zero
| [889231.167801] JEDEC: Found no esb2rom @fff60000 device at location zero
| [889231.170613] CFI: Found no esb2rom @fff60000 device at location zero
| [889231.195685] JEDEC: Found no esb2rom @fff60000 device at location zero
| [889231.197366] CFI: Found no esb2rom @fff60000 device at location zero
| [889231.212402] JEDEC: Found no esb2rom @fff60000 device at location zero
| [889231.214101] CFI: Found no esb2rom @fff70000 device at location zero
| [889231.231408] JEDEC: Found no esb2rom @fff70000 device at location zero
| [889231.234217] CFI: Found no esb2rom @fff70000 device at location zero
| [889231.259307] JEDEC: Found no esb2rom @fff70000 device at location zero
| [889231.260989] CFI: Found no esb2rom @fff70000 device at location zero
| [889231.276030] JEDEC: Found no esb2rom @fff70000 device at location zero
| [889231.277726] CFI: Found no esb2rom @fff80000 device at location zero
| [889231.295024] JEDEC: Found no esb2rom @fff80000 device at location zero
| [889231.297832] CFI: Found no esb2rom @fff80000 device at location zero
| [889231.323477] JEDEC: Found no esb2rom @fff80000 device at location zero
| [889231.325154] CFI: Found no esb2rom @fff80000 device at location zero
| [889231.340190] JEDEC: Found no esb2rom @fff80000 device at location zero
| [889231.341891] CFI: Found no esb2rom @fff90000 device at location zero
| [889231.359744] JEDEC: Found no esb2rom @fff90000 device at location zero
| [889231.362556] CFI: Found no esb2rom @fff90000 device at location zero
| [889231.387656] JEDEC: Found no esb2rom @fff90000 device at location zero
| [889231.389336] CFI: Found no esb2rom @fff90000 device at location zero
| [889231.404362] JEDEC: Found no esb2rom @fff90000 device at location zero
| [889231.406060] CFI: Found no esb2rom @fffa0000 device at location zero
| [889231.423359] JEDEC: Found no esb2rom @fffa0000 device at location zero
| [889231.426170] CFI: Found no esb2rom @fffa0000 device at location zero
| [889231.451814] JEDEC: Found no esb2rom @fffa0000 device at location zero
| [889231.453495] CFI: Found no esb2rom @fffa0000 device at location zero
| [889231.468518] JEDEC: Found no esb2rom @fffa0000 device at location zero
| [889231.470218] CFI: Found no esb2rom @fffb0000 device at location zero
| [889231.487517] JEDEC: Found no esb2rom @fffb0000 device at location zero
| [889231.490324] CFI: Found no esb2rom @fffb0000 device at location zero
| [889231.515403] JEDEC: Found no esb2rom @fffb0000 device at location zero
| [889231.517082] CFI: Found no esb2rom @fffb0000 device at location zero
| [889231.532110] JEDEC: Found no esb2rom @fffb0000 device at location zero
| [889231.533807] CFI: Found no esb2rom @fffc0000 device at location zero
| [889231.551665] JEDEC: Found no esb2rom @fffc0000 device at location zero
| [889231.554475] CFI: Found no esb2rom @fffc0000 device at location zero
| [889231.579549] JEDEC: Found no esb2rom @fffc0000 device at location zero
| [889231.581234] CFI: Found no esb2rom @fffc0000 device at location zero
| [889231.596272] JEDEC: Found no esb2rom @fffc0000 device at location zero
| [889231.597972] CFI: Found no esb2rom @fffd0000 device at location zero
| [889231.615273] JEDEC: Found no esb2rom @fffd0000 device at location zero
| [889231.618085] CFI: Found no esb2rom @fffd0000 device at location zero
| [889231.643158] JEDEC: Found no esb2rom @fffd0000 device at location zero
| [889231.644840] CFI: Found no esb2rom @fffd0000 device at location zero
| [889231.659868] JEDEC: Found no esb2rom @fffd0000 device at location zero
| [889231.661566] CFI: Found no esb2rom @fffe0000 device at location zero
| [889231.677756] JEDEC: Found no esb2rom @fffe0000 device at location zero
| [889231.680560] CFI: Found no esb2rom @fffe0000 device at location zero
| [889231.704527] JEDEC: Found no esb2rom @fffe0000 device at location zero
| [889231.706211] CFI: Found no esb2rom @fffe0000 device at location zero
| [889231.721794] JEDEC: Found no esb2rom @fffe0000 device at location zero
| [889231.723490] CFI: Found no esb2rom @ffff0000 device at location zero
| [889231.737445] JEDEC: Found no esb2rom @ffff0000 device at location zero
| [889231.740253] CFI: Found no esb2rom @ffff0000 device at location zero
| [889231.761992] JEDEC: Found no esb2rom @ffff0000 device at location zero
| [889231.763671] CFI: Found no esb2rom @ffff0000 device at location zero
| [889231.777595] JEDEC: Found no esb2rom @ffff0000 device at location zero
| [889231.777676] retVal = -19
| 
| The e820 map:
| 
| [    0.000000] BIOS-provided physical RAM map:
| [    0.000000]  BIOS-e820: 0000000000000000 - 0000000000096300 (usable)
| [    0.000000]  BIOS-e820: 000000000009b800 - 00000000000a0000 (reserved)
| [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff70000 (usable)
| [    0.000000]  BIOS-e820: 00000000cff70000 - 00000000cff78000 (ACPI data)
| [    0.000000]  BIOS-e820: 00000000cff78000 - 00000000cff80000 (ACPI NVS)
| [    0.000000]  BIOS-e820: 00000000cff80000 - 00000000d0000000 (reserved)
| [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
| [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
| [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
| [    0.000000]  BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
| [    0.000000]  BIOS-e820: 00000000fffffc00 - 0000000100000000 (reserved)
| [    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
| 
| -- 
| Dan Aloni
| XIV LTD, http://www.xivstorage.com
| da-x (at) monatomic.org, dan (at) xiv.co.il
| 

Dan, it seems you have 8MB flash installed so
you may try to forced setup of window->phys from 0 to

	window->phys = 0xff400000;

(with u32 of course)

		Cyrill


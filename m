Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZEVJjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZEVJjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbZEVJjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:39:35 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:40603 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbZEVJjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:39:32 -0400
Date: Fri, 22 May 2009 10:39:31 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090522093930.GA15375@sucs.org>
References: <20090310004344.GA23466@hash.localnet> <20090312061047.GA13401@silver.sucs.org> <20090313095213.GA14250@silver.sucs.org> <20090320131437.GA30120@hash.localnet> <20090329142432.GA15578@sucs.org> <20090329151401.GA26510@hash.localnet> <20090331083041.GA19657@sucs.org> <20090513214416.GA4492@sucs.org> <20090515040904.GA32357@hash.localnet> <20090518100540.GB21150@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518100540.GB21150@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 11:05:40AM +0100, Sitsofe Wheeler wrote:
> On Fri, May 15, 2009 at 12:09:04AM -0400, Bob Copeland wrote:
> > 
> > This is too ugly to live, but I'd like to know if you can reproduce
> > with this patch.  If it still happens, then I guess it's back to

The poison message has not reappeared but this morning there was a
sudden break in the connection. Only toggling the wifi via rfkill
brought things back to life. dmesg below:

[   30.490064] CPA self-test:
[   30.490262]  4k 4094 large 218 gb 0 x 4312[c0000000-f77fd000] miss 0
[   30.519860]  4k 189438 large 37 gb 0 x 189475[c0000000-f77fd000] miss 0
[   30.541985]  4k 189438 large 37 gb 0 x 189475[c0000000-f77fd000] miss 0
[   30.541991] ok.
[   71.438535] wlan0: authenticate with AP 00:01:38:d6:0b:4f
[   71.442153] wlan0: authenticated
[   71.442162] wlan0: associate with AP 00:01:38:d6:0b:4f
[   71.445143] wlan0: RX AssocResp from 00:01:38:d6:0b:4f (capab=0x431 status=0 aid=2)
[   71.445152] wlan0: associated
[ 5771.345217] ath5k phy0: noise floor calibration timeout (2412MHz)
[ 5774.632085] wlan0: no probe response from AP 00:01:38:d6:0b:4f - disassociating
[ 5774.869703] ath5k phy0: failed to wakeup the MAC Chip
[ 5774.869717] ath5k phy0: can't reset hardware (-5)
[ 5774.909190] ath5k phy0: failed to wakeup the MAC Chip
[ 5774.909197] ath5k phy0: can't reset hardware (-5)
[ 5774.952588] ath5k phy0: failed to wakeup the MAC Chip
[ 5774.952600] ath5k phy0: can't reset hardware (-5)
[ 5774.993967] ath5k phy0: failed to wakeup the MAC Chip
[ 5774.993977] ath5k phy0: can't reset hardware (-5)
[ 5775.035221] ath5k phy0: failed to wakeup the MAC Chip
[ 5777.075531] __ratelimit: 13 callbacks suppressed
[ 5777.075539] ath5k phy0: failed to wakeup the MAC Chip
[ 5777.075549] ath5k phy0: can't reset hardware (-5)
[ 5777.163583] ath5k phy0: failed to wakeup the MAC Chip
[ 5777.163598] ath5k phy0: can't reset hardware (-5)
[ 5777.232966] ath5k phy0: failed to wakeup the MAC Chip
[ 5777.232981] ath5k phy0: can't reset hardware (-5)
[ 5777.311548] ath5k phy0: failed to wakeup the MAC Chip
[ 5777.311562] ath5k phy0: can't reset hardware (-5)
[ 5777.373636] ath5k phy0: failed to wakeup the MAC Chip
[ 5777.373649] ath5k phy0: can't reset hardware (-5)
[ 5782.348301] __ratelimit: 12 callbacks suppressed
[ 5782.348312] ath5k phy0: noise floor calibration timeout (2412MHz)
[ 5782.728535] ath5k phy0: failed to wakeup the MAC Chip
[ 5782.728551] ath5k phy0: can't reset hardware (-5)
[ 5782.768293] ath5k phy0: failed to wakeup the MAC Chip
[ 5782.768303] ath5k phy0: can't reset hardware (-5)
[ 5782.822578] ath5k phy0: failed to wakeup the MAC Chip
[ 5782.822593] ath5k phy0: can't reset hardware (-5)
[ 5782.875552] ath5k phy0: failed to wakeup the MAC Chip
[ 5782.875566] ath5k phy0: can't reset hardware (-5)
[ 5782.918854] ath5k phy0: failed to wakeup the MAC Chip
[ 5788.256463] __ratelimit: 13 callbacks suppressed
[ 5788.256473] ath5k phy0: failed to wakeup the MAC Chip
[ 5788.256483] ath5k phy0: can't reset hardware (-5)
[ 5788.299282] ath5k phy0: failed to wakeup the MAC Chip
[ 5788.299294] ath5k phy0: can't reset hardware (-5)
[ 5788.352425] ath5k phy0: failed to wakeup the MAC Chip
[ 5788.352437] ath5k phy0: can't reset hardware (-5)
[ 5788.402450] ath5k phy0: failed to wakeup the MAC Chip
[ 5788.402462] ath5k phy0: can't reset hardware (-5)
[ 5788.457462] ath5k phy0: failed to wakeup the MAC Chip
[ 5788.457474] ath5k phy0: can't reset hardware (-5)
[ 5793.345245] __ratelimit: 12 callbacks suppressed
[ 5793.345255] ath5k phy0: noise floor calibration timeout (2412MHz)
[ 5793.881757] ath5k phy0: failed to wakeup the MAC Chip
[ 5793.881773] ath5k phy0: can't reset hardware (-5)
[ 5793.924596] ath5k phy0: failed to wakeup the MAC Chip
[ 5793.924609] ath5k phy0: can't reset hardware (-5)
[ 5793.979648] ath5k phy0: failed to wakeup the MAC Chip
[ 5793.979662] ath5k phy0: can't reset hardware (-5)
[ 5794.037673] ath5k phy0: failed to wakeup the MAC Chip
[ 5794.037688] ath5k phy0: can't reset hardware (-5)
[ 5794.089561] ath5k phy0: failed to wakeup the MAC Chip
[ 5803.075500] __ratelimit: 35 callbacks suppressed
[ 5803.075509] ath5k phy0: failed to wakeup the MAC Chip
[ 5803.075518] ath5k phy0: can't reset hardware (-5)
[ 5803.119747] ath5k phy0: failed to wakeup the MAC Chip
[ 5803.119761] ath5k phy0: can't reset hardware (-5)
[ 5803.161294] ath5k phy0: failed to wakeup the MAC Chip
[ 5803.161305] ath5k phy0: can't reset hardware (-5)
[ 5803.200990] ath5k phy0: failed to wakeup the MAC Chip
[ 5803.200999] ath5k phy0: can't reset hardware (-5)
[ 5803.245784] ath5k phy0: failed to wakeup the MAC Chip
[ 5803.245796] ath5k phy0: can't reset hardware (-5)
[ 5808.586487] __ratelimit: 13 callbacks suppressed
[ 5808.586497] ath5k phy0: failed to wakeup the MAC Chip
[ 5808.586506] ath5k phy0: can't reset hardware (-5)
[ 5808.629640] ath5k phy0: failed to wakeup the MAC Chip
[ 5808.629653] ath5k phy0: can't reset hardware (-5)
[ 5808.669017] ath5k phy0: failed to wakeup the MAC Chip
[ 5808.669025] ath5k phy0: can't reset hardware (-5)
[ 5808.779474] ath5k phy0: failed to wakeup the MAC Chip
[ 5808.779489] ath5k phy0: can't reset hardware (-5)
[ 5808.848331] ath5k phy0: failed to wakeup the MAC Chip
[ 5808.848345] ath5k phy0: can't reset hardware (-5)
[ 5814.339464] __ratelimit: 12 callbacks suppressed
[ 5814.339473] ath5k phy0: failed to wakeup the MAC Chip
[ 5814.339483] ath5k phy0: can't reset hardware (-5)
[ 5814.381830] ath5k phy0: failed to wakeup the MAC Chip
[ 5814.381842] ath5k phy0: can't reset hardware (-5)
[ 5814.425552] ath5k phy0: failed to wakeup the MAC Chip
[ 5814.425565] ath5k phy0: can't reset hardware (-5)
[ 5814.465221] ath5k phy0: failed to wakeup the MAC Chip
[ 5814.465230] ath5k phy0: can't reset hardware (-5)
[ 5814.508194] ath5k phy0: failed to wakeup the MAC Chip
[ 5814.508206] ath5k phy0: can't reset hardware (-5)
[ 5819.851562] __ratelimit: 13 callbacks suppressed
[ 5819.851571] ath5k phy0: failed to wakeup the MAC Chip
[ 5819.851581] ath5k phy0: can't reset hardware (-5)
[ 5819.895810] ath5k phy0: failed to wakeup the MAC Chip
[ 5819.895823] ath5k phy0: can't reset hardware (-5)
[ 5819.952022] ath5k phy0: failed to wakeup the MAC Chip
[ 5819.952035] ath5k phy0: can't reset hardware (-5)
[ 5819.996475] ath5k phy0: failed to wakeup the MAC Chip
[ 5819.996489] ath5k phy0: can't reset hardware (-5)
[ 5820.035965] ath5k phy0: failed to wakeup the MAC Chip
[ 5820.035974] ath5k phy0: can't reset hardware (-5)
[ 5825.463631] __ratelimit: 12 callbacks suppressed
[ 5825.463639] ath5k phy0: failed to wakeup the MAC Chip
[ 5825.463649] ath5k phy0: can't reset hardware (-5)
[ 5825.506403] ath5k phy0: failed to wakeup the MAC Chip
[ 5825.506415] ath5k phy0: can't reset hardware (-5)
[ 5825.564295] ath5k phy0: failed to wakeup the MAC Chip
[ 5825.564309] ath5k phy0: can't reset hardware (-5)
[ 5825.608777] ath5k phy0: failed to wakeup the MAC Chip
[ 5825.608790] ath5k phy0: can't reset hardware (-5)
[ 5825.654880] ath5k phy0: failed to wakeup the MAC Chip
[ 5825.654894] ath5k phy0: can't reset hardware (-5)
[ 5831.415476] __ratelimit: 13 callbacks suppressed
[ 5831.415485] ath5k phy0: failed to wakeup the MAC Chip
[ 5831.415496] ath5k phy0: can't reset hardware (-5)
[ 5831.458800] ath5k phy0: failed to wakeup the MAC Chip
[ 5831.458813] ath5k phy0: can't reset hardware (-5)
[ 5831.501080] ath5k phy0: failed to wakeup the MAC Chip
[ 5831.501092] ath5k phy0: can't reset hardware (-5)
[ 5831.604365] ath5k phy0: failed to wakeup the MAC Chip
[ 5831.604379] ath5k phy0: can't reset hardware (-5)
[ 5831.647234] ath5k phy0: failed to wakeup the MAC Chip
[ 5831.647246] ath5k phy0: can't reset hardware (-5)
[ 5834.122061] ath5k 0000:01:00.0: PCI INT A disabled
[ 5836.901310] pci 0000:01:00.0: reg 10 64bit mmio: [0x000000-0x00ffff]
[ 5836.901973] ath5k 0000:01:00.0: enabling device (0000 -> 0002)
[ 5836.901994] ath5k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[ 5836.902055] ath5k 0000:01:00.0: setting latency timer to 64
[ 5836.907782] ath5k 0000:01:00.0: registered as 'phy1'
[ 5837.054154] phy1: Selected rate control algorithm 'minstrel'
[ 5837.057517] ath5k phy1: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[ 5850.472102] wlan0: authenticate with AP 00:01:38:d6:0b:4f
[ 5850.474140] wlan0: authenticated
[ 5850.474149] wlan0: associate with AP 00:01:38:d6:0b:4f
[ 5850.476700] wlan0: RX AssocResp from 00:01:38:d6:0b:4f (capab=0x431 status=0 aid=2)
[ 5850.476708] wlan0: associated

Another weird thing that I've noticed with 2.6.30 kernels (although it
might be happening with older ones) is that periodically (maybe once a
day) the packet loss between the computer and the access point will
become very high and will stay that way until the computer is rebooted.
I do not know if toggling via rfkill will also solve that problem.

-- 
Sitsofe | http://sucs.org/~sits/

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZBQVBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZBQVBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbZBQVBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:01:33 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:50474 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbZBQVBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:01:30 -0500
Date: Tue, 17 Feb 2009 22:01:20 +0100
To: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: MMC device only working properly after one suspend-resume cycle
Message-ID: <20090217210119.GB18584@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

(or is there someone else who can help???)


It seems that it should be quite easy to fix that.

Before suspend -> device does not work properly
After suspend and resume -> device works properly

So there must be a way to check what makes the difference and implement
it.

If only someone gives a hint ...

Best wishes

Norbert


On Di, 03 Feb 2009, preining wrote:
> Ok, here are my test. I was wrong in the previous email. The card does
> not have to be in the slot:
> 
> Tests, all with kernel 2.6.29-rc3
> 
> - normal boot without card in the slot -> not detected
>   . suspending with OR without card in the slot makes it work!!!!
>     (that is new, I thought that the card has to be in the slot!)
>   . re-ejecting and re-inserting always make the card show up
>     One sequence of eject/re-insert's syslog output is attached.
>        meant was AFTER a suspend/resume cycle the ejecting/re-inserting
>        always makes the card show up.
> 
> - normal boot WITH card in the slot -> detected!!!
> 
> All tests were made with and without ricoh_mmc built into the kernel. It
> does not change anything, so ricoh_mmc does not do anything at all here,
> can be disabled.
> 
> Hmm, isn't there a way to read the pci settings and see the difference?
> Could it make *the* difference?
> restaurants.
> 			--- Douglas Adams, The Meaning of Liff

> Feb  3 00:14:14 mithrandir kernel: [ 2844.592135] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000080
> Feb  3 00:14:14 mithrandir kernel: [ 2844.792096] mmc0: starting CMD13 arg bffc0000 flags 00000195
> Feb  3 00:14:14 mithrandir kernel: [ 2844.794120] mmc0: req failed (CMD13): -123, retrying...
> Feb  3 00:14:14 mithrandir kernel: [ 2844.796116] mmc0: req failed (CMD13): -123, retrying...
> Feb  3 00:14:14 mithrandir kernel: [ 2844.798123] mmc0: req failed (CMD13): -123, retrying...
> Feb  3 00:14:14 mithrandir kernel: [ 2844.800126] mmc0: req done (CMD13): -123: 00000000 00000000 00000000 00000000
> Feb  3 00:14:14 mithrandir kernel: [ 2844.800676] mmc0: card bffc removed
> Feb  3 00:14:14 mithrandir kernel: [ 2844.800683] PM: Removing info for mmc:mmc0:bffc
> Feb  3 00:14:14 mithrandir hald[4047]: forcibly attempting to lazy unmount /dev/mmcblk0p1 as enclosing drive was disconnected
> Feb  3 00:14:14 mithrandir kernel: [ 2844.802785] PM: Removing info for No Bus:mmcblk0p1
> Feb  3 00:14:14 mithrandir kernel: [ 2844.803517] PM: Removing info for No Bus:179:0
> Feb  3 00:14:14 mithrandir kernel: [ 2844.804126] PM: Removing info for No Bus:mmcblk0
> Feb  3 00:14:14 mithrandir kernel: [ 2844.804818] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
> Feb  3 00:14:14 mithrandir hald: unmounted /dev/mmcblk0p1 from '/media/BIGCARD' on behalf of uid 0
> Feb  3 00:14:17 mithrandir kernel: [ 2848.297046] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000040
> Feb  3 00:14:18 mithrandir kernel: [ 2848.496081] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.498154] mmc0: clock 128906Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.500149] mmc0: clock 128906Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.501268] mmc0: starting CMD0 arg 00000000 flags 000000c0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.501622] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.501632] mmc0: req done (CMD0): 0: 00000000 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.502643] mmc0: clock 128906Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.503643] mmc0: starting CMD8 arg 000001aa flags 000002f5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.504297] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.506313] mmc0: req done (CMD8): -110: 00000000 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.506917] mmc0: starting CMD5 arg 00000000 flags 000002e1
> Feb  3 00:14:18 mithrandir kernel: [ 2848.507574] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.509590] mmc0: req failed (CMD5): -110, retrying...
> Feb  3 00:14:18 mithrandir kernel: [ 2848.510248] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.512245] mmc0: req failed (CMD5): -110, retrying...
> Feb  3 00:14:18 mithrandir kernel: [ 2848.512903] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.514898] mmc0: req failed (CMD5): -110, retrying...
> Feb  3 00:14:18 mithrandir kernel: [ 2848.515554] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.517568] mmc0: req done (CMD5): -110: 00000000 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.518055] mmc0: starting CMD55 arg 00000000 flags 000000f5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.518730] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.518741] mmc0: req done (CMD55): 0: 00400120 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.518759] mmc0: starting CMD41 arg 00000000 flags 000000e1
> Feb  3 00:14:18 mithrandir kernel: [ 2848.519404] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.519416] mmc0: req done (CMD41): 0: 00ff8000 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.519439] mmc0: clock 128906Hz busmode 1 powermode 2 cs 0 Vdd 20 width 0 timing 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.519448] mmc0: clock 128906Hz busmode 1 powermode 2 cs 1 Vdd 20 width 0 timing 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.520448] mmc0: starting CMD0 arg 00000000 flags 000000c0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.520798] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.520808] mmc0: req done (CMD0): 0: 00000000 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.521841] mmc0: clock 128906Hz busmode 1 powermode 2 cs 0 Vdd 20 width 0 timing 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.522840] mmc0: starting CMD8 arg 000001aa flags 000002f5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.523497] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.525507] mmc0: req done (CMD8): -110: 00000000 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.525551] mmc0: starting CMD55 arg 00000000 flags 000000f5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.526232] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.526243] mmc0: req done (CMD55): 0: 00400120 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.526287] mmc0: starting CMD41 arg 00300000 flags 000000e1
> Feb  3 00:14:18 mithrandir kernel: [ 2848.526934] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.526944] mmc0: req done (CMD41): 0: 00ff8000 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.540057] mmc0: starting CMD55 arg 00000000 flags 000000f5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.540708] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.540720] mmc0: req done (CMD55): 0: 00000120 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.540763] mmc0: starting CMD41 arg 00300000 flags 000000e1
> Feb  3 00:14:18 mithrandir kernel: [ 2848.541384] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.541396] mmc0: req done (CMD41): 0: 00ff8000 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.556060] mmc0: starting CMD55 arg 00000000 flags 000000f5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.556733] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.556745] mmc0: req done (CMD55): 0: 00000120 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.556766] mmc0: starting CMD41 arg 00300000 flags 000000e1
> Feb  3 00:14:18 mithrandir kernel: [ 2848.557390] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.557401] mmc0: req done (CMD41): 0: 00ff8000 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.572073] mmc0: starting CMD55 arg 00000000 flags 000000f5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.572731] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.572741] mmc0: req done (CMD55): 0: 00000120 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.572757] mmc0: starting CMD41 arg 00300000 flags 000000e1
> Feb  3 00:14:18 mithrandir kernel: [ 2848.573379] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.573390] mmc0: req done (CMD41): 0: 00ff8000 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.588077] mmc0: starting CMD55 arg 00000000 flags 000000f5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.588731] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.588742] mmc0: req done (CMD55): 0: 00000120 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.588758] mmc0: starting CMD41 arg 00300000 flags 000000e1
> Feb  3 00:14:18 mithrandir kernel: [ 2848.589379] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.589390] mmc0: req done (CMD41): 0: 80ff8000 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.589436] mmc0: starting CMD2 arg 00000000 flags 00000067
> Feb  3 00:14:18 mithrandir kernel: [ 2848.590540] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.590559] mmc0: req done (CMD2): 0: 03534453 44303247 8030a708 e7006300
> Feb  3 00:14:18 mithrandir kernel: [ 2848.590581] mmc0: starting CMD3 arg 00000000 flags 00000075
> Feb  3 00:14:18 mithrandir kernel: [ 2848.591231] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.591241] mmc0: req done (CMD3): 0: bffc0520 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.591282] mmc0: clock 128906Hz busmode 2 powermode 2 cs 0 Vdd 20 width 0 timing 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.591290] mmc0: starting CMD9 arg bffc0000 flags 00000007
> Feb  3 00:14:18 mithrandir kernel: [ 2848.592374] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.592392] mmc0: req done (CMD9): 0: 00260032 5f5a83c9 3efbcfff d2804000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.592430] mmc0: starting CMD7 arg bffc0000 flags 00000015
> Feb  3 00:14:18 mithrandir kernel: [ 2848.593088] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.593099] mmc0: req done (CMD7): 0: 00000700 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.593117] mmc0: starting CMD55 arg bffc0000 flags 00000095
> Feb  3 00:14:18 mithrandir kernel: [ 2848.593773] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.593784] mmc0: req done (CMD55): 0: 00000920 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.593828] mmc0: starting CMD51 arg 00000000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.593834] mmc0:     blksz 8 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.594522] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.595080] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.595090] mmc0: req done (CMD51): 0: 00000920 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.595095] mmc0:     8 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.595135] mmc0: starting CMD6 arg 00fffff1 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.595140] mmc0:     blksz 64 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.595814] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.598456] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.598466] mmc0: req done (CMD6): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.598471] mmc0:     64 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.598491] mmc0: clock 25000000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 0 timing 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.598500] mmc0: starting CMD55 arg bffc0000 flags 00000095
> Feb  3 00:14:18 mithrandir kernel: [ 2848.598541] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.598552] mmc0: req done (CMD55): 0: 00000920 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.598592] mmc0: starting CMD6 arg 00000002 flags 00000015
> Feb  3 00:14:18 mithrandir kernel: [ 2848.598630] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.598640] mmc0: req done (CMD6): 0: 00000920 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.598652] mmc0: clock 25000000Hz busmode 2 powermode 2 cs 0 Vdd 20 width 2 timing 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.598663] mmc0: new SD card at address bffc
> Feb  3 00:14:18 mithrandir kernel: [ 2848.598710] PM: Adding info for mmc:mmc0:bffc
> Feb  3 00:14:18 mithrandir kernel: [ 2848.601158] mmc0: starting CMD16 arg 00000200 flags 00000095
> Feb  3 00:14:18 mithrandir kernel: [ 2848.601201] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.601211] mmc0: req done (CMD16): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.601225] mmcblk0: mmc0:bffc SD02G 1.89 GiB 
> Feb  3 00:14:18 mithrandir kernel: [ 2848.601289] PM: Adding info for No Bus:mmcblk0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.601322]  mmcblk0:<7>mmc0: starting CMD18 arg 00000000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.601382] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.601387] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.601410] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.602027] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.602049] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.602062] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.602067] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.602071] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.602140]  p1
> Feb  3 00:14:18 mithrandir kernel: [ 2848.602177] PM: Adding info for No Bus:mmcblk0p1
> Feb  3 00:14:18 mithrandir kernel: [ 2848.602299] PM: Adding info for No Bus:179:0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.653618] mmc0: starting CMD18 arg 00000000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.653626] mmc0:     blksz 512 blocks 32 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.653631] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.653682] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.655309] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.655363] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.655375] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.655380] mmc0:     16384 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.655385] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.655485] mmc0: starting CMD18 arg 79270000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.655490] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.655496] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.655540] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.656293] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.656314] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.656325] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.656330] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.656335] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.656422] mmc0: starting CMD18 arg 7927e000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.656427] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.656433] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.656482] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.657072] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.657093] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.657104] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.657109] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.657114] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.657255] mmc0: starting CMD18 arg 7927f000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.657261] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.657267] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.657308] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.657856] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.657900] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.657910] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.657915] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.657920] mmc0:     (CMD12): 0: 80000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.658009] mmc0: starting CMD18 arg 00004000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.658015] mmc0:     blksz 512 blocks 64 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.658020] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.658041] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.661083] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.661119] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.661124] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.661126] mmc0:     32768 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.661127] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.661149] mmc0: starting CMD18 arg 79278000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.661151] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.661152] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.661182] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.661831] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.661858] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.661863] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.661864] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.661866] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.661886] mmc0: starting CMD18 arg 79260000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.661888] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.661889] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.661923] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.662623] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.662650] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.662655] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.662656] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.662658] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.662715] mmc0: starting CMD18 arg 7924e000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.662716] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.662718] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.662752] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.663363] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.663397] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.663401] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.663402] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.663404] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.663516] mmc0: starting CMD18 arg 0000c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.663518] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.663519] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.663553] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.669338] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.669385] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.669389] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.669391] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.669393] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.669421] mmc0: starting CMD18 arg 0001c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.669423] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.669425] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.669441] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.675273] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.675320] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.675325] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.675326] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.675328] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.675357] mmc0: starting CMD18 arg 0002c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.675359] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.675360] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.675396] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.681192] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.681240] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.681245] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.681246] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.681248] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.681282] mmc0: starting CMD18 arg 00040000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.681283] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.681285] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.681325] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.681942] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.681976] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.681980] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.681982] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.681984] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.684872] mmc0: starting CMD18 arg 00000000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.684875] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.684876] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.684893] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.685515] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.685550] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.685555] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.685557] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.685558] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.685590] mmc0: starting CMD18 arg 00001000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.685592] mmc0:     blksz 512 blocks 24 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.685593] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.685608] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.686880] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.686915] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.686919] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.686921] mmc0:     12288 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.686923] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.686937] mmc0: starting CMD18 arg 00007e00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.686939] mmc0:     blksz 512 blocks 32 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.686940] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.686975] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.688874] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.688911] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.688916] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.688917] mmc0:     16384 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.688919] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.688959] mmc0: starting CMD18 arg 79270000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.688961] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.688963] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.688997] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.689607] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.689640] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.689644] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.689646] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.689647] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.689660] mmc0: starting CMD18 arg 79267e00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.689661] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.689663] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.689678] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.690226] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.690259] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.690264] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.690265] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.690267] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.690297] mmc0: starting CMD18 arg 7927de00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.690298] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.690300] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.690313] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.690902] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.690929] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.690934] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.690935] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.690937] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.691022] mmc0: starting CMD18 arg 7927e000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.691024] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.691026] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.691060] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.691670] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.691703] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.691708] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.691709] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.691711] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.691722] mmc0: starting CMD17 arg 7927fe00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.691724] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.691738] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.692013] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.692027] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.692029] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.692274] mmc0: starting CMD18 arg 0000be00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.692276] mmc0:     blksz 512 blocks 64 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.692277] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.692292] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.695289] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.695330] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.695335] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.695336] mmc0:     32768 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.695338] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.695366] mmc0: starting CMD18 arg 7927ee00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.695368] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.695370] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.695404] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.696004] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.696031] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.696036] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.696037] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.696039] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.696086] mmc0: starting CMD18 arg 7927f000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.696088] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.696090] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.696120] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.696695] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.696725] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.696729] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.696730] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.696732] mmc0:     (CMD12): 0: 80000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.696743] mmc0: starting CMD18 arg 00004000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.696745] mmc0:     blksz 512 blocks 64 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.696746] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.696761] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.699810] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.699844] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.699848] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.699850] mmc0:     32768 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.699851] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.699870] mmc0: starting CMD18 arg 79277e00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.699872] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.699873] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.699907] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.700520] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.700548] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.700553] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.700554] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.700556] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.700583] mmc0: starting CMD18 arg 79278000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.700585] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.700586] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.700621] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.701380] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.701413] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.701418] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.701419] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.701421] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.701431] mmc0: starting CMD18 arg 7925fe00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.701433] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.701435] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.701450] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.702123] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.702157] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.702161] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.702163] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.702164] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.702178] mmc0: starting CMD18 arg 79260000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.702180] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.702181] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.702197] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.702829] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.702856] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.702860] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.702862] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.702863] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.702892] mmc0: starting CMD18 arg 7924de00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.702894] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.702896] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.702909] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.703514] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.703547] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.703552] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.703553] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.703555] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.703567] mmc0: starting CMD18 arg 7924e000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.703568] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.703570] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.703584] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.704209] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.704222] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.704227] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.704228] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.704230] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.704258] mmc0: starting CMD18 arg 003d2e00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.704259] mmc0:     blksz 512 blocks 16 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.704261] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.704282] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.705279] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.705308] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.705312] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.705314] mmc0:     8192 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.705315] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.705348] mmc0: starting CMD18 arg 0000c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.705350] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.705351] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.705384] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.711190] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.711241] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.711246] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.711247] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.711249] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.711293] mmc0: starting CMD18 arg 0001c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.711295] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.711296] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.711311] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.717113] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.717161] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.717165] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.717167] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.717168] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.717195] mmc0: starting CMD18 arg 0002c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.717197] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.717199] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.717234] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.723045] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.723086] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.723091] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.723093] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.723094] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.723120] mmc0: starting CMD18 arg 00040000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.723122] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.723123] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.723159] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.723793] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.723820] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.723825] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.723826] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.723828] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.728692] mmc0: starting CMD18 arg 00007e00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.728694] mmc0:     blksz 512 blocks 24 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.728696] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.728712] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.730263] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.730300] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.730306] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.730307] mmc0:     12288 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.730309] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.730330] mmc0: starting CMD18 arg 0000ae00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.730331] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.730333] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.730347] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.730944] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.730956] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.730961] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.730963] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.730965] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.730994] mmc0: starting CMD18 arg 79267e00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.730996] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.730997] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.731027] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.731563] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.731598] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.731603] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.731605] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.731606] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.731691] mmc0: starting CMD18 arg 7927de00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.731692] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.731694] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.731707] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.732257] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.732273] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.732279] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.732280] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.732282] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.733124] mmc0: starting CMD18 arg 0000be00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.733126] mmc0:     blksz 512 blocks 2 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.733128] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.733143] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.733452] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.733486] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.733491] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.733493] mmc0:     1024 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.733494] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.733515] mmc0: starting CMD18 arg 0000c200 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.733517] mmc0:     blksz 512 blocks 62 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.733519] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.733533] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.736492] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.736529] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.736533] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.736535] mmc0:     31744 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.736537] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.736564] mmc0: starting CMD17 arg 7927fe00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.736566] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.736601] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.736857] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.736861] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.736863] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.736916] mmc0: starting CMD18 arg 7927ee00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.736918] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.736920] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.736953] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.737534] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.737564] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.737569] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.737570] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.737572] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.737633] mmc0: starting CMD18 arg 79277e00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.737634] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.737636] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.737669] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.738261] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.738288] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.738292] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.738294] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.738295] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.738318] mmc0: starting CMD17 arg 7925fe00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.738320] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.738349] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.738740] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.738744] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.738745] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.738754] mmc0: starting CMD18 arg 79260000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.738756] mmc0:     blksz 512 blocks 7 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.738757] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.738787] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.739348] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.739381] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.739386] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.739387] mmc0:     3584 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.739389] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.739430] mmc0: starting CMD17 arg 7924de00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.739432] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.739455] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.739738] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.739741] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.739743] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.739766] mmc0: starting CMD18 arg 7924e000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.739768] mmc0:     blksz 512 blocks 7 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.739769] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.739804] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.740358] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.740371] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.740376] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.740377] mmc0:     3584 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.740379] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.740428] mmc0: starting CMD17 arg 003d2e00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.740430] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.740445] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.740716] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.740721] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.740722] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.740731] mmc0: starting CMD18 arg 003d3000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.740733] mmc0:     blksz 512 blocks 15 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.740734] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.740749] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.741659] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.741688] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.741693] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.741694] mmc0:     7680 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.741696] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.741783] mmc0: starting CMD18 arg 00000000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.741786] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.741787] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.741802] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.742414] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.742441] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.742446] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.742447] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.742449] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.742460] mmc0: starting CMD18 arg 00001000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.742462] mmc0:     blksz 512 blocks 24 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.742463] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.742493] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.743742] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.743772] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.743776] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.743777] mmc0:     12288 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.743779] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir hald: mounted /dev/mmcblk0p1 on behalf of uid 1000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.797689] FAT: utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
> Feb  3 00:14:18 mithrandir kernel: [ 2848.797727] mmc0: starting CMD17 arg 00007e00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.797730] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.797768] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798029] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798035] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798036] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798053] mmc0: starting CMD17 arg 00008000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798055] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798090] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798336] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798340] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798342] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798366] mmc0: starting CMD17 arg 0000be00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798367] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798401] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798637] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798642] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798643] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798670] mmc0: starting CMD18 arg 003d3600 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798672] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798674] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.798707] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.799272] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.799301] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.799306] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.799308] mmc0:     4096 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.799309] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.819980] mmc0: starting CMD17 arg 003e8600 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.819983] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.820020] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.820269] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.820274] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.820276] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.820288] mmc0: starting CMD18 arg 003e8800 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.820290] mmc0:     blksz 512 blocks 7 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.820291] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.820327] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.820876] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.820911] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.820916] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.820917] mmc0:     3584 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.820919] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.829781] mmc0: starting CMD18 arg 0000c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.829784] mmc0:     blksz 512 blocks 13 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.829785] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.829817] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.830636] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.830667] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.830672] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.830674] mmc0:     6656 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.830675] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.830695] mmc0: starting CMD18 arg 0000da00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.830697] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.830698] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.830712] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.836465] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.836517] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.836523] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.836524] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.836526] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.836580] mmc0: starting CMD18 arg 0001da00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.836582] mmc0:     blksz 512 blocks 114 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.836584] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.836614] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.841769] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.841815] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.841820] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.841821] mmc0:     58368 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.841823] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.842018] mmc0: starting CMD17 arg 0002be00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.842019] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.842054] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.842295] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.842299] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.842306] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.842317] mmc0: starting CMD18 arg 0002c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.842319] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.842320] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.842350] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.848128] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.848175] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.848180] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.848182] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.848183] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.848224] mmc0: starting CMD18 arg 0003c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.848226] mmc0:     blksz 512 blocks 127 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.848228] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.848258] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.854018] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.854059] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.854064] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.854065] mmc0:     65024 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.854067] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.854271] mmc0: starting CMD17 arg 0004be00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.854273] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.854308] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.854551] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.854555] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.854557] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.854567] mmc0: starting CMD18 arg 0004c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.854568] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.854570] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.854599] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.860361] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.860397] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.860402] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.860404] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.860405] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.860753] mmc0: starting CMD18 arg 0005c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.860755] mmc0:     blksz 512 blocks 127 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.860761] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.860792] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.866514] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.866561] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.866567] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.866568] mmc0:     65024 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.866570] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.866803] mmc0: starting CMD18 arg 0006be00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.866804] mmc0:     blksz 512 blocks 16 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.866806] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.866821] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.867760] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.867788] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.867793] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.867794] mmc0:     8192 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.867796] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.867813] mmc0: starting CMD18 arg 0006de00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.867814] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.867816] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.867846] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.873625] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.873666] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.873671] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.873673] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.873674] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.873719] mmc0: starting CMD18 arg 0007de00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.873721] mmc0:     blksz 512 blocks 112 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.873722] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.873753] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.878828] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x0000000a
> Feb  3 00:14:18 mithrandir kernel: [ 2848.878868] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.878873] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.878875] mmc0:     57344 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.878876] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.879059] mmc0: starting CMD17 arg 0008be00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.879067] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.879103] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.879320] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.879324] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.879326] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.879364] mmc0: starting CMD18 arg 0008c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.879365] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.879367] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.879392] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.885188] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.885230] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.885235] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.885236] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.885238] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.885282] mmc0: starting CMD18 arg 0009c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.885283] mmc0:     blksz 512 blocks 127 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.885285] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.885315] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.891071] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.891112] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.891117] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.891119] mmc0:     65024 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.891120] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.891329] mmc0: starting CMD17 arg 000abe00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.891331] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.891367] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.891609] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.891613] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.891615] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.891625] mmc0: starting CMD18 arg 000ac000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.891626] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.891628] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.891658] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.897447] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.897489] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.897494] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.897496] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.897498] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.897544] mmc0: starting CMD18 arg 000bc000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.897546] mmc0:     blksz 512 blocks 127 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.897547] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.897578] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.903306] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.903350] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.903355] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.903357] mmc0:     65024 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.903358] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.903571] mmc0: starting CMD17 arg 000cbe00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.903572] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.903589] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.903844] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.903848] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.903850] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.903861] mmc0: starting CMD18 arg 000cc000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.903862] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.903864] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.903878] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.909671] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.909712] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.909717] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.909719] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.909720] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.923162] mmc0: starting CMD18 arg 000dc000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.923164] mmc0:     blksz 512 blocks 127 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.923166] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.923198] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.928934] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.928982] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.928987] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.928989] mmc0:     65024 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.928990] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.929292] mmc0: starting CMD17 arg 000ebe00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.929294] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.929325] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.929566] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.929571] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.929572] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.929585] mmc0: starting CMD18 arg 000ec000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.929587] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.929589] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.929618] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.935397] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.935439] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.935444] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.935445] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.935447] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.935492] mmc0: starting CMD18 arg 000fc000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.935494] mmc0:     blksz 512 blocks 127 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.935496] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.935526] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.941262] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.941305] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.941310] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.941312] mmc0:     65024 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.941314] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.941521] mmc0: starting CMD17 arg 0010be00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.941523] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.941555] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.941801] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.941805] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.941807] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.941817] mmc0: starting CMD18 arg 0010c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.941819] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.941821] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.941851] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.947636] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.947680] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.947685] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.947686] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.947688] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.947731] mmc0: starting CMD18 arg 0011c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.947733] mmc0:     blksz 512 blocks 127 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.947735] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.947765] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.953520] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.953549] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.953554] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.953556] mmc0:     65024 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.953557] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.953762] mmc0: starting CMD17 arg 0012be00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.953764] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.953795] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.954025] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.954029] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.954030] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.954040] mmc0: starting CMD18 arg 0012c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.954041] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.954043] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.954074] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.959856] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.959884] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.959889] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.959891] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.959893] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.964050] mmc0: starting CMD18 arg 0013c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.964052] mmc0:     blksz 512 blocks 127 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.964054] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.964069] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.969828] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.969871] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.969877] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.969878] mmc0:     65024 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.969880] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.970086] mmc0: starting CMD17 arg 0014be00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.970088] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.970119] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.970366] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.970370] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.970372] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.970383] mmc0: starting CMD18 arg 0014c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.970384] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.970386] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.970417] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.976201] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.976247] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.976252] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.976254] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.976255] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.976301] mmc0: starting CMD18 arg 0015c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.976303] mmc0:     blksz 512 blocks 127 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.976305] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.976334] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.982099] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.982142] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.982146] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.982148] mmc0:     65024 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.982149] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.982364] mmc0: starting CMD17 arg 0016be00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.982365] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.982402] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.982625] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.982629] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.982631] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.985043] mmc0: starting CMD17 arg 0016c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.985045] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.985061] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.985325] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.985330] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.985332] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.985363] mmc0: starting CMD18 arg 0016c200 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.985365] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.985367] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.985385] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.991183] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.991210] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.991215] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.991217] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.991218] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.991281] mmc0: starting CMD18 arg 0017c200 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.991283] mmc0:     blksz 512 blocks 126 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.991284] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.991299] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.997024] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.997068] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2848.997073] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.997075] mmc0:     64512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.997077] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.997356] mmc0: starting CMD17 arg 0018be00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.997358] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.997372] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2848.997641] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2848.997645] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2848.997647] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.997676] mmc0: starting CMD18 arg 0018c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2848.997678] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2848.997680] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2848.997695] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2849.003505] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2849.003550] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2849.003554] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2849.003556] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.003557] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2849.003605] mmc0: starting CMD18 arg 0019c000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2849.003607] mmc0:     blksz 512 blocks 127 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.003608] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2849.003623] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2849.009397] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2849.009440] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2849.009445] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2849.009447] mmc0:     65024 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.009448] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2849.009687] mmc0: starting CMD18 arg 001abe00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2849.009689] mmc0:     blksz 512 blocks 16 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.009690] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2849.009704] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2849.010650] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2849.010679] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2849.010684] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2849.010686] mmc0:     8192 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.010687] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2849.010704] mmc0: starting CMD18 arg 001ade00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2849.010706] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.010708] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2849.010738] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2849.016516] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2849.016555] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2849.016560] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2849.016562] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.016564] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2849.016634] mmc0: starting CMD18 arg 001bde00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2849.016636] mmc0:     blksz 512 blocks 112 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.016637] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2849.016652] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2849.021736] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2849.021761] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2849.021766] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2849.021768] mmc0:     57344 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.021769] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2849.021972] mmc0: starting CMD17 arg 001cbe00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2849.021974] mmc0:     blksz 512 blocks 1 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.021989] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2849.022234] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2849.022238] mmc0: req done (CMD17): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2849.022239] mmc0:     512 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.022268] mmc0: starting CMD18 arg 001cc000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2849.022269] mmc0:     blksz 512 blocks 128 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.022271] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2849.022295] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2849.028097] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2849.028141] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2849.028146] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2849.028148] mmc0:     65536 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.028149] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2849.028214] mmc0: starting CMD18 arg 001dc000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2849.028216] mmc0:     blksz 512 blocks 127 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.028218] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2849.028232] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2849.034008] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2849.034053] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2849.034058] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2849.034059] mmc0:     65024 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.034060] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2849.034300] mmc0: starting CMD18 arg 001ebe00 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2849.034302] mmc0:     blksz 512 blocks 17 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.034304] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2849.034340] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2849.035308] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2849.035338] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2849.035343] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2849.035344] mmc0:     8704 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.035346] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2849.035379] mmc0: starting CMD18 arg 001ee000 flags 000000b5
> Feb  3 00:14:18 mithrandir kernel: [ 2849.035380] mmc0:     blksz 512 blocks 13 flags 00000200 tsac 100 ms nsac 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.035382] mmc0:     CMD12 arg 00000000 flags 0000049d
> Feb  3 00:14:18 mithrandir kernel: [ 2849.035404] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
> Feb  3 00:14:18 mithrandir kernel: [ 2849.036262] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000002
> Feb  3 00:14:18 mithrandir kernel: [ 2849.036289] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000003
> Feb  3 00:14:18 mithrandir kernel: [ 2849.036294] mmc0: req done (CMD18): 0: 00000900 00000000 00000000 00000000
> Feb  3 00:14:18 mithrandir kernel: [ 2849.036296] mmc0:     6656 bytes transferred: 0
> Feb  3 00:14:18 mithrandir kernel: [ 2849.036297] mmc0:     (CMD12): 0: 00000b00 00000000 00000000 00000000


-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
OZARK (n.)
One who offers to help just after all the work has been done.
			--- Douglas Adams, The Meaning of Liff
